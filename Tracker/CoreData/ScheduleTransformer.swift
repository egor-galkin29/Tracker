import UIKit

final class ScheduleTransformer {
    static let shared = ScheduleTransformer()
    
    func daysToString(days: [WeekDays]) -> String {
        let stringDays = days.map {$0.rawValue}.joined(separator: ",")
        return stringDays
    }
    
    func stringToDays(stringDays: String) -> [WeekDays] {
        let days = stringDays.split(separator: ",").map {String($0)}
        let arrayDays = days.compactMap {WeekDays(rawValue: $0)}
        return arrayDays
    }
    
}
