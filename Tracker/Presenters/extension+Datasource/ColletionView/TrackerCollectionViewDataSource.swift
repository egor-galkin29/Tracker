import UIKit

extension TrackersViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackerCell", for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        
        let isCompletedToday = trackerRecordStore.importCoreDataRecordComplete(id: tracker.id, trackerDate: currentDate ?? Date())
        
        cell.trackerDone = isCompletedToday
        cell.configure(with: tracker, isCompletedToday: isCompletedToday)
        cell.delegate = self
        
        if (currentDate ?? Date()) <= Date() {
            cell.doneButton.isEnabled = true
        } else {
            cell.doneButton.isEnabled = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = "header"
        case UICollectionView.elementKindSectionFooter:
            id = "footer"
        default:
            id = ""
        }
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as! TrackerCellSupplementaryView
        view.titleLabel.text = visibleCategories[indexPath.section].title
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 9) / 2, height: 148)
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard indexPaths.count > 0 else {
            return nil
        }
        
        let indexPath = indexPaths[0]
        let thisTracker = visibleCategories[indexPath.section].trackers[indexPath.item]

        return UIContextMenuConfiguration(actionProvider: { actions in
            let localizedContextMenuPin = NSLocalizedString("contextMenuPin", comment: "")
            let localizedContextMenuUnpin = NSLocalizedString("contextMenuUnpin", comment: "")
            let localizedContextMenuEdit = NSLocalizedString("contextMenuEdit", comment: "")
            let localizedContextMenuDelete = NSLocalizedString("contextMenuDelete", comment: "")
            
//            let pinTracker = UIAction(title: thisTracker.pinned ? localizedContextMenuUnpin : localizedContextMenuPin,
//                                      image: UIImage(systemName: "pin")) { [self] action in
//                
//                if thisTracker.pinned {
//                    self.trackerStore.unPinTracker(trackerID: thisTracker.id)
//                } else {
//                    self.trackerStore.pinTracker(trackerID: thisTracker.id)
//                }
//                self.categories = (try? self.trackerCategoryStore.importCategoryWithTrackersFromCoreData()) ?? []
//                self.currentCategoriesView()
//                self.placeholderVisible()
//                self.trackerCollectionView.reloadData()
//            }
            
            let editTracker =
            UIAction(title: localizedContextMenuEdit,
                     image: UIImage(systemName: "pencil")) { action in
                self.editTracker(indexPath: indexPath)
                AnalyticsService.contextEditTrackerReport()
            }
            
            let deleteAction =
            UIAction(title: localizedContextMenuDelete,
                     image: UIImage(systemName: "trash"),
                     attributes: .destructive) { action in
                
                self.deleteTracker(indexPath: indexPath)
                AnalyticsService.contextDeleteTrackerReport()
            }
            
            return UIMenu(title: "", children: [/*pinTracker,*/ editTracker, deleteAction])
        })
    }
    
    private func editTracker(indexPath: IndexPath) {
            let trackerToEdit = visibleCategories[indexPath.section].trackers[indexPath.item]
            let trackerCategoryToEdit = visibleCategories[indexPath.section].title
            let controller = EditTrackerViewController(editedTracker: trackerToEdit, editedCategory: trackerCategoryToEdit, selectedCategory: trackerCategoryToEdit)
            controller.delegate = self
            controller.editedTracker = trackerToEdit
            print(visibleCategories[indexPath.section].categoryTrackers[indexPath.item].trackerColor)
            controller.trackerType = trackerToEdit.trackerType
            self.present(controller, animated: true, completion: nil)
        }
    
    private func deleteTracker(indexPath: IndexPath) {
        showDeleteAlert(indexPath: indexPath)
    }
    
    private func showDeleteAlert(indexPath: IndexPath) {
        let trackerID = visibleCategories[indexPath.section].trackers[indexPath.item].id
        
        let localizedContextDeleteQuestion = NSLocalizedString("contextDeleteQuestion", comment: "")
        let localizedContextDeleteButton = NSLocalizedString("contextMenuDelete", comment: "")
        let localizedContextCancelButton = NSLocalizedString("cancelButton", comment: "")
        
        let alert = UIAlertController(title: localizedContextDeleteQuestion, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: localizedContextDeleteButton,
                                      style: .destructive,
                                      handler: { [weak self] _ in
            
            guard let self else { return }
            self.visibleCategories.removeAll{$0.trackers.contains(where: {$0.id == trackerID})}
            try? self.trackerStore.deleteTrackerFromCoreData(trackerID: trackerID)
            trackerRecordStore.deleteRecordFromCoreDataForStatistic(id: trackerID)
            
            self.categories = (try? self.trackerCategoryStore.importCategoryWithTrackersFromCoreData()) ?? []
            self.currentTrackersView()
            self.placeholderVisible()
            self.collectionView.reloadData()
            
        }))
        alert.addAction(UIAlertAction(title: localizedContextCancelButton, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
