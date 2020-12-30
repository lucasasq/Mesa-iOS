import UIKit
import RxSwift
import RxCocoa

class NewsDestaquesCollectionViewVC: UIViewController, NewsDelegate
{
                
    @IBOutlet private weak var newsCollectionView: UICollectionView!
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        newsCollectionView.backgroundColor = .clear
    }
    
    
    //MARK: - Bindings
    private func setupBinding()
    {
        newsCollectionView.register(UINib(nibName: "NewsDestaquesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: String(describing: NewsDestaquesCollectionViewCell.self))
                
        news.bind(to: newsCollectionView.rx.items(cellIdentifier: "NewsDestaquesCollectionViewCell", cellType: NewsDestaquesCollectionViewCell.self)) {  (row, news,cell) in
            cell.newsHighlights = news
            cell.withBackView = true
            cell.delegate = self
            }.disposed(by: disposeBag)
        
        newsCollectionView.rx.willDisplayCell
            .subscribe(onNext: ({ (cell,indexPath) in
                cell.alpha = 1
                cell.layer.transform = CATransform3DIdentity
            })).disposed(by: disposeBag)
    }
    
}
