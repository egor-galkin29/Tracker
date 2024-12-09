import UIKit
import CoreData

final class TrackerCategoryStore: NSObject {
    static let shared = TrackerCategoryStore()
    private override init() {}
    
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveCategoryToCoreData(categoryName: String, categoryTrackers: [Tracker] ) {
        
        let trackerCategoryCoreDataEntity = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreDataEntity.title = categoryName
        
        do {
            try context.save()
            print("категория добавлина в бд")
        } catch {
            print("не получилось добавить категорию в бд")
        }
        
    }
    // TODO (16 спринт)
    func importCoreDataCategory() {
        
    }
    
}
