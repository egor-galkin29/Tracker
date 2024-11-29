import UIKit

extension HabitViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Properties cell")
        
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 16
        cell.layer.masksToBounds = true
        
        if indexPath.row == 0 {
            let trackerCategory = selectedCategory ?? ""
            cell.textLabel?.text = "Категория"
            cell.detailTextLabel?.text = trackerCategory
            cell.detailTextLabel?.textColor = .ypGray
        } else if indexPath.row == 1 {
            let trackerSchedule = selectedSchedule ?? ""
            cell.textLabel?.text = "Расписание"
            cell.detailTextLabel?.text = trackerSchedule
            cell.detailTextLabel?.textColor = .ypGray
            
            if indexPath.row == 1 {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
                cell.layoutMargins = .zero
            } else {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
                cell.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let categoryVC = ChoosingCategoryViewController()
            present(categoryVC, animated: true, completion: nil)
        } else if indexPath.row == 1 {
//            let scheduleVC = ScheduleViewController()
//            navigationController?.pushViewController(scheduleVC, animated: true)
            print("переход н расписание")
        }
    }
}
