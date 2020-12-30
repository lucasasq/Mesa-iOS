import UIKit
import RxSwift
import RxCocoa

class FilterVC: UIViewController, NewsDelegate, HomeDelegate
{
    //MARK: - Interface methods
    func getMoreNews(indexPath: IndexPath)
    {
        let delta = homeViewModel.basicNews.count - indexPath.row
        if(homeViewModel.basicNews.count >= 10)
        {
            if(delta < 3)
            {
                //we will make a new request
                homeViewModel.requestDataWithIndex()
            }
        }
        
    }
    
    func onClick(destaques: News)
    {
        let viewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailNewsVC") as! DetailNewsVC
        viewController.news = destaques
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    var homeViewModel = HomeViewModel()
    var newsViewModel = NewsViewModel()
    var tableView = UITableView()
    public var delegate : HomeDelegate?
    public var news = PublishSubject<[News]>()
    public var itemsToDelete = PublishSubject<[News]>()
    var indexPath = [IndexPath]()
    private let disposeBag = DisposeBag()
    
    //MARK: - View's cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setViews()
        setBindings()
        getData()
    }
    
    //MARK: - Methods
    
    fileprivate func getData()
    {
        homeViewModel.requestAllData()
    }
    
    @objc func favSwitchOnClick(mySwitch: UISwitch)
    {
        if(switchFav.isOn)
        {
            self.news = PublishSubject<[News]>()
            self.news.onNext([News]())
            self.homeViewModel.news = PublishSubject<[News]>()
        }
        else
        {
            
        }
    }

//    @objc func dateSwitchOnClick(mySwitch: UISwitch)
//    {
//        if(switchFav.isOn)
//        {
//            //here we need delete all daa and get only favorite news
////            self.news.onNext([News])
////            self.homeViewModel.news = PublishSubject<[News]>()
//        }
//        else
//        {
//
//        }
//    }
    
    //MARK: - Binding
    fileprivate func setBindings()
    {
        homeViewModel
            .news
            .observeOn(MainScheduler.instance)
            .bind(to: self.news)
            .disposed(by: disposeBag)
        
            tableView.register(UINib(nibName: "NewsBasicTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: NewsBasicTableViewCell.self))
            
            news.bind(to: tableView.rx.items(cellIdentifier: "NewsBasicTableViewCell", cellType: NewsBasicTableViewCell.self)) {  (row,news,cell) in
                cell.cellNews = news
                cell.delegate = self
                if let valueBool = news.isFav
                {
                    if(valueBool)
                    {
                        cell.favImage.image = UIImage(systemName: "heart.fill")
                    }
                    else
                    {
                        cell.favImage.image = UIImage(systemName: "heart")
                    }
                }
                }.disposed(by: disposeBag)
            
            //was a bad idea use tableview, but now it's later to change
            tableView.rx.willDisplayCell
                .subscribe(onNext: ({ (cell,indexPath) in
                    self.getMoreNews(indexPath: indexPath)
                    cell.alpha = 1
                    cell.layer.transform = CATransform3DIdentity
                    self.indexPath.append(indexPath)
                })).disposed(by: disposeBag)
        
        tableView.rx.itemDeleted
            .subscribe(onNext: { value in
                print(value)
            })
            .disposed(by: disposeBag)
        
        
    }
    
    //MARK: - Set views
    fileprivate func setViews()
    {
        view.addSubview(switchFav)
        view.addSubview(favLabel)
        view.addSubview(switchDate)
        view.addSubview(dateLabel)
        view.addSubview(tableView)
        
        tableView.backgroundColor = .black
        switchFav.translatesAutoresizingMaskIntoConstraints = false
        switchFav.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        switchFav.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20).isActive = true
        switchFav.heightAnchor.constraint(equalToConstant: 50).isActive = true
        switchFav.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        favLabel.translatesAutoresizingMaskIntoConstraints = false
        favLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        favLabel.leadingAnchor.constraint(equalTo: switchFav.trailingAnchor,constant: 10).isActive = true
        favLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -5).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        switchDate.translatesAutoresizingMaskIntoConstraints = false
        switchDate.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        switchDate.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor,constant: -5).isActive = true
        switchDate.heightAnchor.constraint(equalToConstant: 50).isActive = true
        switchDate.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    fileprivate lazy var switchFav : UISwitch =
    {
        var switchFav = UISwitch()
        switchFav.addTarget(self, action: #selector(favSwitchOnClick(mySwitch:)), for: UIControl.Event.valueChanged)

        return switchFav
    }()
    
    fileprivate lazy var switchDate : UISwitch =
    {
        var switchDate = UISwitch()
//        switchDate.addTarget(self, action: #selector(dateSwitchOnClick(mySwitch:)), for: UIControl.Event.valueChanged)
        return switchDate
    }()
    
    fileprivate lazy var favLabel : UILabel =
    {
        var favLabel = UILabel()
        favLabel.text = "Favoritos"
        favLabel.textColor = .white
        
        return favLabel
    }()
    
    fileprivate lazy var dateLabel : UILabel =
    {
        var favLabel = UILabel()
        favLabel.text = "Data"
        favLabel.textColor = .white
        return favLabel
    }()
    
}
