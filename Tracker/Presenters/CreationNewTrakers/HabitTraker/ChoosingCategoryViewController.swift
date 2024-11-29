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
    
    /// Текст для заглушки
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        //                categoriesTableView.dataSource = self
        //                categoriesTableView.delegate = self
        setupView()
    }
    private func setupView() {
        [viewTitle, placeholderImage, placeholderLabel].forEach {
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
        ])
    }
}
