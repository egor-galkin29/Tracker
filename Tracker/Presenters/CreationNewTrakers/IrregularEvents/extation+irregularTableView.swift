import UIKit

extension IrregularEventsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "irregular cell")
        
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 16
        cell.layer.masksToBounds = true
        
        let trackerCategory = selectedCategory ?? ""
        cell.textLabel?.text = "Категория"
        cell.detailTextLabel?.text = trackerCategory
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
        cell.detailTextLabel?.textColor = .ypGray
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        
//                    let controller = CategoryViewController()
//                    controller.delegate = self
//                    self.present(controller, animated: true, completion: nil)
//    }
}
