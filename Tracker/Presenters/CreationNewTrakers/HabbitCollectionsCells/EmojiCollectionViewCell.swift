import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "EmojiCell"
    
        let emojiLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 32)
            label.textAlignment = .center
            label.backgroundColor = .white
            label.clipsToBounds = true
            label.layer.cornerRadius = 16
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            contentView.addSubview(emojiLabel)
            NSLayoutConstraint.activate([
                emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                emojiLabel.widthAnchor.constraint(equalToConstant: 52),
                emojiLabel.heightAnchor.constraint(equalToConstant: 52),
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configure(with emoji: String) {
            emojiLabel.text = emoji
        }
}
