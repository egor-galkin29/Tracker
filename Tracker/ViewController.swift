import UIKit
// MARK: ViewController

class ViewController: UIViewController {
    
    // MARK: UI
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "stub")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Поиск"
        return searchBar
    }()
        
    // MARK: Public Properties

    // MARK: Private Properties
    
    // MARK: Override Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setUpNavigationBar()
        addAllConstraints()
    }
    
    // MARK: Public Methods

    // MARK: Private Methods
    
    private func setUpNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = nil
        
        setupNavLeftButton()
        setupNavRightDateButton()
    }
    
    private func setupNavLeftButton() {
        let navPlusImage = UIImage(named: "nav_plus_image")
        let customButton = UIBarButtonItem(image: navPlusImage, style: .plain, target: self, action: #selector(addHabbite))
        
        navigationItem.leftBarButtonItem = customButton
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    private func setupNavRightDateButton() {
            let dateButton = UIButton(type: .custom)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d.M.yy"
            let dateString = dateFormatter.string(from: Date())
            
            dateButton.setTitle(dateString, for: .normal)
            dateButton.setTitleColor(.black, for: .normal)
            dateButton.backgroundColor = UIColor(hex: "#F0F0F0")
            
            dateButton.layer.cornerRadius = 8
            dateButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: dateButton)
        }
    
    private func setupView() {
        view.backgroundColor = .white
        
        [imageView, emptyLabel, titleLabel, searchBar].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func addAllConstraints() {
        addImageViewConstraints()
        addEmptyLabelConstraints()
        addTitleLableConstraints()
        addSearchBarConstraints()
    }
    
    private func addImageViewConstraints() {
        let guide = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: guide.centerYAnchor)
        ])
    }
    
    private func addEmptyLabelConstraints() {
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            emptyLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8)
        ])
    }
    
    private func addTitleLableConstraints() {
        let guide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
        titleLabel.topAnchor.constraint(equalTo: guide.topAnchor)
        ])
    }
    
    private func addSearchBarConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchBar.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor)
        ])
    }
    
    @objc private func addHabbite(){}
}
