import UIKit

final class HabitViewController: UIViewController {
    
    
    private lazy var viewControllerName: UILabel = {
        let label = UILabel()
        label.text = "Создание трекера"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var habbitNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.textColor = .black
        textField.borderStyle = .none
        textField.backgroundColor = .ypLightGrey
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.clearButtonMode = .whileEditing
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.isUserInteractionEnabled = true
        textField.addTarget(self, action: #selector(newTrackerName(_:)), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private lazy var warningLable: UILabel = {
        let lable = UILabel()
        lable.text = "Ограничение 38 символов"
        lable.font = .systemFont(ofSize: 17, weight: .regular)
        lable.textColor = .ypRed
        lable.isHidden = true
        lable.translatesAutoresizingMaskIntoConstraints = false
        
        return lable
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    /// Привязка элементов к экрану
    private func setupViews() {
        [viewControllerName, scrollView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        scrollView.addSubview(contentView)
        contentView.addSubview(habbitNameTextField)
        contentView.addSubview(warningLable)
        
        view.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            viewControllerName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            viewControllerName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scrollView.topAnchor.constraint(equalTo: viewControllerName.bottomAnchor, constant: 24),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            habbitNameTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            habbitNameTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            habbitNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            habbitNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            habbitNameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            warningLable.topAnchor.constraint(equalTo: habbitNameTextField.bottomAnchor),
            warningLable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            warningLable.heightAnchor.constraint(equalToConstant: 22),
        ])
    }
    
    @objc private func newTrackerName(_ sender: UITextField) {
        blockButtons()
    }
    
    private func blockButtons() {
        guard let trackerName = habbitNameTextField.text else { return }
        
        
        //            if trackerName.isEmpty == false && selectedCategory != nil &&
        //                selectedCategory != "" && selectedSchedule != nil &&
        //                selectedSchedule != "" && selectedEmoji != "" &&
        //                selectedColor != nil && trackerName.count < 38 {
        //                habbitTrackerCreate.isEnabled = true
        //                habbitTrackerCreate.backgroundColor = .ypBlack
        //            } else {
        //                habbitTrackerCreate.isEnabled = false
        //                habbitTrackerCreate.backgroundColor = .ypGray
        //            }
        
        if trackerName.count > 38 {
            warningLable.isHidden = false
        } else {
            warningLable.isHidden = true
        }
    }
}
