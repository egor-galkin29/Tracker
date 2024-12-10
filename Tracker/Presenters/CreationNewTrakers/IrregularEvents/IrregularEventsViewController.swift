import UIKit

final class IrregularEventsViewController: UIViewController {
    
    var selectedCategory: String?
    var selectedEmoji: String?
    var selectedColor: UIColor?
    
    let emojis = ["😊", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    let colors: [UIColor] = [
        .colorSelection1, .colorSelection2, .colorSelection3, .colorSelection4, .colorSelection5, .colorSelection6, .colorSelection7, .colorSelection8, .colorSelection9, .colorSelection10, .colorSelection11, .colorSelection12, .colorSelection13, .colorSelection14, .colorSelection15, .colorSelection16, .colorSelection17, .colorSelection18
    ]
    
    private var irregularTableViewTopConstraint: NSLayoutConstraint!
    
    private lazy var viewControllerName: UILabel = {
        let label = UILabel()
        label.text = "Новое нерегулярное событие"
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
    
    lazy var irregularNameTextField: UITextField = {
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
    
    private lazy var irregularTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.separatorColor = .clear
        tableView.backgroundColor = .ypLightGray
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "irregular cell")
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
        label.text = "Цвет"
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
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var trackerCreateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать", for: .normal)
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
        selectedCategory = "Важное"
        setupViews()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        irregularNameTextField.delegate = self

    }
    
    private func setupViews() {
        
        [viewControllerName, scrollView, irregularNameTextField, warningLable, irregularTableView, buttonContainerView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        irregularTableView.dataSource = self
        irregularTableView.delegate = self
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        [emojiLabel, emojiCollectionView, colorLabel, colorCollectionView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        buttonContainerView.addSubview(trackerCreateButton)
        buttonContainerView.addSubview(trackerDismissButton)
        
        trackerCreateButton.translatesAutoresizingMaskIntoConstraints = false
        trackerDismissButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .white
        
        irregularTableViewTopConstraint = irregularTableView.topAnchor.constraint(equalTo: irregularNameTextField.bottomAnchor, constant: 24)
        irregularTableViewTopConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            viewControllerName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            viewControllerName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            irregularNameTextField.topAnchor.constraint(equalTo: viewControllerName.bottomAnchor, constant: 24),
            irregularNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            irregularNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            irregularNameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            warningLable.topAnchor.constraint(equalTo: irregularNameTextField.bottomAnchor, constant: 8),
            warningLable.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            warningLable.heightAnchor.constraint(equalToConstant: 22),
            
            irregularTableViewTopConstraint,
            irregularTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            irregularTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            irregularTableView.heightAnchor.constraint(equalToConstant: 75)
        ])
        
        // Констрейнты для scrollView
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: irregularTableView.bottomAnchor, constant: 32),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: buttonContainerView.topAnchor)
        ])
        
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
        
        emojiCollectionView.dataSource = self
        emojiCollectionView.delegate = self
        
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
    }
    
    @objc private func newTrackerName(_ sender: UITextField) {
        blockButtons()
    }
    
    @objc private func didTapCancelButton() {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapCreateButton() {
        let alert = UIAlertController(title: "Внимание!",
                                      message: "Данная функция доступна \nв платной версии",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    func blockButtons() {
        guard let trackerName = irregularNameTextField.text else { return }
        
        if trackerName.isEmpty == false && selectedCategory != nil &&
            selectedCategory != "" && selectedEmoji != "" &&
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

extension IrregularEventsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

