extension ATLogOC {
    public static var foriPad:ATLogForiPad {
        ATLogForiPad.shared
    }
}

extension ATLog {
    public static var foriPad:ATLogForiPad {
        ATLogForiPad.shared
    }
}

public class ATLogForiPad {
    public static let shared = ATLogForiPad()
    
    public func startup() {
        ATLog.add(delegate: self)
    }
}

extension ATLogForiPad: ATLogDelegate {
    
    public func log(level: ATLogLevel, log: String, tag: String?, message: String) {
        print(log + "(iPad)")
    }
}
