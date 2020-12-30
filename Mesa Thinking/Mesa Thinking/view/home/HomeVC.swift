import UIKit
import RxSwift
import RxCocoa

protocol HomeDelegate
{
    func getMoreNews(indexPath : IndexPath)
}

class HomeVC: UIViewController, HomeDelegate
{
    //MARK: - Interface Delegate
    func getMoreNews(indexPath: IndexPath)
    {
        let delta = homeViewModel.basicNews.count - indexPath.row
        if(delta < 3)
        {
            //we will make a new request
            homeViewModel.requestDataWithIndex()
        }
    }
    
    
    // MARK: - SubViews
    @IBOutlet weak var newsBasic: UIView!
    @IBOutlet weak var logout: UINavigationItem!
    @IBOutlet weak var newsHighlights: UIView!
    @IBOutlet weak var filtrarBt: UIButton!
    
    private lazy var newsHighlightsVC: NewsDestaquesCollectionViewVC =
    {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "NewsDestaquesCollectionViewVC") as! NewsDestaquesCollectionViewVC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController, to: newsHighlights)
        
        return viewController
    }()
    
    
    private lazy var newsViewControllerVC: NewsBasicTableViewVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "NewsBasicTableViewVC") as! NewsBasicTableViewVC
        viewController.delegate = self
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController, to: newsBasic)
        
        return viewController
    }()
    
    var homeViewModel = HomeViewModel()
    
    let disposeBag = DisposeBag()
    
    // MARK: - View's Cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupBindings()
        homeViewModel.requestData()
        let timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(getNewData), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Notícias" // colocou nome no título da viewcontrolller
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(backToInitial(sender:)))
    }
    
    // MARK: - Methods
    @objc func getNewData()
    {
        homeViewModel.requestDataAfterTime()
    }

    @objc func backToInitial(sender: AnyObject) {
         logoutOnClick()
    }
    
    @IBAction func filtrarOnClick(_ sender: Any)
    {
        let viewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func logoutOnClick()
    {
        let dialogMessage = UIAlertController(title: "Sair", message: "Você deseja realizar o logout?", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "SIM", style: .destructive, handler:
        { (action) -> Void in
            UserDefaults.standard.set(nil, forKey: "token")
            UserDefaults.standard.set(nil, forKey: "email")
            exit(0)
        })
        
        let cancel = UIAlertAction(title: "NÃO", style: .cancel) { (action) -> Void in
            
        }
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    // MARK: - Bindings
    
    private func setupBindings()
    {
        // binding carregando screen to vc
        
        homeViewModel.loading
            .bind(to: self.rx.isAnimating).disposed(by: disposeBag)
        
        
        //  observer errors
        
        homeViewModel
            .error
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (error) in
                switch error {
                case .internetError(let message):
                    MessageView.sharedInstance.showOnView(message: message, theme: .error)
                case .serverMessage(let message):
                    MessageView.sharedInstance.showOnView(message: message, theme: .warning)
                case.allNews(let message):
                    MessageView.sharedInstance.showOnView(message: message, theme: .success)
                }
            })
            .disposed(by: disposeBag)
        
        
        // binding highlights
        
        homeViewModel
            .newsHighlights
            .observeOn(MainScheduler.instance)
            .bind(to: newsHighlightsVC.news)
            .disposed(by: disposeBag)
        
        // binding newsBasic
        
        homeViewModel
            .news
            .observeOn(MainScheduler.instance)
            .bind(to: newsViewControllerVC.news)
            .disposed(by: disposeBag)
       
    }
}

