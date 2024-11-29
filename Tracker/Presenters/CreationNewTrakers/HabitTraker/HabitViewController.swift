import UIKit

final class HabitViewController: UIViewController {
    
    var selectedCategory: String?
    var selectedSchedule: String?
    var schedule:[WeekDays] = []
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
//        let tableView = UITableView()
//        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
//        tableView.tableFooterView = UIView()
//        tableView.layer.cornerRadius = 16
//        tableView.layer.masksToBounds = true
//        tableView.backgroundColor = .ypLightGrey
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true  // Закругление углов таблицы
        tableView.backgroundColor = .clear
        tableView.separatorInset = .zero  // Убираем внутренние отступы для разделителей
        tableView.separatorColor = .lightGray  // Цвет разделителей
        return tableView
    }()
    
    private lazy var habbitCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 9
        layout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .blue
        return collectionView
    }()
    
    private lazy var emojiLabel: UILabel = {
            let emojiLabel = UILabel()
            emojiLabel.text = "Emoji"
            emojiLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            return emojiLabel
            
        }()
        
    private lazy var colorLabel: UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.text = "Цвет"
        emojiLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return emojiLabel
        
    }()
    
    private lazy var emojiCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //collectionView.register(TrackerHabbitViewCell.self, forCellWithReuseIdentifier: "EmojiCell")
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .blue
        return collectionView
    }()
    
    private lazy var colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //collectionView.register(TrackerHabbitViewCell.self, forCellWithReuseIdentifier: "ColorCell")
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .orange
        return collectionView
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
        
        setupViews()
    }
    
    /// Привязка элементов к экрану
    private func setupViews() {
        
        [viewControllerName, scrollView, habbitNameTextField, warningLable, habbitTableView, buttonContainerView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        scrollView.addSubview(contentView)
        
        [emojiLabel, emojiCollectionView, colorLabel, colorCollectionView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
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
        
        // Констрейнты для скроллируемых элементов
        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            emojiLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            emojiLabel.heightAnchor.constraint(equalToConstant: 52),
            emojiLabel.widthAnchor.constraint(equalToConstant: 52),
            
            emojiCollectionView.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 8),
            emojiCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            emojiCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            colorLabel.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 16),
            colorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            colorLabel.heightAnchor.constraint(equalToConstant: 18),
            
            colorCollectionView.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 8),
            colorCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            colorCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            colorCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
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
            
            // Констрейнты для `createButton`
            trackerCreateButton.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor),
            trackerCreateButton.topAnchor.constraint(equalTo: buttonContainerView.topAnchor, constant: 16),
            trackerCreateButton.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor)
        ])
        
        //        NSLayoutConstraint.activate([
        //            viewControllerName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
        //            viewControllerName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        //
        //            scrollView.topAnchor.constraint(equalTo: viewControllerName.bottomAnchor, constant: 24),
        //            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        //            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        //            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        //
        //            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
        //            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
        //            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
        //            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        //            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        //
        //            habbitNameTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
        //            habbitNameTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        //            habbitNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        //            habbitNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        //            habbitNameTextField.heightAnchor.constraint(equalToConstant: 75),
        //            habbitNameTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        //
        //            warningLable.topAnchor.constraint(equalTo: habbitNameTextField.bottomAnchor),
        //            warningLable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        //            warningLable.heightAnchor.constraint(equalToConstant: 22),
        //
        //            habbitTableView.topAnchor.constraint(equalTo: habbitNameTextField.bottomAnchor, constant: 24),
        //            habbitTableView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        //            habbitTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        //            habbitTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        //            habbitTableView.heightAnchor.constraint(equalToConstant: 150),
        //
        //            habbitCollectionView.topAnchor.constraint(equalTo: habbitTableView.bottomAnchor, constant: 32),
        //            habbitCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        //            habbitCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        //            habbitCollectionView.bottomAnchor.constraint(equalTo: habbitTableView.bottomAnchor, constant: 498),
        //
        //            trackerDismissButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
        //            trackerDismissButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        //
        //        ])
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
