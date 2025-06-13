@objc
public enum ATLogLevel:Int {
    case off
    case error
    case warn
    case info
    case debug
    case verbose
    
    public var key:String {
        switch self {
        case .off: "off"
        case .error: "error"
        case .warn: "warn"
        case .info: "info"
        case .debug: "debug"
        case .verbose: "verbose"
        }
    }
    public var key_short:String {
        switch self {
        case .off: "o"
        case .error: "e"
        case .warn: "w"
        case .info: "i"
        case .debug: "d"
        case .verbose: "v"
        }
    }
}

@objc
public protocol ATLogDelegate: AnyObject {
    func log(level:ATLogLevel, log:String, tag:String?, message:String)
}

protocol ATLogLevelDelegate: AnyObject {
    func logLevelChange(level:ATLogLevel)
}

@objc
public protocol ATLogCustomFormatDelegate: AnyObject {
    func logFormat(level:ATLogLevel, tag:String?, message:String) -> String?
}

fileprivate struct _ATLogService {
    static var weakContainer = NSHashTable<AnyObject>.weakObjects()
    static var delegates:[ATLogDelegate] {
        let objs = weakContainer.allObjects.compactMap({ $0 as? ATLogDelegate })
        return objs
    }
    static func add(delegate:ATLogDelegate) {
        weakContainer.add(delegate)
    }
    static func remove(delegate:ATLogDelegate) {
        weakContainer.remove(delegate)
    }
    static weak var customLogFormatDelegate:ATLogCustomFormatDelegate?
    static weak var logLevelDelegate:ATLogLevelDelegate?
    
    static var logCallback:((_ level:ATLogLevel, _ log:String, _ tag:String?, _ message:String) -> Void)?
}

@objcMembers
final public class ATLogOC:NSObject {
    /// 日志级别
    public static var level:ATLogLevel {
        get { ATLog.level }
        set { ATLog.level = newValue }
    }
    
    public static var customLogFormatDelegate:ATLogCustomFormatDelegate? {
        get { _ATLogService.customLogFormatDelegate }
        set { _ATLogService.customLogFormatDelegate = newValue }
    }
    
    public static func add(delegate:ATLogDelegate) {
        _ATLogService.add(delegate: delegate)
    }
    public static func remove(delegate:ATLogDelegate) {
        _ATLogService.remove(delegate: delegate)
    }
    
    public static func log(_ level:ATLogLevel, tag:String? = nil, messageCallback:(() -> String)) {
        ATLog.log(level, tag: tag, messageCallback: messageCallback)
    }
    
    ///这个是日志回调，用于处理日志的具体实现，打印日志不要调用这里
    public static var logCallback:((_ level:ATLogLevel, _ log:String, _ tag:String?, _ message:String) -> Void)? {
        set { ATLog.logCallback = newValue }
        get { return ATLog.logCallback }
    }
}

final public class ATLog {
    #if DEBUG || PDA || PRE || ADHOC
    public static var level:ATLogLevel = .debug {
        didSet {
            _ATLogService.logLevelDelegate?.logLevelChange(level: level)
        }
    }
    #else
    public static var level:ATLogLevel = .off {
        didSet {
            _ATLogService.logLevelDelegate?.logLevelChange(level: level)
        }
    }
    #endif
    public static var customLogFormatDelegate:ATLogCustomFormatDelegate? {
        get { _ATLogService.customLogFormatDelegate }
        set { _ATLogService.customLogFormatDelegate = newValue }
    }
    
    public static func add(delegate:ATLogDelegate) {
        _ATLogService.add(delegate: delegate)
    }
    public static func remove(delegate:ATLogDelegate) {
        _ATLogService.remove(delegate: delegate)
    }
    
    private static func canNext(_ level:ATLogLevel) -> Bool {
        guard level != .off else {
            return false
        }
        return level.rawValue <= self.level.rawValue
    }
    
    private static let formatter = DateFormatter()
    private static func next(level:ATLogLevel, tag:String?, message:String) {
        if let formatDelegate = _ATLogService.customLogFormatDelegate, let log = formatDelegate.logFormat(level: level, tag: tag, message: message) {
            _ATLogService.logCallback?(level, log, tag, message)
            _ATLogService.delegates.forEach { delegate in
                delegate.log(level: level, log: log, tag: tag, message: message)
            }
            return
        }
        let date = Date()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss.SSS"
        var time = formatter.string(from: date)
        
        if let t = tag, t.hasPrefix("log.") {
            if t == "log.d" || t == "log.db" || t == "log.di" {
                formatter.dateFormat = "dd-HH:mm:ss.SSS"
                time = formatter.string(from: date)
            }
            
            let _message = message.replacingOccurrences(of: "\n", with: "\n" + t + " ").replacingOccurrences(of: "\r", with: "\r" + t + " ")
            let log = "\(time) \(t) \(_message)"
            _ATLogService.logCallback?(level, log, tag, message)
            _ATLogService.delegates.forEach { delegate in
                delegate.log(level: level, log: log, tag: tag, message: message)
            }
        } else {
            let ctag = tag == nil ? "" : " \(tag ?? "")"
            let head = "\(level.key_short).log" + ctag
            let _message = message.replacingOccurrences(of: "\n", with: "\n" + head + " ").replacingOccurrences(of: "\r", with: "\r" + head + " ")
            let log = "\(time) \(head) \(_message)"
            _ATLogService.logCallback?(level, log, tag, message)
            _ATLogService.delegates.forEach { delegate in
                delegate.log(level: level, log: log, tag: tag, message: message)
            }
        }
    }
    
    public static func log(_ level:ATLogLevel, tag:String? = nil, messageCallback:(() -> String)) {
        guard canNext(level) else {
            return
        }
        let message = messageCallback()
        
        next(level: level, tag: tag, message: message)
    }
    
    public static func log(_ level: ATLogLevel, tag:String? = nil, args: Any..., separator: String = " ") {
        guard canNext(level) else {
            return
        }
        let message = args.map { "\($0)" }.joined(separator: separator)
        next(level: level, tag: tag, message: message)
    }
    
    ///这个是日志回调，用于处理日志的具体实现，打印日志不要调用这里
    public static var logCallback:((_ level:ATLogLevel, _ log:String, _ tag:String?, _ message:String) -> Void)? {
        set { _ATLogService.logCallback = newValue }
        get { return _ATLogService.logCallback }
    }
    
}
