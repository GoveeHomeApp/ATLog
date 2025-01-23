import Foundation
import CocoaLumberjack

class ATLoggerFileManager: DDLogFileManagerDefault {
    
    static let dateFormatter = DateFormatter()
    
    static func dateFormat(date:Date = Date(), format:String = "yyyy-MM-dd HH:mm:ss") -> String {
        dateFormatter.timeZone = NSTimeZone.system
        dateFormatter.locale = Locale.init(identifier: Locale.preferredLanguages.first!)
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    override var newLogFileName: String {
        let fileName = "govee\(ATLoggerFileManager.dateFormat(format: "yyyyMMdd")).log"
        return fileName
    }
    override func isLogFile(withName fileName: String) -> Bool {
        return fileName.hasPrefix("govee") && fileName.hasSuffix(".log")
    }
}
extension ATLoggerFileManager:DDLogFormatter {
    func format(message logMessage: DDLogMessage) -> String? {
        return logMessage.message
    }
}



final class ATLogFormatter: NSObject, DDLogFormatter {
    
    func format(message logMessage: DDLogMessage) -> String? {
        return logMessage.message
    }
}


final class ATLogger: NSObject, DDLogger {
    
    override init() {
        super.init()
        logFormatter = ATLogFormatter()
    }
    
    var logFormatter: DDLogFormatter?
    
    func log(message logMessage: DDLogMessage) {
        let message = logFormatter?.format(message: logMessage) ?? logMessage.message
        print(message)
    }
    
    @objc static func verbose(_ log: String) {
        DDLogVerbose(log)
    }
    
    @objc static func debug(_ log: String) {
        DDLogDebug(log)
    }
    
    @objc static func info(_ log: String) {
        DDLogInfo(log)
    }
    
    @objc static func warn(_ log: String) {
        DDLogWarn(log)
    }
    
    @objc static func error(_ log: String) {
        DDLogError(log)
    }
}

