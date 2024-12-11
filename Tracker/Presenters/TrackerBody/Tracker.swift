import UIKit

class Tracker {
    let id: UUID
    let title: String
    let color: UIColor
    let emoji: String
    let schedule: [WeekDays]
    
    init(id: UUID, title: String, color: UIColor, emoji: String, schedule: [WeekDays]) {
        self.id = id
        self.title = title
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
    }
    
    convenience init(from trackersFromCoreData: TrackerCoreData) {
        let stringColor = trackersFromCoreData.color ?? "#AEAFB4"
        let trackerUIColor = UIColor(hex: stringColor) ?? .ypGray
        let trackerCoreDataSchedule = ScheduleTransformer.shared.stringToDays(stringDays: trackersFromCoreData.schedule ?? "")
        
        self.init(
            id: trackersFromCoreData.id ?? UUID(),
            title: trackersFromCoreData.title ?? "",
            color: trackerUIColor,
            emoji: trackersFromCoreData.emoji ?? "",
            schedule: trackerCoreDataSchedule
        )
    }
}
