import UIKit
import CoreData

final class TrackerCategoryStore: NSObject {
    static let shared = TrackerCategoryStore()
    private override init() {}
    
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
}
