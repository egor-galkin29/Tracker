import UIKit

final class ColorCollectionCell: UICollectionViewCell {
    static let reuseIdentifier = "ColorCell"
    
    lazy var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.white.cgColor 
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var innerColorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(colorView)
        colorView.addSubview(innerColorView)
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            innerColorView.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 6),
            innerColorView.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -6),
            innerColorView.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 6),
            innerColorView.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -6)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
