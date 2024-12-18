import Foundation

final class CategoryViewModel {
    var didUpdateCategories: (() -> Void)?
    var didSelectedRaw: ((String) -> Void)?
    
    private(set) var actualCategories: [String] = [] {
        didSet {
            didUpdateCategories?()
        }
    }
    
    private var selectedCategory: String?  {
        didSet {
            guard let selectedCategory else { return }
            didSelectedRaw?(selectedCategory)
        }
    }
    
    private var trackerCategoryStore = TrackerCategoryStore.shared
    
    func loadCategoriesFromCoreData() {
        actualCategories = (try? trackerCategoryStore.importCategoryFromCoreData()) ?? []
    }
    
    func addCategory(categoryName: String) {
        trackerCategoryStore.saveCategoryToCoreData(categoryName: categoryName)
        actualCategories.append(categoryName)
    }
    
    func deleteCategory(_ category: String) {
        do {
            try trackerCategoryStore.deleteCategoryFromCoreData(category)
            actualCategories.removeAll{$0 == category}
        } catch {
            print("ОШИБКА УДАЛЕНИЯ КАТЕГОРИИ: \(error.localizedDescription)")
            return
        }
    }
    
    func isSelectedCategory(category: String) -> Bool {
        selectedCategory == category
    }
    
    func didSelectCategory(category: String) {
        selectedCategory = category
    }
}
