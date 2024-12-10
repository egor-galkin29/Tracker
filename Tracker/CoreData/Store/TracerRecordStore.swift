import UIKit
import CoreData

final class TrackerRecordStore: NSObject {
    static let shared = TrackerRecordStore()
    private override init() {}
    
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveRecordToCoreData(id: UUID, trackerDate: Date) {
        let trackerRecordCoreDataEntity = TrackerRecordCoreData(context: context)
        trackerRecordCoreDataEntity.trackerID = id
        trackerRecordCoreDataEntity.date = trackerDate
        
        do {
            try context.save()
            print("загрузка выполненого трекера в бд прошла успешнол")
        } catch {
            print("не получилось сохранить выполненый трекер в бд")
        }
    }
    
    func deleteRecordFromCoreData(id: UUID, trackerDate: Date) {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        let calendar = Calendar.current
        let startDay = calendar.startOfDay(for: trackerDate)
        let endDay = calendar.date(byAdding: .day, value: 1, to: startDay) ?? startDay
        
        fetchRequest.predicate = NSPredicate(format: "trackerID == %@ AND date < %@ AND date >= %@", id as CVarArg, endDay as NSDate, startDay as NSDate)
        
        do {
            let trackerRecord = try context.fetch(fetchRequest)
            for record in trackerRecord {
                context.delete(record)
            }
            try context.save()
            print("выполненый трекер удален из CoreData")
        } catch {
            print("не получилось удалить выполненый тракер")
        }
    }
    
    func countCoreDataRecordComplete(id: UUID) -> Int {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "trackerID == %@" , id as CVarArg)
        
        do {
            let trackerRecord = try context.fetch(fetchRequest)
            print("количество выполненых трекеров \(trackerRecord.count)")
            return trackerRecord.count
        } catch {
            print("не получилось подсчитать выполненые трекеры")
            return 0
        }
    }
    
    func importCoreDataRecordComplete(id: UUID, trackerDate: Date) -> Bool {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        let calendar = Calendar.current
        let startDay = calendar.startOfDay(for: trackerDate)
        let endDay = calendar.date(byAdding: .day, value: 1, to: startDay) ?? startDay
        
        fetchRequest.predicate = NSPredicate(format: "trackerID == %@ AND date >= %@ AND date < %@", id as CVarArg, startDay as CVarArg, endDay as CVarArg)
        
        do {
            let trackerRecord = try context.fetch(fetchRequest)
            let countTrackerRecord = trackerRecord.isEmpty
            return !countTrackerRecord
        } catch {
            print("ОШИБКА ПОИСКА КОЛИЧЕСТВА ВЫПОЛНЕННЫХ ТРЕКЕРОВ: \(error.localizedDescription)")
            return false
        }
    }
}
