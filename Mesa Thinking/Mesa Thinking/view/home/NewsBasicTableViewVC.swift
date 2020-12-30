import UIKit
import RxSwift
import RxCocoa


class NewsBasicTableViewVC: UIViewController, NewsDelegate
{
    
    @IBOutlet private weak var basicNewsTableView: UITableView!
    
    public var delegate : HomeDelegate?
    public var news = PublishSubject<[News]>()        
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Interface delegate
    func onClick(destaques: News)
    {
        //open web view screen
        let viewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailNewsVC") as! DetailNewsVC
        viewController.news = destaques
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: - View's Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupBinding()
    }
    
    
    //MARK: - Bindings
    private func setupBinding()
    {
        basicNewsTableView.register(UINib(nibName: "NewsBasicTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: NewsBasicTableViewCell.self))
        
        news.bind(to: basicNewsTableView.rx.items(cellIdentifier: "NewsBasicTableViewCell", cellType: NewsBasicTableViewCell.self)) {  (row,news,cell) in
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
        basicNewsTableView.rx.willDisplayCell
            .subscribe(onNext: ({ (cell,indexPath) in                
                self.delegate?.getMoreNews(indexPath: indexPath)
                cell.alpha = 1
                cell.layer.transform = CATransform3DIdentity
            })).disposed(by: disposeBag)
    }
}




