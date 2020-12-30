import Foundation
import UIKit

class StartVC: UIViewController
{
    // MARK: - View's Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setViews()
        setContraints()
        verifyLogged()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    //MARK: - Tap Buttons
    
    @objc func loginButtonTap()
    {
        let viewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func cadastrarButtonTap()
    {
        let viewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: - VerifyLogged
    fileprivate func verifyLogged ()
    {
        var data = UserDefaults.standard
        //user already logged
        if let token = data.string(forKey: "token")
        {
            let viewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    // MARK: - SetViews
    fileprivate func setViews()
    {
        self.view.addSubview(logoView)
        self.view.addSubview(entrarButton)
        self.view.addSubview(cadastrarButton)
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
        entrarButton.backgroundColor = .white
        entrarButton.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        entrarButton.layer.cornerRadius = 5
        entrarButton.layer.borderWidth = 1
        entrarButton.layer.borderColor = UIColor(red: 0.894, green: 0, blue: 0.169, alpha: 1).cgColor
        entrarButton.setTitle("Entrar", for: .normal)
        entrarButton.setTitleColor(UIColor(red: 0.894, green: 0, blue: 0.169, alpha: 1), for: .normal)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(loginButtonTap))
        entrarButton.addGestureRecognizer(tap)
        
        return entrarButton
    }()
    
    lazy var cadastrarButton : UIButton =
    {
        let cadastrarButton = UIButton()
        cadastrarButton.backgroundColor = .red
        cadastrarButton.layer.backgroundColor = UIColor(red: 0.894, green: 0, blue: 0.169, alpha: 1).cgColor
        cadastrarButton.layer.cornerRadius = 5
        cadastrarButton.setTitle("Cadastrar", for: .normal)
        cadastrarButton.setTitleColor(.white, for: .normal)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(cadastrarButtonTap))
        cadastrarButton.addGestureRecognizer(tap)
        
        return cadastrarButton
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
                
        cadastrarButton.translatesAutoresizingMaskIntoConstraints = false
        cadastrarButton.topAnchor.constraint(equalTo: entrarButton.bottomAnchor, constant: 20).isActive = true
        cadastrarButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        cadastrarButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        cadastrarButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
