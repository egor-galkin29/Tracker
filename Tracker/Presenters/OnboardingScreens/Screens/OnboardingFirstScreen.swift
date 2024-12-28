import UIKit

final class OnboardingFirstScreen: UIViewController {
    
    private lazy var onboardingScreen: UIImageView = {
        let image = UIImageView()
        let onboardingImage = UIImage.onboardingScreenOne
        image.image = onboardingImage
        
        return image
    }()
    
    private lazy var onboardingTitle: UILabel = {
        let label = UILabel()
        let localizedString = NSLocalizedString("onboardingTitleOne", comment: "")
        label.text = localizedString
        label.font = .systemFont(ofSize: 32, weight: .bold)
        
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var onboardingButtonOne: UIButton = {
        let button = UIButton()
        let localizedString = NSLocalizedString("onboardingButton", comment: "")
        button.setTitle(localizedString, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.accessibilityIdentifier = "onboardingButtonOne"
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(onboardingButtonOnePressed), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
    }
    
    private func createView() {
        view.insertSubview(onboardingScreen, at: 0)
        view.addSubview(onboardingTitle)
        view.addSubview(onboardingButtonOne)
        
        onboardingScreen.translatesAutoresizingMaskIntoConstraints = false
        onboardingTitle.translatesAutoresizingMaskIntoConstraints = false
        onboardingButtonOne.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            onboardingScreen.topAnchor.constraint(equalTo: view.topAnchor),
            onboardingScreen.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            onboardingScreen.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            onboardingScreen.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            onboardingTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            onboardingTitle.bottomAnchor.constraint(equalTo: onboardingButtonOne.topAnchor, constant: -160),
            onboardingTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            onboardingTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            
            onboardingButtonOne.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            onboardingButtonOne.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84),
            onboardingButtonOne.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            onboardingButtonOne.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            onboardingButtonOne.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func onboardingButtonOnePressed() {
        let controller = TabBarController()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
}
