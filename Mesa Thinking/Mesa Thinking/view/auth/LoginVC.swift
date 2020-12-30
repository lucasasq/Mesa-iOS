import UIKit
import MaterialComponents.MaterialTextControls_FilledTextAreas
import MaterialComponents.MaterialTextControls_FilledTextFields
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields
import RxSwift
import RxCocoa
import FBSDKLoginKit

class LoginVC: UIViewController
{
    var authViewModel = AuthViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: - SetViews
    var emailField = MDCOutlinedTextField()
    var passwordTextField = MDCOutlinedTextField()
    
    fileprivate func setViews()
    {
        self.view.addSubview(logoView)
        self.view.addSubview(entrarButton)
        self.view.addSubview(facebookButton)
        setEmailField()
        setPasswordField()
        setConstraints()
    }
    
    fileprivate func setConstraints()
    {
        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        logoView.heightAnchor.constraint(equalToConstant: 105).isActive = true
        logoView.widthAnchor.constraint(equalToConstant: 145).isActive = true
        
        emailField.translatesAutoresizingMaskIntoConstraints = false
        emailField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        emailField.heightAnchor.constraint(equalToConstant: 50).isActive = true
                
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        entrarButton.translatesAutoresizingMaskIntoConstraints = false
        entrarButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 59).isActive = true
        entrarButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        entrarButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        entrarButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        facebookButton.translatesAutoresizingMaskIntoConstraints = false
        facebookButton.topAnchor.constraint(equalTo: entrarButton.bottomAnchor, constant: 10).isActive = true
        facebookButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        facebookButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        facebookButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    fileprivate func setEmailField()
    {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        emailField = MDCOutlinedTextField(frame: frame)
        
        emailField.setFloatingLabelColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.normal)
        emailField.setFloatingLabelColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.disabled)
        emailField.setFloatingLabelColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.editing)
        
        emailField.setNormalLabelColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.editing)
        emailField.setNormalLabelColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.normal)
        emailField.setNormalLabelColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.disabled)
        
        emailField.setTextColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.editing)
        emailField.setTextColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.disabled)
        emailField.setTextColor(UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1), for: MDCTextControlState.normal)
        //textField.leadingAssistiveLabel.text = "Digite o e-mail para realizar o login"
        
        emailField.backgroundColor = .white
        emailField.sizeToFit()
        
        emailField.setOutlineColor(UIColor(red: 0.855, green: 0.855, blue: 0.855, alpha: 1), for: MDCTextControlState.normal)
        emailField.setOutlineColor(UIColor(red: 0.855, green: 0.855, blue: 0.855, alpha: 1), for: MDCTextControlState.editing)
        emailField.setOutlineColor(UIColor(red: 0.855, green: 0.855, blue: 0.855, alpha: 1), for: MDCTextControlState.disabled)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.14
        emailField.label.text = "E-mail"
        self.view.addSubview(emailField)
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
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.14
        passwordTextField.label.text = "Senha"
        passwordTextField.isSecureTextEntry = true
        self.view.addSubview(passwordTextField)
    }
    
    lazy var logoView : UIImageView =
    {
        let logoView = UIImageView()
        logoView.image = UIImage(named:"screen_logo")
        logoView.contentMode = .scaleAspectFit
        logoView.clipsToBounds = true
        return logoView
    }()
    
    lazy var entrarButton : UIButton =
    {
        let entrarButton = UIButton()
        entrarButton.backgroundColor = .red
        entrarButton.layer.backgroundColor = UIColor(red: 0.894, green: 0, blue: 0.169, alpha: 1).cgColor
        entrarButton.layer.cornerRadius = 5
        entrarButton.setTitle("Entrar", for: .normal)
        entrarButton.setTitleColor(.white, for: .normal)
        let tap = UITapGestureRecognizer(target: self, action: #selector(loginButtonTap))
        entrarButton.addGestureRecognizer(tap)
        
        return entrarButton
    }()
    
    lazy var facebookButton : UIButton =
    {
        let entrarButton = UIButton()
        entrarButton.backgroundColor = .blue
        entrarButton.layer.backgroundColor = UIColor.blue.cgColor
        entrarButton.layer.cornerRadius = 5
        entrarButton.setTitle("Login com facebook", for: .normal)
        entrarButton.setTitleColor(.white, for: .normal)
        let tap = UITapGestureRecognizer(target: self, action: #selector(loginFacebookButtonTap))
        entrarButton.addGestureRecognizer(tap)
        
        return entrarButton
    }()
    
    fileprivate func setContraints()
    {
        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        logoView.heightAnchor.constraint(equalToConstant: 105).isActive = true
        logoView.widthAnchor.constraint(equalToConstant: 145).isActive = true
        
        entrarButton.translatesAutoresizingMaskIntoConstraints = false
        entrarButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        entrarButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        entrarButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        entrarButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    // MARK: - View's Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setViews()
        setBinding()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
        
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Login" // colocou nome no título da viewcontrolller
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
            if emailField.isFirstResponder
            {
                let tabBarHeight = 120
                self.view.frame.origin.y = -120
            }
            if passwordTextField.isFirstResponder {
                let tabBarHeight = 120
                self.view.frame.origin.y = -170
            }
        }
    }
    
    //MARK: - Tap Buttons
    
    @objc func loginButtonTap()
    {
        authViewModel.makeLogin(emailField.text!, andPassword: passwordTextField.text!)
    }
    
    @objc func loginFacebookButtonTap()
    {
        authViewModel.signInWithFacebook(viewController: self)
    }
    
    @objc func cadastrarButtonTap()
    {
        let viewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: - Bindings and observable
    func setBinding()
    {
        authViewModel.loading
            .bind(to: self.rx.isAnimating)
            .disposed(by: disposeBag)
        
        authViewModel.logged
            .asObservable()
            .subscribe(onNext:
            {
                value in
                //if value is true, we will send user to home screen
                if(value)
                {
                    self.showNextPage()
                }
           }).disposed(by: disposeBag)
    }
        
    func showNextPage()
    {
        let viewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

