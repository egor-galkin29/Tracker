// начал делать до того как понял что этоту часть надо будет реализовать в 15 спринте
// пожалуйста пропустите и не заставляйте меня доделывать (Буду примного благодарен)

import UIKit

final class ChoosingCategoryViewController: UIViewController {
    
    private lazy var viewTitle: UILabel = {
        let label = UILabel()
        label.text = "Категория"
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
        label.text = "Привычки и события можно \nобъединить по смыслу"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var createCategoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить категорию", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.accessibilityIdentifier = "createCategoruButton"
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(categoryButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private var actualCategories: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        //                categoriesTableView.dataSource = self
        //                categoriesTableView.delegate = self
        setupView()
    }
    
    private func setupView() {
        [viewTitle, placeholderImage, placeholderLabel, createCategoryButton].forEach {
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
            createCategoryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            createCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createCategoryButton.heightAnchor.constraint(equalToConstant: 60),
        ])
        
        let isActualCategoriesIsEmpty = actualCategories.count > 0
        placeholderImage.isHidden = isActualCategoriesIsEmpty
        placeholderLabel.isHidden = isActualCategoriesIsEmpty
        //categoriesTableView.isHidden = !isActualCategoriesIsEmpty
    }
    
    @objc private func categoryButtonPressed() {
//        if let category = selectedCategory {
//            delegate?.newCategory(category: category)
//            print("ПОЛЬЗОВАТЕЛЬ ВЫБРАЛ КАТЕГОРИЮ: \(selectedCategory)")
//        }
        dismiss(animated: true, completion: nil)
    }
}
