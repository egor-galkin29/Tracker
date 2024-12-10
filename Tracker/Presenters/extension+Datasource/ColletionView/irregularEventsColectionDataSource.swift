import UIKit

extension IrregularEventsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == emojiCollectionView {
            return emojis.count
        } else {
            return colors.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojiCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCollectionViewCell.reuseIdentifier, for: indexPath) as! EmojiCollectionViewCell
            cell.configure(with: emojis[indexPath.item])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionCell.reuseIdentifier, for: indexPath) as! ColorCollectionCell
            cell.innerColorView.backgroundColor = colors[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
}

extension IrregularEventsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell else { return }
            selectedEmoji = emojis[indexPath.row]
            cell.emojiLabel.backgroundColor = .ypLightGray
        } else {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionCell else { return }
            selectedColor = colors[indexPath.row]
            cell.colorView.layer.borderColor = selectedColor?.withAlphaComponent(0.3).cgColor
        }
        
        blockButtons()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell
            cell?.emojiLabel.backgroundColor = .white
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionCell
            cell?.colorView.layer.borderColor = UIColor.white.cgColor
        }
        blockButtons()
    }
}

