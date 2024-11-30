import UIKit

final class HabitViewController: UIViewController {
    
    var selectedCategory: String?
    var selectedSchedule: String?
    var schedule: [WeekDays] = []
    private var optionsTableViewTopConstraint: NSLayoutConstraint!
    
    private lazy var viewControllerName: UILabel = {
        let label = UILabel()
        label.text = "Новая привычка"
        label.font = .systemFont(ofSize: 16)
        label.tintColor = .black
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var habbitNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.textColor = .black
        textField.borderStyle = .none
        textField.backgroundColor = .ypLightGray
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
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.backgroundColor = .clear
        tableView.separatorInset = .zero
        tableView.separatorColor = .lightGray
        return tableView
    }()
    
    private lazy var trackerDismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return button
    }()
    
    // Кнопка создания трекера
    private lazy var trackerCreateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать", for: .normal)
        button.backgroundColor = .systemGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        habbitTableView.dataSource = self
        habbitTableView.delegate = self
        habbitTableView.register(UITableViewCell.self, forCellReuseIdentifier: "optionCell")
        habbitTableView.tableFooterView = UIView()
        print("Привет")
        
        setupViews()
    }
    
    /// Привязка элементов к экрану
    private func setupViews() {
        
        [viewControllerName, scrollView, habbitNameTextField, warningLable, habbitTableView, buttonContainerView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        scrollView.addSubview(contentView)
        
        buttonContainerView.addSubview(trackerCreateButton)
        buttonContainerView.addSubview(trackerDismissButton)
        
        view.backgroundColor = .white
        
        optionsTableViewTopConstraint = habbitTableView.topAnchor.constraint(equalTo: habbitNameTextField.bottomAnchor, constant: 24)
        optionsTableViewTopConstraint.isActive = true
        
        
        // Констрейнты для фиксированных элементов
        NSLayoutConstraint.activate([
            viewControllerName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            viewControllerName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            habbitNameTextField.topAnchor.constraint(equalTo: viewControllerName.bottomAnchor, constant: 24),
            habbitNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            habbitNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            habbitNameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            warningLable.topAnchor.constraint(equalTo: habbitNameTextField.bottomAnchor, constant: 8),
            warningLable.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            warningLable.heightAnchor.constraint(equalToConstant: 22),
            
            // Устанавливаем констрейнт с сохранением ссылки
            optionsTableViewTopConstraint,
            habbitTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            habbitTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            habbitTableView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        // Констрейнты для scrollView
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: habbitTableView.bottomAnchor, constant: 32),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: buttonContainerView.topAnchor)
        ])
        
        // Констрейнты для scrollContentView
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor) // Обеспечиваем горизонтальный скроллинг
        ])
        
        NSLayoutConstraint.activate([
            buttonContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            buttonContainerView.heightAnchor.constraint(equalToConstant: 66),
            
            trackerDismissButton.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor),
            trackerDismissButton.topAnchor.constraint(equalTo: buttonContainerView.topAnchor, constant: 16),
            trackerDismissButton.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor),
            trackerDismissButton.trailingAnchor.constraint(equalTo: trackerCreateButton.leadingAnchor, constant: -16),
            trackerDismissButton.widthAnchor.constraint(equalTo: trackerCreateButton.widthAnchor),
            
            trackerCreateButton.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor),
            trackerCreateButton.topAnchor.constraint(equalTo: buttonContainerView.topAnchor, constant: 16),
            trackerCreateButton.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor)
        ])
    }
    
    @objc private func newTrackerName(_ sender: UITextField) {
        blockButtons()
    }
    
    @objc private func didTapCancelButton() {
        //self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapCreateButton() {
        //            guard let name = habbitName.text else { return }
        //            guard !name.isEmpty else { return }
        //            guard let color = selectedColor else { return }
        //            guard let emoji = selectedEmoji else { return }
        //            guard let category = selectedCategory else { return }
        //
        //            let newTracker = Tracker(id: UUID(), trackerName: name, trackerColor: color, trackerEmoji: emoji, trackerShedule: schedule)
        //            delegate?.addTracker(tracker: newTracker, selectedCategory: category )
        //            print("СОЗДАН ТРЕКЕР С НОМЕРОМ \(newTracker.id), ИМЕНЕМ \(name), ЦВЕТОМ \(color), ЭМОДЗИ \(emoji), ДНЯМИ НЕДЕЛИ \(newTracker.trackerShedule)")
        //
        //            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    private func blockButtons() {
        guard let trackerName = habbitNameTextField.text else { return }
        
        if trackerName.isEmpty == false &&
            selectedCategory != nil &&
            selectedCategory != "" &&
            selectedSchedule != nil &&
            selectedSchedule != "" &&
            trackerName.count < 38 {
            trackerCreateButton.isEnabled = true
            trackerCreateButton.backgroundColor = .black
        } else {
            trackerCreateButton.isEnabled = false
            trackerCreateButton.backgroundColor = .ypGray
        }
        
        if trackerName.count > 38 {
            warningLable.isHidden = false
        } else {
            warningLable.isHidden = true
        }
    }
}

extension HabitViewController: ScheduleViewControllerDelegate {
    func didSelectSchedule(schedule: [WeekDays]) {
        self.schedule = schedule
        selectedSchedule = shortDaysText(days: schedule)
        blockButtons()
        habbitTableView.reloadData()
    }
    
    func shortDaysText(days: [WeekDays]) -> String {
        let shortDays = days.map {$0.shortDaysName}
        let shortDaysText = shortDays.joined(separator: ", ")
        return shortDaysText
    }
}
