import UIKit
import RxSwift
import RxCocoa

class NewsBasicTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var newsImage : UIImageView!
    @IBOutlet weak var newsDescription : UILabel!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var favImage: UIImageView!
    
    private var disposeBag = DisposeBag()
    
    var delegate : NewsDelegate?
    var newsViewModel = NewsViewModel()
    public var cellNews : News! {
        didSet {
            self.setBinding()
            self.newsImage.clipsToBounds = true
            self.newsImage.layer.cornerRadius = 3
            self.newsImage.loadImage(fromURL: cellNews.image_url)
            self.newsTitle.text = cellNews.title
            self.newsDescription.text = cellNews.description
            self.favImage.isUserInteractionEnabled = true
            if let valueBool = cellNews.isFav
            {
                if(valueBool)
                {
                    //we will change image for true
                    self.favImage.image = UIImage(systemName: "heart.fill")
                }
                else
                {
                    //we will change image for false
                    self.favImage.image = UIImage(systemName: "heart")
                }
            }
            self.favImage.addTapGestureRecognizer
            {
                self.newsViewModel.insertOrDeleteNewsFav(news: self.cellNews)
            }
            self.addTapGestureRecognizer
            {
                self.delegate?.onClick(destaques: self.cellNews)
            }
        }
    }
    
    //MARK: - Binding to viewModel - at on click
    func setBinding()
    {
        newsViewModel
            .newsStatus.asObservable().subscribe(onNext: {
                value
                in
                if let valueBool = value.isFav
                {
                    if(valueBool)
                    {
                        //we will change image for true
                        self.favImage.image = UIImage(systemName: "heart.fill")
                    }
                    else
                    {
                        //we will change image for false
                        self.favImage.image = UIImage(systemName: "heart")
                    }
                }
            })
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }
    override func prepareForReuse() {
        
        disposeBag = DisposeBag()
    }
}
