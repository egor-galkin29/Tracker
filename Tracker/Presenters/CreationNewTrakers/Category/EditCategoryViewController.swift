import UIKit

protocol EditCategoryViewControllerDelegate: AnyObject {
    func editNewCategoryName(oldCategoryName: String, newCategoryName: String)
}

final class EditCategoryViewController: UIViewController, UITextFieldDelegate {
    weak var delegate: EditCategoryViewControllerDelegate?
    var oldCategoryName: String = ""
    
    /// Заголовок окна создания новой категории
    private lazy var  editCategoryTitle: UILabel = {
        let label = UILabel()
        let localizedString = NSLocalizedString("editCategoryTitle", comment: "")
        label.text = localizedString
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Заголовок ввода названия новой категории
    private lazy var editCategoryName: UITextField = {
        let textField = UITextField()
        let localizedString = NSLocalizedString("editCategoryPlaceholder", comment: "")
        textField.placeholder = localizedString
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.borderStyle = .none
        textField.backgroundColor = .ypLightGray
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.clearButtonMode = .whileEditing
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.addTarget(self, action: #selector(editCategoryName(_:)), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // Кнопка создания новой категории
    private lazy var editCategoryCreate: UIButton = {
        let button = UIButton()
        let localizedString = NSLocalizedString("scheduleCreate", comment: "")
        button.setTitle(localizedString, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .ypGray
        button.accessibilityIdentifier = "newCategoryCreate"
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(editCategoryCreateButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "EditCategoryVC"
        view.backgroundColor = .white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardSwitchOff))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        editCategoryName.delegate = self
        
        createView()
        editCategoryName.text = oldCategoryName
    }
    
    /// Метод создания UI
    private func createView() {
        
        view.addSubview(editCategoryTitle)
        view.addSubview(editCategoryName)
        view.addSubview(editCategoryCreate)
        
        NSLayoutConstraint.activate([
            editCategoryTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            editCategoryTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            editCategoryName.topAnchor.constraint(equalTo: editCategoryTitle.bottomAnchor, constant: 38),
            editCategoryName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editCategoryName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            editCategoryName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            editCategoryName.heightAnchor.constraint(equalToConstant: 75),
            
            editCategoryCreate.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editCategoryCreate.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            editCategoryCreate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            editCategoryCreate.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            editCategoryCreate.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    
    @objc private func editCategoryName(_ sender: UITextField) {
        blockButtons()
    }
    
    @objc private func keyboardSwitchOff() {
        view.endEditing(true)
    }
    
    private func blockButtons() {
        guard let categoryName = editCategoryName.text else { return }
        
        if categoryName.isEmpty == false {
            editCategoryCreate.isEnabled = true
            editCategoryCreate.backgroundColor = .black
        } else {
            editCategoryCreate.isEnabled = false
            editCategoryCreate.backgroundColor = .ypGray
        }
    }
    
    @objc private func editCategoryCreateButtonPressed() {
        guard let newCategoryName = editCategoryName.text else { return }
        delegate?.editNewCategoryName(oldCategoryName: oldCategoryName , newCategoryName: newCategoryName)
        dismiss(animated: true, completion: nil)
    }
}
