import UIKit

final class CreationNewTrakersViewController: UIViewController {
    
    private lazy var viewControllerName: UILabel = {
        let label = UILabel()
        let localizedString = NSLocalizedString("typeOfTrackerTitle", comment: "")
        label.text = localizedString
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var habitButton: UIButton = {
        let button = UIButton()
        let localizedString = NSLocalizedString("habitTypeButton", comment: "")
        button.setTitle(localizedString, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.accessibilityIdentifier = "habitButton"
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(habitButtonPressed), for: .touchUpInside)
        button.tag = 1
        return button
    }()
    
    private lazy var irregularButton: UIButton = {
        let button = UIButton()
        let localizedString = NSLocalizedString("eventTypeButton", comment: "")
        button.setTitle(localizedString, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.accessibilityIdentifier = "unregularButton"
        button.layer.cornerRadius = 16
        button.tag = 2
        button.addTarget(self, action: #selector(irregularButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        [viewControllerName,
         habitButton,
         irregularButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        view.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            viewControllerName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            viewControllerName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            habitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            habitButton.topAnchor.constraint(equalTo: viewControllerName.bottomAnchor, constant:281),
            habitButton.widthAnchor.constraint(equalToConstant: 335),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            
            irregularButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            irregularButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant:16),
            irregularButton.widthAnchor.constraint(equalToConstant: 335),
            irregularButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func habitButtonPressed() {
        let controller = HabitViewController()
        
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc private func irregularButtonPressed() {
        let controller = IrregularEventsViewController()
        
        self.present(controller, animated: true, completion: nil)
    }
}
