import UIKit
import CoreData

final class TrackerCategoryStore: NSObject {
    static let shared = TrackerCategoryStore()
    private override init() {}
    
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchedResultController: NSFetchedResultsController<TrackerCategoryCoreData>?
    
    func saveCategoryToCoreData(categoryName: String) {
        
        let trackerCategoryCoreDataEntity = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreDataEntity.title = categoryName
        
        do {
            try context.save()
            print("категория добавлина в бд")
        } catch {
            print("не получилось добавить категорию в бд")
        }
        
    }
    
    func importCategoryFromCoreData() throws -> [String] {
        
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        
        let categories = try context.fetch(fetchRequest)
        
        return categories.compactMap({$0.title})
    }
    
    func deleteCategoryFromCoreData(_ name: String) throws {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", name)
        let categories = try context.fetch(fetchRequest)
        categories.forEach{context.delete($0)}
        
        do {
            try context.save()
            print("КАТЕГОРИЯ С ИМЕНЕМ \(name) УСПЕШНО УДАЛЕНА ИЗ CORE DATA.")
        } catch {
            print("ОШИБКА УДАЛЕНИЯ КАТЕГОРИИ С ИМЕНЕМ \(name) ИЗ CORE DATA: \(error.localizedDescription)")
        }
    }
    
    func importCategoryWithTrackersFromCoreData() throws -> [TrackerCategory] {
            let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
            var resultCategories = [TrackerCategory]()
            let categories = try context.fetch(fetchRequest)
            
            for category in categories {
                guard let name = category.title, let trackersCoreData = category.trackerInCategory as? Set<TrackerCoreData> else { continue }
            
                let trackers = trackersCoreData.compactMap({ (trackerCoreData: TrackerCoreData) -> Tracker? in
                    guard
                        let id = trackerCoreData.id,
                        let name = trackerCoreData.title,
                        let emoji = trackerCoreData.emoji
                    else { return nil }
                    
                    guard let hexColor = trackerCoreData.color, !hexColor.isEmpty else { return nil }
                    let color = UIColor(hex: hexColor)
                    
                    let schedule = ScheduleTransformer.shared.stringToDays(stringDays: trackerCoreData.schedule ?? "")
                    return Tracker(id: id, title: name, color: color, emoji: emoji, schedule: schedule)
                })
                resultCategories.append(TrackerCategory(title: name, trackers: trackers))
            }
            return resultCategories
        }
    
    func editCategoryNameToCoreData(categoryName: String, newCategoryName: String) throws {
            let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "title == %@", categoryName)
            let categories = try context.fetch(fetchRequest)
            categories.forEach({$0.title = newCategoryName})
            
            do {
                try context.save()
                print("ВЫПОЛНЕНА СМЕНА ИМЕНИ КАТЕГОРИИ НА \(newCategoryName) И ЗАГРУЗКА В CORE DATA.")
            } catch {
                print("ОШИБКА СОХРАНЕНИЯ НОВОГО ИМЕНИ КАТЕГОРИИ \(newCategoryName) В CORE DATA: \(error.localizedDescription)")
            }
        }
}
