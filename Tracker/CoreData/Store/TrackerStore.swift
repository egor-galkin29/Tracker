import UIKit
import CoreData

final class TrackerStore: NSObject, NSFetchedResultsControllerDelegate {
    static let shared = TrackerStore()
    private override init() {}
    
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchedResultController: NSFetchedResultsController<TrackerCoreData>?
    
    func saveTrackerToCoreData(id: UUID, title: String, color: UIColor, emoji: String, schedule: [WeekDays]) {
        let trackerCoreDataEntity = TrackerCoreData(context: context)
        let stringTrackerSchedule = ScheduleTransformer.shared.daysToString(days: schedule)
        
        trackerCoreDataEntity.id = id
        trackerCoreDataEntity.title = title
        trackerCoreDataEntity.color = color.toHexString()
        trackerCoreDataEntity.emoji = emoji
        trackerCoreDataEntity.schedule = stringTrackerSchedule
        
        do {
            try context.save()
            print("трекер сохраненн")
        } catch {
            print("Неполучилось сохранить контес")
        }
    }
    
    func importCoreDataTracker() -> [TrackerCoreData] {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                             managedObjectContext: context,
                                                             sectionNameKeyPath: nil,
                                                             cacheName: nil)
        fetchedResultController?.delegate = self
        
        do {
            try fetchedResultController?.performFetch()
            print("трекер был подгружен успешно")
        } catch {
            print("ошибка вызова fetchedResultController")
        }
        
        return fetchedResultController?.fetchedObjects ?? []
    }
}
