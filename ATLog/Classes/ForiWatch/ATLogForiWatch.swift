extension ATLogOC {
    public static var foriWatch:ATLogForiWatch {
        ATLogForiWatch.shared
    }
}

extension ATLog {
    public static var foriWatch:ATLogForiWatch {
        ATLogForiWatch.shared
    }
}





public class ATLogForiWatch {
    public static let shared = ATLogForiWatch()
    
    public func startup() {
        ATLog.add(delegate: self)
    }
}

extension ATLogForiWatch: ATLogDelegate {
    
    public func log(level: ATLogLevel, log: String, tag: String?, message: String) {
        print(log + "(iWatch)")
    }
}
