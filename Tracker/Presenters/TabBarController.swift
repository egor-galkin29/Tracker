import UIKit

// MARK: TabBarController

final class TabBarController: UITabBarController {
    
    // MARK: Private Properties
    
    private var viewControllersList: [UIViewController] {
        
        // создаем первую кнопку
        let mainVC = TrackersViewController()
        let mainNavController = UINavigationController(rootViewController: mainVC)
        
        mainNavController.setNavigationBarHidden(false, animated: false)
        let localizedString = NSLocalizedString("trackersAppTitle", comment: "")
        mainNavController.tabBarItem = UITabBarItem(title: localizedString, image: UIImage(named: "record_tapBar_image"), tag: 0)
        
        // создаем вторую
        let localizedStringTwo = NSLocalizedString("statisticAppTitle", comment: "")
        let secondVC = StatisticViewController()
        secondVC.tabBarItem = UITabBarItem(title: localizedStringTwo, image: UIImage(named: "hare_tapBar_image"), tag: 1)
        
        return [mainNavController, secondVC]
    }
    
    // MARK: Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = viewControllersList
        configureTabBarAppearance()
    }
    
    // MARK: Private Properties
    
    private func configureTabBarAppearance() {
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .gray
    }
}
