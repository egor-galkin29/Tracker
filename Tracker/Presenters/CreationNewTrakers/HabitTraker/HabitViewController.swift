import UIKit

final class HabitViewController: UIViewController {
    
    var selectedCategory: String?
    var selectedSchedule: String?
    var schedule:[WeekDays] = []
    
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
        
        return textField
    }()
    
    private lazy var warningLable: UILabel = {
        let lable = UILabel()
        lable.text = "Ограничение 38 символов"
        lable.font = .systemFont(ofSize: 17, weight: .regular)
        lable.textColor = .ypRed
        lable.isHidden = true
        
        return lable
    }()
    
    private lazy var habbitTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.tableFooterView = UIView()
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.backgroundColor = .ypLightGrey
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
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
        [habbitNameTextField, warningLable, habbitTableView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
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
            habbitNameTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            warningLable.topAnchor.constraint(equalTo: habbitNameTextField.bottomAnchor),
            warningLable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            warningLable.heightAnchor.constraint(equalToConstant: 22),
            
            habbitTableView.topAnchor.constraint(equalTo: habbitNameTextField.bottomAnchor, constant: 24),
            habbitTableView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            habbitTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            habbitTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            habbitTableView.heightAnchor.constraint(equalToConstant: 150),
            
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
