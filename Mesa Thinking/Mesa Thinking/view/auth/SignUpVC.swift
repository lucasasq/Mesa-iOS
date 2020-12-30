import UIKit
import MaterialComponents.MaterialTextControls_FilledTextAreas
import MaterialComponents.MaterialTextControls_FilledTextFields
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields
import RxSwift
import RxCocoa

class SignUpVC: UIViewController
{
    var nameTextField = MDCOutlinedTextField()
    var emailTextField = MDCOutlinedTextField()
    var dateOfBirth = MDCOutlinedTextField()
    var passwordTextField = MDCOutlinedTextField()
    var passwordRepeatTextField = MDCOutlinedTextField()
    var signUpButton = UIButton()
    var authViewModel = AuthViewModel()
    let disposeBag = DisposeBag()
    
    
    //MARK: - View's cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setViews()
        setConstraints()
        setBindings()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        //set notifys keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Cadastre-se!" // name in the title
    }
    
    //MARK: - Tap buttons
    @objc func signUpTap()
    {
        if(authViewModel.validateFields(emailTextField.text!, name: nameTextField.text!, andPassword: passwordTextField.text!, password2: passwordRepeatTextField.text!, dateOfBirth: dateOfBirth.text!))
        {
            //        authViewModel.signUp("johne@doe.com", name: "John Doe", andPassword: "1234567", password2: "123456", dateOfBirth: "20/10/1997")
            
            authViewModel.signUp(email: emailTextField.text!, name: nameTextField.text!, andPassword: passwordTextField.text!, dateOfBirth: dateOfBirth.text!)
        }
        else
        {
            MessageView.sharedInstance.showOnView(message: "Corrija x campo", theme: .warning)
        }
        
    }
    //MARK: - setBindings to our view and variable of view model
    fileprivate func setBindings()
    {
        authViewModel.loading
            .bind(to: self.rx.isAnimating)
            .disposed(by: disposeBag)
        
        authViewModel.logged
            .asObservable()
            .subscribe(onNext: {
                value in
                if(value)
                {
                    //we will send user to home screen
                    self.showNextPage()
                }
            }).disposed(by: disposeBag)
    }
    
    //MARK: - Methods
    fileprivate func showNextPage()
    {
        let viewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    //MARK: - Notifys keyboard
    @objc func keyboardWillHide()
    {
        self.view.frame.origin.y = 0
    }

    @objc func keyboardWillChange(notification: NSNotification)
    {

        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil
        {
            if dateOfBirth.isFirstResponder {
                let tabBarHeight = 120
                self.view.frame.origin.y = -100
            }
            
            if passwordTextField.isFirstResponder {
                let tabBarHeight = 120
                self.view.frame.origin.y = -120
            }
            
            if passwordRepeatTextField.isFirstResponder {
                let tabBarHeight = 120
                self.view.frame.origin.y = -140
            }
            
        }
    }
    
    
    //MARK: - Set views
    fileprivate func setViews()
    {
        setNameField()
        setEmailField()
        setDateOfBirthTextField()
        setPasswordField()
        setPasswordRepeatField()
        setSignUpButton()
    }
    
    fileprivate func setNameField()
    {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        nameTextField = MDCOutlinedTextField(frame: frame)
        nameTextField.setFloatingLabelColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.normal)
        nameTextField.setFloatingLabelColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.disabled)
        nameTextField.setFloatingLabelColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.editing)
        
        nameTextField.setNormalLabelColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.editing)
        nameTextField.setNormalLabelColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.normal)
        nameTextField.setNormalLabelColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.disabled)
        
        nameTextField.setTextColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.editing)
        nameTextField.setTextColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.disabled)
        nameTextField.setTextColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.normal)
        
        nameTextField.backgroundColor = .white
        nameTextField.sizeToFit()
        
        nameTextField.setOutlineColor(UIColor(red: 0.855, green: 0.855, blue: 0.855, alpha: 1), for: MDCTextControlState.normal)
        nameTextField.setOutlineColor(UIColor(red: 0.855, green: 0.855, blue: 0.855, alpha: 1), for: MDCTextControlState.editing)
        nameTextField.setOutlineColor(UIColor(red: 0.855, green: 0.855, blue: 0.855, alpha: 1), for: MDCTextControlState.disabled)
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.14
        nameTextField.label.text = "Nome"
        self.view.addSubview(nameTextField)
        
    }
    
    fileprivate func setEmailField()
    {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        emailTextField = MDCOutlinedTextField(frame: frame)
        
        emailTextField.setFloatingLabelColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.normal)
        emailTextField.setFloatingLabelColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.disabled)
        emailTextField.setFloatingLabelColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.editing)
        
        emailTextField.setNormalLabelColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.editing)
        emailTextField.setNormalLabelColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.normal)
        emailTextField.setNormalLabelColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.disabled)
        
        emailTextField.setTextColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.editing)
        emailTextField.setTextColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.disabled)
        emailTextField.setTextColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.normal)
        
        emailTextField.backgroundColor = .white
        emailTextField.sizeToFit()
        
        emailTextField.setOutlineColor(UIColor(red: 0.855, green: 0.855, blue: 0.855, alpha: 1), for: MDCTextControlState.normal)
        emailTextField.setOutlineColor(UIColor(red: 0.855, green: 0.855, blue: 0.855, alpha: 1), for: MDCTextControlState.editing)
        emailTextField.setOutlineColor(UIColor(red: 0.855, green: 0.855, blue: 0.855, alpha: 1), for: MDCTextControlState.disabled)
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.14
        emailTextField.label.text = "E-mail"
        self.view.addSubview(emailTextField)
    }
    
    fileprivate func setDateOfBirthTextField()
    {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        dateOfBirth = MDCOutlinedTextField(frame: frame)
        
        dateOfBirth.setFloatingLabelColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.normal)
        dateOfBirth.setFloatingLabelColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.disabled)
        dateOfBirth.setFloatingLabelColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.editing)
        
        dateOfBirth.setNormalLabelColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.editing)
        dateOfBirth.setNormalLabelColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.normal)
        dateOfBirth.setNormalLabelColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.disabled)
        
        dateOfBirth.setTextColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.editing)
        dateOfBirth.setTextColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.disabled)
        dateOfBirth.setTextColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.normal)
        
        dateOfBirth.backgroundColor = .white
        dateOfBirth.sizeToFit()
        
        dateOfBirth.setOutlineColor(UIColor(red: 0.855, green: 0.855, blue: 0.855, alpha: 1), for: MDCTextControlState.normal)
        dateOfBirth.setOutlineColor(UIColor(red: 0.855, green: 0.855, blue: 0.855, alpha: 1), for: MDCTextControlState.editing)
        dateOfBirth.setOutlineColor(UIColor(red: 0.855, green: 0.855, blue: 0.855, alpha: 1), for: MDCTextControlState.disabled)
        self.dateOfBirth.keyboardType = UIKeyboardType.numberPad
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.14
        dateOfBirth.label.text = "Data de nascimento"
        self.view.addSubview(dateOfBirth)
        
        dateOfBirth.addTarget(self, action: #selector(onTextFieldEditingChanged(_:)), for: .editingChanged)
        
    }
    @objc
    func onTextFieldEditingChanged(_ textField: UITextField)
    {
        
        if let text = dateOfBirth.text, text.count >= 10 {
            dateOfBirth.text = String(text.dropLast(text.count - 10))
            return
        }
        
        guard let text = dateOfBirth.text else { return }
        dateOfBirth.text = text.applyPatternOnNumbers(pattern: "##/##/####", replacmentCharacter: "#")
        
        
    }
    
    
    fileprivate func setPasswordField()
    {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        passwordTextField = MDCOutlinedTextField(frame: frame)
        
        passwordTextField.setFloatingLabelColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.normal)
        passwordTextField.setFloatingLabelColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.disabled)
        passwordTextField.setFloatingLabelColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.editing)
        
        passwordTextField.setNormalLabelColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.editing)
        passwordTextField.setNormalLabelColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.normal)
        passwordTextField.setNormalLabelColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.disabled)
        
        passwordTextField.setTextColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.editing)
        passwordTextField.setTextColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.disabled)
        passwordTextField.setTextColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.normal)
        
        passwordTextField.backgroundColor = .white
        passwordTextField.sizeToFit()
        
        passwordTextField.setOutlineColor(UIColor(red: 0.855, green: 0.855, blue: 0.855, alpha: 1), for: MDCTextControlState.normal)
        passwordTextField.setOutlineColor(UIColor(red: 0.855, green: 0.855, blue: 0.855, alpha: 1), for: MDCTextControlState.editing)
        passwordTextField.setOutlineColor(UIColor(red: 0.855, green: 0.855, blue: 0.855, alpha: 1), for: MDCTextControlState.disabled)
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.14
        passwordTextField.label.text = "Senha"
        passwordTextField.isSecureTextEntry = true
        self.view.addSubview(passwordTextField)
    }
    
    fileprivate func setPasswordRepeatField()
    {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        passwordRepeatTextField = MDCOutlinedTextField(frame: frame)
        
        passwordRepeatTextField.setFloatingLabelColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.normal)
        passwordRepeatTextField.setFloatingLabelColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.disabled)
        passwordRepeatTextField.setFloatingLabelColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.editing)
        
        passwordRepeatTextField.setNormalLabelColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.editing)
        passwordRepeatTextField.setNormalLabelColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.normal)
        passwordRepeatTextField.setNormalLabelColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.disabled)
        
        passwordRepeatTextField.setTextColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.editing)
        passwordRepeatTextField.setTextColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.disabled)
        passwordRepeatTextField.setTextColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.normal)
        
        passwordRepeatTextField.backgroundColor = .white
        passwordRepeatTextField.sizeToFit()
        
        passwordRepeatTextField.setOutlineColor(UIColor(red: 0.855, green: 0.855, blue: 0.855, alpha: 1), for: MDCTextControlState.normal)
        passwordRepeatTextField.setOutlineColor(UIColor(red: 0.855, green: 0.855, blue: 0.855, alpha: 1), for: MDCTextControlState.editing)
        passwordRepeatTextField.setOutlineColor(UIColor(red: 0.855, green: 0.855, blue: 0.855, alpha: 1), for: MDCTextControlState.disabled)
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.14
        passwordRepeatTextField.label.text = "Confirme a senha"
        passwordRepeatTextField.isSecureTextEntry = true
        self.view.addSubview(passwordRepeatTextField)
    }
    
    func setSignUpButton()
    {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        signUpButton.frame = frame
        signUpButton.backgroundColor = .red
        signUpButton.layer.backgroundColor = UIColor(red: 0.894, green: 0, blue: 0.169, alpha: 1).cgColor
        signUpButton.layer.cornerRadius = 5
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.setTitle("Cadastrar", for: .normal)
        self.view.addSubview(signUpButton)
        let tap = UITapGestureRecognizer(target: self, action: #selector(signUpTap))
        signUpButton.addGestureRecognizer(tap)
    }
    
    //MARK: - Set Constraints view
    fileprivate func setConstraints()
    {
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        nameTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        emailTextField.topAnchor.constraint(equalTo: self.nameTextField.bottomAnchor, constant: 20).isActive = true
        
        dateOfBirth.translatesAutoresizingMaskIntoConstraints = false
        dateOfBirth.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        dateOfBirth.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        dateOfBirth.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: 20).isActive = true
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: self.dateOfBirth.bottomAnchor, constant: 20).isActive = true
        
        passwordRepeatTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordRepeatTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        passwordRepeatTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        passwordRepeatTextField.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 20).isActive = true
        
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signUpButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        signUpButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        signUpButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80).isActive = true
    }
    
    
}
