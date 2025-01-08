import UIKit

// MARK: StatisticViewController

final class StatisticViewController: UIViewController, UICollectionViewDelegate {
    /// Картинка для заглушки
    private lazy var statisticPlaceholderImage: UIImageView = {
        let image = UIImageView()
        let placeholder = UIImage.statisticPlaceholder
        image.image = placeholder
        image.isHidden = true
        return image
    }()
    
    /// Текст для заглушки
    private lazy var statisticPlaceholderLabel: UILabel = {
        let label = UILabel()
        let localizedStatisticPlaceholderTitle = NSLocalizedString("statisticPlaceholder", comment: "")
        label.text = localizedStatisticPlaceholderTitle
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    /// Коллекшн вью для трекеров
    private lazy var statisticsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(StatisticsCellViewController.self, forCellWithReuseIdentifier: "statisticsCell")
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    let trackerRecordStore = TrackerRecordStore.shared
    let statisticsTitle: [String] = [NSLocalizedString("countOfTrackersToComplete", comment: "")]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setNavigationBar()
        commonStatisticVCConstraint()
        placeholderVisible()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        placeholderVisible()
    }
    
    /// Настройки навибара
    private func setNavigationBar() {
        let localizedStatisticsTitle = NSLocalizedString("statisticsAppTitle", comment: "")
        self.navigationItem.title = localizedStatisticsTitle
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    /// Функция отображения заглушки
    private func placeholderVisible() {
        let completedTrackersCount: Int = trackerRecordStore.allCompletedTrackersCount()
        let nonNilCountOfTrackers: Bool = completedTrackersCount > 0
        
        statisticPlaceholderImage.isHidden = nonNilCountOfTrackers
        statisticPlaceholderLabel.isHidden = nonNilCountOfTrackers
        statisticsCollectionView.isHidden = !nonNilCountOfTrackers
        
        statisticsCollectionView.reloadData()
    }
    
    /// Привязка элементов к экрану
    private func commonStatisticVCConstraint() {
        view.accessibilityIdentifier = "StatisticViewController"
        view.backgroundColor = .white
        
        [statisticPlaceholderImage, statisticPlaceholderLabel, statisticsCollectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            statisticPlaceholderImage.widthAnchor.constraint(equalToConstant: 80),
            statisticPlaceholderImage.heightAnchor.constraint(equalToConstant: 80),
            
            statisticPlaceholderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statisticPlaceholderImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            statisticPlaceholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statisticPlaceholderLabel.topAnchor.constraint(equalTo: statisticPlaceholderImage.bottomAnchor, constant: 8),
            
            statisticsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 77),
            statisticsCollectionView.heightAnchor.constraint(equalToConstant: 396),
            statisticsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statisticsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

extension StatisticViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return statisticsTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "statisticsCell", for: indexPath) as? StatisticsCellViewController else { return UICollectionViewCell() }
        
        let statisticsCellTitle = statisticsTitle[indexPath.section]
        let completedTrackersCount: Int = trackerRecordStore.allCompletedTrackersCount()
        cell.backgroundColor = .white
        cell.statisticsCount.text = String(completedTrackersCount)
        cell.statisticsType.text = statisticsCellTitle
        return cell
    }
}

/// Параметры расположения ячеек
extension StatisticViewController: UICollectionViewDelegateFlowLayout {
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { // 1
        return CGSize(width: collectionView.frame.width - 32, height: 90)
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 12, right: 16)
    }
    
}
