import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func didSelectSchedule(schedule: [WeekDays])
}

final class ScheduleViewController: UIViewController {
    
    private lazy var scheduleTableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .ypLightGray
        tableView.separatorInset.left = 16
        tableView.separatorInset.right = 16
        tableView.contentInset.top = -35
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "scheduleCell")
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private lazy var scheduleLabel: UILabel = {
        let scheduleLabel = UILabel()
        scheduleLabel.text = "Расписание"
        scheduleLabel.font = UIFont.systemFont(ofSize: 16)
        return scheduleLabel
        
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Готово", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: ScheduleViewControllerDelegate?
    private var selectedDays: [WeekDays] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupView()
        blockButton()
    }
    
    private func setupView() {
        
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self        
        
        [scheduleTableView, doneButton, scheduleLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            scheduleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            scheduleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scheduleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            scheduleTableView.topAnchor.constraint(equalTo: scheduleLabel.bottomAnchor, constant: 30),
            scheduleTableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -47),
            scheduleTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scheduleTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        print("fghjkl;")
    }
    
    @objc private func didTapDoneButton() {
                delegate?.didSelectSchedule(schedule: selectedDays)
                print("ЗАДАНЫ СДЕЛУЮЩИЕ ДНИ НЕДЕЛИ ДЛЯ ТРЕКЕРА: \(selectedDays)")
                dismiss(animated: true, completion: nil)
        }
        
        private func blockButton() {
            if selectedDays.isEmpty {
                doneButton.isEnabled = false
                doneButton.backgroundColor = .ypGray
            } else {
                doneButton.isEnabled = true
                doneButton.backgroundColor = .black
            }
        }
}

extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeekDays.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath)
        let weekDay = WeekDays.allCases[indexPath.row]
        cell.textLabel?.text = weekDay.rawValue
        cell.backgroundColor = .ypLightGray
        cell.selectionStyle = .none
        
        let dayToggle = UISwitch()
        cell.accessoryView = dayToggle
        dayToggle.onTintColor = .ypBlue
        dayToggle.addTarget(self, action: #selector(selectedDay), for: .valueChanged)
        dayToggle.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / 7
    }
    
    @objc private func selectedDay(_ sender: UISwitch) {
        let day = WeekDays.allCases[sender.tag]
        
        if sender.isOn {
            selectedDays.append(day)
            blockButton()
            print(selectedDays)
        } else {
            selectedDays.removeAll { $0 == day }
            blockButton()
        }
    }
}
