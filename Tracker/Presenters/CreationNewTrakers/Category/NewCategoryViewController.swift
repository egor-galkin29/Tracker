import UIKit

protocol NewCategoryViewControllerDelegate: AnyObject {
    func createNewCategoryName(categoryName: String)
}

final class NewCategoryViewController: UIViewController, UITextFieldDelegate {
    
    weak var delegate: NewCategoryViewControllerDelegate?
    
    private lazy var  newCategoryTitle: UILabel = {
        let label = UILabel()
        let localizedString = NSLocalizedString("newCategoryTitle", comment: "")
        label.text = localizedString
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var newCategoryName: UITextField = {
        let textField = UITextField()
        let localizedString = NSLocalizedString("newCategoryPlaceholder", comment: "")
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
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        let localizedString = NSLocalizedString("scheduleCreate", comment: "")
        button.setTitle(localizedString, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .ypGray
        button.accessibilityIdentifier = "newCategoryCreate"
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(newCategoryCreateButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "NewCategoryVC"
        view.backgroundColor = .white
        
        newCategoryName.delegate = self
        
        createView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func createView() {
        
        view.addSubview(newCategoryTitle)
        view.addSubview(newCategoryName)
        view.addSubview(createButton)
        
        NSLayoutConstraint.activate([
            newCategoryTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            newCategoryTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            newCategoryName.topAnchor.constraint(equalTo: newCategoryTitle.bottomAnchor, constant: 38),
            newCategoryName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newCategoryName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            newCategoryName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            newCategoryName.heightAnchor.constraint(equalToConstant: 75),
            
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    
    @objc private func editCategoryName(_ sender: UITextField) {
        blockButtons()
    }
    
    private func blockButtons() {
        guard let categoryName = newCategoryName.text else { return }
        
        if categoryName.isEmpty == false {
            createButton.isEnabled = true
            createButton.backgroundColor = .black
        } else {
            createButton.isEnabled = false
            createButton.backgroundColor = .ypGray
        }
    }
    
    @objc private func newCategoryCreateButtonPressed() {
        guard let categoryName = newCategoryName.text else { return }
        delegate?.createNewCategoryName(categoryName: categoryName)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}
