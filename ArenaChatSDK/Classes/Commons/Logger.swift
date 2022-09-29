import Foundation

enum LogEvent: String {
    case error = "[‼️]"
    case debug = "[💬]"
    case warning = "[⚠️]"
}

protocol Logging {
    func log(object: Any)
    func log(object: Any, event: LogEvent)
}

struct Logger: Logging {

    private let isEnabled: Bool
    private let isVerbose: Bool

    init(isEnabled: Bool, isVerbose: Bool = false) {
        self.isEnabled = isEnabled
        self.isVerbose = isVerbose
    }

    func log(object: Any) {
        log(object: object, event: .debug)
    }

    func log(object: Any, event: LogEvent) {
        logEvent(object: object, event: event)
    }

    func logEvent(object: Any,
                          event: LogEvent,
                          filename: String = #file,
                          line: Int = #line,
                          column: Int = #column,
                          funcName: String = #function) {
        guard isEnabled else { return }

        if isVerbose {
            let firstLog = "\(event.rawValue)[\(sourceFileName(filePath: filename))]:\(line)"
            let secondLog = "\(column) \(funcName) -> \(String(describing: object))"
            print(firstLog + secondLog)
        } else {
            print("\(event.rawValue) \(String(describing: object))")
        }
    }

    private func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }

}
