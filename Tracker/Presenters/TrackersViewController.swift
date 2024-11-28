import UIKit
// MARK: ViewController

final class TrackersViewController: UIViewController, UISearchBarDelegate {
    
    // MARK: UI
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 3
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let placeholderImageView: UIImageView = {
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
    
    // MARK: Public Properties
    
    var categories: [TrackerCategory] = []
    var visibleTrackers: [Tracker] = []
    var categoryName:[String] = []
    
    // MARK: Private Properties
    
    private let searchContainer = UIView()
    private let searchBar = UISearchBar()
    
    private var trackers: [Tracker] = []
    private var completedTrackers: [TrackerRecord] = []

    // MARK: Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        mokTrackers()
        setupView()
        setUpNavigationBar()
        addAllConstraints()
        setupSearchBar()
    }
    
    // MARK: Public Methods
    
    func mokTrackers() {
        let mokTracker_1 = Tracker(id: UUID(), title: "MOK Tracker_1", color: .red, emoji: "😻", schedule: [.wednesday, .saturday])
        let mokTracker_2 = Tracker(id: UUID(), title: "MOK Tracker_2", color: .green, emoji: "😻", schedule: [.wednesday, .friday])
        let mokTracker_3 = Tracker(id: UUID(), title: "MOK Tracker_3", color: .orange, emoji: "😻", schedule: [.saturday])
        trackers.append(mokTracker_1)
        trackers.append(mokTracker_2)
        trackers.append(mokTracker_3)
        
        let category_1 = TrackerCategory(title: "Важное", trackers: [mokTracker_1, mokTracker_2])
        let category_2 = TrackerCategory(title: "НеВажное", trackers: [mokTracker_3])
        categories.append(category_1)
        categories.append(category_2)
        
        categoryName.append(category_1.title)
        categoryName.append(category_2.title)

    }
    
    // MARK: Private Methods
    
    private func placeholderVisible() {
        if visibleTrackers.isEmpty {
            placeholderImageView.isHidden = false
            emptyLabel.isHidden = false
            collectionView.isHidden = true
        } else {
            placeholderImageView.isHidden = true
            emptyLabel.isHidden = true
            collectionView.isHidden = false
        }
    }
    
    //collection
    private func setupCollectionView() {
        // Настройка коллекции
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(TrackerCellSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    }
    
    //Navigator
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
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.sizeToFit()
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        let datePickerBarItem = UIBarButtonItem(customView: datePicker)
        
        navigationItem.rightBarButtonItem = datePickerBarItem
    }
    
    @objc
    private func addHabbite() {
        let controller = CreationNewTrakersViewController()
        self.present(controller, animated: true, completion: nil)
    }
    
//    @objc
//    private func addHabbite() {
//        let newTracker = visibleTrackers.count
//        
//        visibleTrackers.append(trackers[newTracker])
//        collectionView.performBatchUpdates {
//            collectionView.insertItems(at: [IndexPath(item: newTracker, section: 0)])
//        }
//        
//        //временно сдесь
//        placeholderVisible()
//    }

    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
    }
    
    //add view
    private func setupView() {
        view.backgroundColor = .white
        
        [placeholderImageView, emptyLabel, titleLabel, collectionView, searchContainer].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func addAllConstraints() {
        let guide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            //Image view
            placeholderImageView.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            placeholderImageView.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
            
            //emptyLabel
            emptyLabel.centerXAnchor.constraint(equalTo: placeholderImageView.centerXAnchor),
            emptyLabel.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 8),
            
            //titleLabel
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: guide.topAnchor),
            
            //collectionView
            collectionView.topAnchor.constraint(equalTo: searchContainer.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            //searchBar
            searchContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            searchContainer.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
}

extension TrackersViewController {
    func setupSearchBar() {
        searchBar.placeholder = "Поиск"
        searchBar.delegate = self
        searchBar.searchTextField.layer.masksToBounds = true
        searchBar.backgroundImage = UIImage()
        
        searchContainer.addSubview(searchBar)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: searchContainer.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: searchContainer.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: searchContainer.trailingAnchor),
            searchBar.bottomAnchor.constraint(equalTo: searchContainer.bottomAnchor)
        ])
    }
}
