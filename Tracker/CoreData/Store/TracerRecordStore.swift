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
}
