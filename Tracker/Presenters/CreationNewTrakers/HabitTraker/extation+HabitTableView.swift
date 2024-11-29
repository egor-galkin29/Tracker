import UIKit

extension HabitViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 // Категория и Расписание
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75 // Устанавливаем высоту ячейки
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "optionCell")
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "Категория"
            //cell.detailTextLabel?.text = "Новая категория"
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
            //cell.detailTextLabel?.textColor = .grayYp
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "Расписание"
            //cell.detailTextLabel?.text = selectedScheduleString()
            //print("\(selectedScheduleString())")
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
            //cell.detailTextLabel?.textColor = .grayYp
        }
        
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .ypLightGrey
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            // Убираем разделитель для последней ячейки
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            // Восстанавливаем стандартный разделитель для остальных ячеек
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
    
    
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 1 {
//            let controller = HabitScheduleViewController()
//            controller.delegate = self
//            self.present(controller, animated: true, completion: nil)
        }
        else {
            let controller = ChoosingCategoryViewController()
            //controller.delegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    // Убираем отступы между секциями и ячейками
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0 // Убираем отступы перед секцией
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0 // Убираем отступы после секции
    }
    
    // Убираем отступы между ячейками
    func tableView(_ tableView: UITableView, layoutMarginsForItemAt indexPath: IndexPath) -> UIEdgeInsets {
        return UIEdgeInsets.zero // Минимизируем отступы между ячейками
    }
    
}
