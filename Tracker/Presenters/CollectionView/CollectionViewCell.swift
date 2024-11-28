import UIKit

final class CollectionViewCell: UICollectionViewCell {
    private var cellView: UIView = {
        let view = UIView()
        //view.backgroundColor = .orange
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private let emojiLable: UILabel = {
        let label = UILabel()
       // label.text = "😳"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.backgroundColor = .white.withAlphaComponent(0.3)
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionLable: UILabel = {
        let label = UILabel()
        //label.text = "выебать мишин рот два раза"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        return label
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton()
        let buttonImageNormal = UIImage(systemName: "plus")
        //button.backgroundColor = .green
        button.layer.cornerRadius = 17
        button.setImage(buttonImageNormal, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let daysCountLable: UILabel = {
        let label = UILabel()
        label.text = "1 день"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private var trackerDone: Bool = false
    private var trackerID: UUID?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        descriptionLable.preferredMaxLayoutWidth = cellView.bounds.width
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [cellView,
         doneButton, daysCountLable].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        cellView.addSubview(emojiLable)
        emojiLable.translatesAutoresizingMaskIntoConstraints = false
        
        cellView.addSubview(descriptionLable)
        descriptionLable.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellView.heightAnchor.constraint(equalToConstant: 90),
            cellView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            
            emojiLable.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 12),
            emojiLable.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 12),
            emojiLable.widthAnchor.constraint(equalToConstant: 24),
            emojiLable.heightAnchor.constraint(equalToConstant: 24),
            
            descriptionLable.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -12),
            descriptionLable.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 12),
            descriptionLable.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -12),
            
            doneButton.widthAnchor.constraint(equalToConstant: 34),
            doneButton.heightAnchor.constraint(equalToConstant: 34),
            doneButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            doneButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            daysCountLable.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            daysCountLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12)
        ])
    }
    
    @objc func doneButtonPressed() {
        trackerDone = !trackerDone
        let imageName = trackerDone ? "checkmark" : "plus"
        doneButton.setImage(UIImage(systemName: imageName), for: .normal)
        doneButton.alpha = trackerDone ? 0.3 : 1.0
//        if let id = trackerID {
//            delegate?.completeTracker(self, id: id, trackerDone: trackerDone)
//            print("НОМЕР ТРЕКЕРА \(id)")
//        }
    }
    
    func configure(with tracker: Tracker/*, completedCount: Int, isCompletedToday: Bool*/) {
        emojiLable.text = tracker.emoji
        descriptionLable.text = tracker.title
        cellView.backgroundColor = tracker.color
        doneButton.backgroundColor = tracker.color
        trackerID = tracker.id
        //daysCountLable.text = daysText(for: completedCount)
        let imageName = trackerDone ? "checkmark" : "plus"
        doneButton.setImage(UIImage(systemName: imageName), for: .normal)
        doneButton.alpha = trackerDone ? 0.3 : 1.0
    }
}
