import UIKit
// MARK: ViewController

final class TrackersViewController: UIViewController, UISearchBarDelegate {
    
    // MARK: UI
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 9
        layout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "trackerCell")
        collectionView.register(TrackerCellSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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
    
    private lazy var pickerDate: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.accessibilityIdentifier = "currentDatePicker"
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        datePicker.locale = Locale(identifier: "ru_RU")
        return datePicker
    }()
    
    private let datePickerContainer = UIView()
    
    // MARK: Public Properties
    
    var visibleTrackers: [Tracker] = []
    var categories: [TrackerCategory] = []
        
    let trackerStore = TrackerStore.shared
    let trackerRecordStore = TrackerRecordStore.shared
    
    var currentDate: Date? {
        let selectedDate = pickerDate.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateFormatter.string(from: selectedDate)
        return dateFormatter.date(from: formattedDate) ?? Date()
    }
    
    // MARK: Private Properties
    
    private let searchContainer = UIView()
    private let searchBar = UISearchBar()
    
    private var trackers: [Tracker] = []
    private var categoryName: [String] = []
    
    private var completedTrackersID = Set<UUID>()
    
    // MARK: @objc
    
    @objc private func addHabbite() {
        let controller = CreationNewTrakersViewController()
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        let selectedDate = dateFormatter.string(from: sender.date)
        currentTrackersView()
    }
    
    @objc private func didReceiveNewTrackerNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        if let newTracker = userInfo["first"] as? Tracker,
           let selectedCategoryString = userInfo["second"] as? String? {
            trackers.append(newTracker)
            guard let selectedCategory = selectedCategoryString else { return }
            let newCategory = TrackerCategory(title: selectedCategory, trackers: trackers)
            self.categories = [newCategory]
        } else {
            print("Ошибка добавления трекера")
        }
        
        collectionView.reloadData()
        currentTrackersView()
        placeholderVisible()
    }
    // MARK: Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mokTrackers()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNewTrackerNotification(_:)), name: .didCreateNewTracker, object: nil)
        
        
        setupCollectionView()
        setupView()
        setUpNavigationBar()
        addAllConstraints()
        setupSearchBar()
        trackerStore.importCoreDataTracker()
        
        currentTrackersView()
    }
    
    // MARK: Public Methods
    
    func mokTrackers() {
        let mokTracker_1 = Tracker(id: UUID(), title: "MOK Tracker_1", color: .red, emoji: "😻", schedule: [.wednesday, .saturday])
        let mokTracker_2 = Tracker(id: UUID(), title: "MOK Tracker_2", color: .green, emoji: "😻", schedule: [.wednesday, .friday])
        let mokTracker_3 = Tracker(id: UUID(), title: "MOK Tracker_3", color: .orange, emoji: "😻", schedule: [.saturday])
        [mokTracker_1, mokTracker_2, mokTracker_3].forEach {
            trackers.append($0)
            visibleTrackers.append($0)
        }
        
        let category_1 = TrackerCategory(title: "Важное", trackers: [mokTracker_1, mokTracker_2, mokTracker_3])
        categories.append(category_1)
        
        categoryName.append(category_1.title)
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
    
    private func setupCollectionView() {
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
        let customItem = UIBarButtonItem(customView: datePickerContainer)
        navigationItem.rightBarButtonItem = customItem
    }
    
    //add view
    private func setupView() {
        view.backgroundColor = .white
        
        [placeholderImageView, emptyLabel, titleLabel, collectionView, searchContainer].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        datePickerContainer.addSubview(pickerDate)
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
            collectionView.topAnchor.constraint(equalTo: searchContainer.bottomAnchor, constant: 30),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            //searchBar
            searchContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            searchContainer.heightAnchor.constraint(equalToConstant: 44),
            
            //pickerDate
            pickerDate.centerXAnchor.constraint(equalTo: datePickerContainer.centerXAnchor),
            pickerDate.centerYAnchor.constraint(equalTo: datePickerContainer.centerYAnchor)
        ])
    }
    
    private func currentTrackersView() {
        let currentDate = pickerDate.date
        let calendar = Calendar.current
        var currentWeekDay = calendar.component(.weekday, from: currentDate)
        currentWeekDay = (currentWeekDay + 5) % 7
        
        let trackersFromCoreData = trackerStore.importCoreDataTracker()
        let appTrackers = trackersFromCoreData.map { Tracker(from: $0)}
        
        visibleTrackers = []
        
//        for category in categories {
//            for onetracker in category.trackers where (onetracker.schedule.contains(WeekDays.allCases[currentWeekDay]))  {
//                visibleTrackers.append(onetracker)
//            }
//        }
        
        visibleTrackers = appTrackers.filter { tracker in
            let trackerScheduleDays = tracker.schedule.contains(WeekDays.allCases[currentWeekDay])
            return trackerScheduleDays
        }
        
        visibleTrackers = Array(visibleTrackers.reduce(into: [UUID: Tracker]()) { $0[$1.id] = $1 }.values)

        collectionView.reloadData()
        placeholderVisible()
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

extension TrackersViewController: TrackerCellDelegate {
    func completeTracker(_ trackerCell: CollectionViewCell, id: UUID, trackerDone: Bool) {
        let calendar = Calendar.current
        
        if trackerDone {
            completedTrackersID.insert(id)
            trackerRecordStore.saveRecordToCoreData(id: id, trackerDate: currentDate ?? Date())
            collectionView.reloadData()
        } else {
            completedTrackersID.remove(id)
            trackerRecordStore.deleteRecordFromCoreData(id: id, trackerDate: currentDate ?? Date())
            collectionView.reloadData()
        }
    }
}

extension Notification.Name {
    static let didCreateNewTracker = Notification.Name("didCreateNewTracker")
}

