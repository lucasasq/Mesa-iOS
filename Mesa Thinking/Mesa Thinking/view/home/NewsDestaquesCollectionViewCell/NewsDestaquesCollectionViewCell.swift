import UIKit

protocol NewsDelegate
{
    func onClick(destaques : News)
}
class NewsDestaquesCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!    
    @IBOutlet weak var newsDescription: UILabel!
    var delegate : NewsDelegate?
    var withBackView : Bool! {
        didSet {
            self.backViewGenrator()
        }
    }
    private lazy var backView: UIImageView = {
        let backView = UIImageView(frame: newsImage.frame)
        backView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(backView)
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: newsImage.topAnchor, constant: -10),
            backView.leadingAnchor.constraint(equalTo: newsImage.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: newsImage.trailingAnchor),
            backView.bottomAnchor.constraint(equalTo: newsImage.bottomAnchor)
        ])
        backView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        backView.alpha = 0.5
        contentView.bringSubviewToFront(newsImage)
        return backView
    }()
    public var newsHighlights: News! {
        didSet {
            self.newsImage.loadImage(fromURL: newsHighlights.image_url)
            self.newsTitle.text = newsHighlights.title
            self.newsDescription.text = newsHighlights.description
            self.addTapGestureRecognizer{
                self.delegate?.onClick(destaques: self.newsHighlights)
            }
        }
    }
    private func backViewGenrator(){
        backView.loadImage(fromURL: newsHighlights.image_url)
    }
    override func prepareForReuse() {
        newsImage.image = UIImage()
        backView.image = UIImage()
    }
}
