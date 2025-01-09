import UIKit

final class EditTrackerViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    var selectedCategory: String?
    var selectedSchedule: String?
    var selectedEmoji: String?
    var selectedColor: UIColor?
    var schedule: [WeekDays] = []
    
    let trackerStore = TrackerStore.shared
        
    let emojis = ["😊", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    let colors: [UIColor] = [
        .colorSelection1, .colorSelection2, .colorSelection3, .colorSelection4, .colorSelection5, .colorSelection6, .colorSelection7, .colorSelection8, .colorSelection9, .colorSelection10, .colorSelection11, .colorSelection12, .colorSelection13, .colorSelection14, .colorSelection15, .colorSelection16, .colorSelection17, .colorSelection18
    ]
    
    private var habbitTableViewTopConstraint: NSLayoutConstraint!
    
    private lazy var viewControllerName: UILabel = {
        let label = UILabel()
        let localizedString = NSLocalizedString("newHabitTitle", comment: "")
        label.text = localizedString
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
        let localizedString = NSLocalizedString("trackerCreatePlaceholder", comment: "")
        textField.placeholder = localizedString
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
        let localizedString = NSLocalizedString("trackerNameLimit", comment: "")
        lable.text = localizedString
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
        tableView.backgroundColor = .ypLightGray
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .ypGray
        tableView.separatorInset.left = 16
        tableView.separatorInset.right = 16
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Properties cell")
        return tableView
    }()
    
    private lazy var emojiLabel: UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.text = "Emoji"
        emojiLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return emojiLabel
    }()
    
    private lazy var colorLabel: UILabel = {
        let label = UILabel()
        let localizedString = NSLocalizedString("colorCollectionTitle", comment: "")
        label.text = localizedString
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
        
    }()
    
    lazy var emojiCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 52, height: 52)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: EmojiCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    lazy var colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 52, height: 52)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ColorCollectionCell.self, forCellWithReuseIdentifier: "ColorCell")
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private lazy var trackerDismissButton: UIButton = {
        let button = UIButton(type: .system)
        let localizedString = NSLocalizedString("cancelButton", comment: "")
        button.setTitle(localizedString, for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var trackerCreateButton: UIButton = {
        let button = UIButton(type: .system)
        let localizedString = NSLocalizedString("createButton", comment: "")
        button.setTitle(localizedString, for: .normal)
        button.backgroundColor = .systemGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        habbitNameTextField.delegate = self

    }
    
    private func setupViews() {
        
        [viewControllerName, scrollView, habbitNameTextField, warningLable, habbitTableView, buttonContainerView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        [emojiLabel, emojiCollectionView, colorLabel, colorCollectionView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [trackerCreateButton, trackerDismissButton].forEach {
            buttonContainerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        habbitTableViewTopConstraint = habbitTableView.topAnchor.constraint(equalTo: habbitNameTextField.bottomAnchor, constant: 24)
        habbitTableViewTopConstraint.isActive = true
        
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
            
            habbitTableViewTopConstraint,
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
        
        // Констрейнты для contentView
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            emojiLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            
            emojiCollectionView.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 8),
            emojiCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            emojiCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 180),

            colorLabel.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 16),
            colorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            colorLabel.heightAnchor.constraint(equalToConstant: 18),

            colorCollectionView.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 20),
            colorCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            colorCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 180),
            colorCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            buttonContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            buttonContainerView.heightAnchor.constraint(equalToConstant: 66),
            
            trackerDismissButton.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor),
            trackerDismissButton.topAnchor.constraint(equalTo: buttonContainerView.topAnchor, constant: 6),
            trackerDismissButton.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor),
            trackerDismissButton.trailingAnchor.constraint(equalTo: trackerCreateButton.leadingAnchor, constant: -8),
            trackerDismissButton.widthAnchor.constraint(equalTo: trackerCreateButton.widthAnchor),
            
            trackerCreateButton.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor),
            trackerCreateButton.topAnchor.constraint(equalTo: buttonContainerView.topAnchor, constant: 6),
            trackerCreateButton.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor),
        ])
        
        view.backgroundColor = .white
        
        habbitTableView.dataSource = self
        habbitTableView.delegate = self
        
        emojiCollectionView.dataSource = self
        emojiCollectionView.delegate = self
        
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
    }
    
    @objc private func newTrackerName(_ sender: UITextField) {
        blockButtons()
    }
    
    @objc private func didTapCancelButton() {
        dismiss(animated: true) {
            if let sceneDelegate = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first?.delegate as? SceneDelegate {
                sceneDelegate.transitionToTrackerViewController()
            }
        }
    }
    
    @objc private func didTapCreateButton() {
        guard let name = habbitNameTextField.text, let category = selectedCategory, let color = selectedColor, let emoji = selectedEmoji, !name.isEmpty else { return }
        
        let newTracker = Tracker(id: UUID(), title: name, color: color, emoji: emoji, schedule: schedule)
        
        trackerStore.saveTrackerToCoreData(id: UUID(), title: name, color: color, emoji: emoji, schedule: schedule, categoryName: category)
        
        NotificationCenter.default.post(name: .didCreateNewTracker, object: nil, userInfo: ["first": newTracker, "second": category])
        
        dismiss(animated: true) {
            if let sceneDelegate = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first?.delegate as? SceneDelegate {
                sceneDelegate.transitionToTrackerViewController()
            }
        }
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    func blockButtons() {
        guard let trackerName = habbitNameTextField.text else { return }
        
        if trackerName.isEmpty == false && selectedCategory != nil &&
            selectedCategory != "" && selectedSchedule != nil &&
            selectedSchedule != "" && selectedEmoji != "" &&
            selectedColor != nil && trackerName.count < 38 {
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

extension EditTrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == emojiCollectionView {
            return emojis.count
        } else {
            return colors.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojiCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCollectionViewCell.reuseIdentifier, for: indexPath) as! EmojiCollectionViewCell
            cell.configure(with: emojis[indexPath.item])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionCell.reuseIdentifier, for: indexPath) as! ColorCollectionCell
            cell.innerColorView.backgroundColor = colors[indexPath.row]
            return cell
        }
    }
}

extension EditTrackerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell else { return }
            selectedEmoji = emojis[indexPath.row]
            cell.emojiLabel.backgroundColor = .ypLightGray
        } else {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionCell else { return }
            selectedColor = colors[indexPath.row]
            cell.colorView.layer.borderColor = selectedColor?.withAlphaComponent(0.3).cgColor
        }
        blockButtons()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell
            cell?.emojiLabel.backgroundColor = .white
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionCell
            cell?.colorView.layer.borderColor = UIColor.white.cgColor
        }
        blockButtons()
    }
}

extension EditTrackerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Properties cell")
        
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 16
        cell.layer.masksToBounds = true
        
        if indexPath.row == 0 {
            let trackerCategory = selectedCategory ?? ""
            let localizedString = NSLocalizedString("categoryName", comment: "")
            cell.textLabel?.text = localizedString
            cell.detailTextLabel?.text = trackerCategory
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
            cell.detailTextLabel?.textColor = .ypGray
        } else if indexPath.row == 1 {
            let trackerSchedule = selectedSchedule ?? ""
            let localizedString = NSLocalizedString("scheduleName", comment: "")
            cell.textLabel?.text = localizedString
            cell.detailTextLabel?.text = trackerSchedule
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
            cell.detailTextLabel?.textColor = .ypGray
            
            if indexPath.row == 1 {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: CGFloat.greatestFiniteMagnitude)
                cell.layoutMargins = .zero
            } else {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
                cell.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 1 {
            let controller = ScheduleViewController()
            controller.delegate = self
            self.present(controller, animated: true, completion: nil)
        }
        else {
            let controller = ChoosingCategoryViewController()
            controller.delegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
}



extension EditTrackerViewController: ScheduleViewControllerDelegate {
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

extension EditTrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension EditTrackerViewController: CategoryViewControllerDelegate {
    func newCategorySelect(category: String) {
        self.selectedCategory = category
        blockButtons()
        habbitTableView.reloadData()
    }
}
