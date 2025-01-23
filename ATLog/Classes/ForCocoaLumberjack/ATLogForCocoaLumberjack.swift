import Foundation
import CocoaLumberjack

extension ATLogOC {
    public static var forCocoaLumberjack:ATLogForCocoaLumberjack {
        ATLogForCocoaLumberjack.shared
    }
}

extension ATLog {
    public static var forCocoaLumberjack:ATLogForCocoaLumberjack {
        ATLogForCocoaLumberjack.shared
    }
}

@objcMembers
public class ATLogForCocoaLumberjack: NSObject {
    
    public static let shared = ATLogForCocoaLumberjack()
    
    private lazy var logFileManager = ATLoggerFileManager()
    private lazy var fileLogger = DDFileLogger(logFileManager: logFileManager)
    
    public func startup() {
        logLevel = ATLog.level
        
        DDLog.add(ATLogger())
        
        #if DEBUG
        
        fileLogger.rollingFrequency = 60 * 60 * 24 // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 30  //最大文件数
        fileLogger.maximumFileSize = 0
        fileLogger.logFileManager.logFilesDiskQuota = 1024*1024*1024*10
        fileLogger.logFormatter = logFileManager
        
        //文件
        DDLog.add(fileLogger)
        
        #endif
        
        ATLog.add(delegate: self)
    }
    
    public var currentLogFileName:String? {
        fileLogger.currentLogFileInfo?.fileName
    }
    
    private var logLevel: ATLogLevel = .debug {
        didSet {
            switch logLevel {
            case .off: dynamicLogLevel = .off
            case .error: dynamicLogLevel = .error
            case .warn: dynamicLogLevel = .warning
            case .info: dynamicLogLevel = .info
            case .debug: dynamicLogLevel = .debug
            case .verbose: dynamicLogLevel = .verbose
            }
        }
    }
}

extension ATLogForCocoaLumberjack: ATLogLevelDelegate {
    
    func logLevelChange(level: ATLogLevel) {
        logLevel = ATLog.level
    }
}

extension ATLogForCocoaLumberjack: ATLogDelegate {
    
    public func log(level: ATLogLevel, log: String, tag: String?, message: String) {
        switch level {
        case .verbose:
            ATLogger.verbose(log)
        case .debug:
            ATLogger.debug(log)
        case .info:
            ATLogger.info(log)
        case .warn:
            ATLogger.warn(log)
        case .error:
            ATLogger.error(log)
        default:
            break
        }
    }
}
