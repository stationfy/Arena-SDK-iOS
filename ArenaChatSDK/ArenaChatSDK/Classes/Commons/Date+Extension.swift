import Foundation

extension Date {
    func toString() -> String {
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "hh:mm"
        let dateString = dayTimePeriodFormatter.string(from: self)
        return dateString
    }
}
