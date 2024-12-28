import Foundation

enum WeekDays: String, CaseIterable {
    case monday = "monday"
    case tuesday = "tuesday"
    case wednesday = "wednesday"
    case thursday = "thursday"
    case friday = "friday"
    case saturday = "saturday"
    case sunday = "sunday"
    
    // Локализованное полное название дня недели
    var localizedName: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
    // Локализованное сокращенное название дня недели
    var shortDaysName: String {
        switch self {
        case .monday: return NSLocalizedString("mon", comment: "")
        case .tuesday: return NSLocalizedString("tue", comment: "")
        case .wednesday: return NSLocalizedString("wed", comment: "")
        case .thursday: return NSLocalizedString("thu", comment: "")
        case .friday: return NSLocalizedString("fri", comment: "")
        case .saturday: return NSLocalizedString("sat", comment: "")
        case .sunday: return NSLocalizedString("sun", comment: "")
        }
    }
}
