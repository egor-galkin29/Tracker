import UIKit

protocol CategoryViewControllerDelegate: AnyObject {
    func newCategorySelect(category: String)
}

final class ChoosingCategoryViewController: UIViewController {
    
    private lazy var viewTitle: UILabel = {
        let label = UILabel()
        let localizedString = NSLocalizedString("categoryName", comment: "")
        label.text = localizedString
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var placeholderImage: UIImageView = {
        let image = UIImageView()
        let placeholder = UIImage(named: "stub")
        image.image = placeholder
        return image
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        let localizedString = NSLocalizedString("categoryPlaceholder", comment: "")
        label.text = localizedString
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var categoriesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .red
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.separatorInset.left = 16
        tableView.separatorInset.right = 16
        tableView.separatorColor = .ypGray
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        return tableView
    }()
    
    private lazy var createCategoryButton: UIButton = {
        let button = UIButton()
        let localizedString = NSLocalizedString("addCategoryButton", comment: "")

        button.setTitle(localizedString, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.accessibilityIdentifier = "createCategoruButton"
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(categoryButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private var viewModel = CategoryViewModel()
    weak var delegate: CategoryViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        binding()
        viewModel.loadCategoriesFromCoreData()
        
        categoriesTableView.dataSource = self
        categoriesTableView.delegate = self
        
        setupView()
    }
    
    private func setupView() {
        [viewTitle, placeholderImage, placeholderLabel, createCategoryButton, categoriesTableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            viewTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            viewTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            placeholderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 8),
            placeholderLabel.heightAnchor.constraint(equalToConstant: 36),
            placeholderLabel.widthAnchor.constraint(equalToConstant: 343),
            
            categoriesTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoriesTableView.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 24),
            categoriesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoriesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoriesTableView.bottomAnchor.constraint(equalTo: createCategoryButton.topAnchor),
            
            createCategoryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            createCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createCategoryButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    func binding() {
        viewModel.didUpdateCategories = { [weak self] in
            guard let self else {return}
            placeholderImage.isHidden = !viewModel.actualCategories.isEmpty
            placeholderLabel.isHidden = !viewModel.actualCategories.isEmpty
            categoriesTableView.reloadData()
        }
        
        viewModel.didSelectedRaw = { [weak self] selectedCategory in
            guard let self else { return }
            categoriesTableView.visibleCells.enumerated().forEach{ index, cell in
                if self.viewModel.isSelectedCategory(category: self.viewModel.actualCategories[index]) {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            }
            DispatchQueue.main.async {
                self.delegate?.newCategorySelect(category: selectedCategory)
                print("выбранная категория: \(selectedCategory)")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc private func categoryButtonPressed() {
        let controller = NewCategoryViewController()
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
}

extension ChoosingCategoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.actualCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = viewModel.actualCategories[indexPath.row]
        cell.textLabel?.text = category
        cell.textLabel?.textColor = .black
        cell.backgroundColor = .ypLightGray
        cell.selectionStyle = .none
        
       
        cell.accessoryType = (viewModel.isSelectedCategory(category: category)) ? .checkmark : .none
       
        
        if indexPath.row == viewModel.actualCategories.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.layoutMargins = .zero
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            cell.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        
        let isLastCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        if isLastCell {
            cell.layer.cornerRadius = 16
            cell.layer.masksToBounds = true
            cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectCategory(category: viewModel.actualCategories[indexPath.row])
    }
 
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { action in
            let editAction =
            UIAction(title: NSLocalizedString("Редактировать", comment: ""),
                     image: UIImage(systemName: "pencil")) { action in
                self.editCategoryName(indexPath: indexPath)
            }
            
            let deleteAction =
            UIAction(title: NSLocalizedString("Удалить", comment: ""),
                     image: UIImage(systemName: "trash"),
                     attributes: .destructive) { action in
                self.deleteCategory(indexPath: indexPath)
            }
            return UIMenu(title: "", children: [editAction, deleteAction])
        })
    }
    
    
    private func editCategoryName(indexPath: IndexPath) {
        let controller = EditCategoryViewController()
        let category = viewModel.actualCategories[indexPath.row]
        controller.delegate = self
        controller.oldCategoryName = category
        self.present(controller, animated: true, completion: nil)
    }
    
    private func deleteCategory(indexPath: IndexPath) {
        let category = self.viewModel.actualCategories[indexPath.row]
        
        let alert = UIAlertController(title: "Эта категория точне не нужна?", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Удалить",
                                      style: .destructive,
                                      handler: { [weak self] _ in
            
            guard let self else { return }
            self.viewModel.deleteCategory(category)
            
        }))
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension ChoosingCategoryViewController: NewCategoryViewControllerDelegate {
    func createNewCategoryName(categoryName: String) {
        viewModel.addCategory(categoryName: categoryName)
        categoriesTableView.reloadData()
    }
}

extension ChoosingCategoryViewController: EditCategoryViewControllerDelegate {
    func editNewCategoryName(oldCategoryName: String, newCategoryName: String) {
        try? viewModel.editCategory(categoryName: oldCategoryName, newCategoryName: newCategoryName)
        categoriesTableView.reloadData()
    }
}
