import Foundation
import UIKit
import WebKit

class DetailNewsVC : UIViewController, WKNavigationDelegate
{
    var webView: WKWebView!
    var news : News!
    var newsViewModel = NewsViewModel()
    //MARK: - View's cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setViews()
        setBindings()
    }
    //MARK: - Methods
    fileprivate func favAction()
    {
        //what we gonna do now? :D
        //where we will save?
        //okay, we will use firebase to save our data
        newsViewModel.insertOrDeleteNewsFav(news: news)
    }
    
    fileprivate func shareActions()
    {
        let vc = UIActivityViewController(activityItems: [self.news.url], applicationActivities: [])
        self.present(vc, animated: true, completion: nil)
    }
    
    fileprivate func setLikeViewDeactivate()
    {
        self.likeImage.image = UIImage(systemName: "heart")
        self.likeImage.setImageColor(color: UIColor.red)
        self.likeView.backgroundColor = .white
        self.likeText.textColor = UIColor.red
        self.likeView.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        self.likeView.layer.cornerRadius = 5
        self.likeView.layer.borderWidth = 1
        self.likeView.layer.borderColor = UIColor(red: 0.894, green: 0, blue: 0.169, alpha: 1).cgColor
    }
    fileprivate func setLikeViewActivated()
    {
        self.likeImage.image = UIImage(systemName: "heart.fill")
        self.likeImage.setImageColor(color: UIColor.white)
        self.likeText.textColor = UIColor.white
        self.likeView.layer.backgroundColor = UIColor(red: 0.894, green: 0, blue: 0.169, alpha: 1).cgColor
        self.likeView.layer.cornerRadius = 5
        self.likeView.layer.borderWidth = 1
        self.likeView.layer.borderColor = UIColor(red: 0.894, green: 0, blue: 0.169, alpha: 1).cgColor
    }
    
    //MARK: - Set bindings
    fileprivate func setBindings()
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
                        self.setLikeViewActivated()                        
                    }
                    else
                    {
                        //we will change image for false
                        self.setLikeViewDeactivate()
                    }
                }                
            })
    }
    
    
    //MARK: - Set Views
    fileprivate func setViews()
    {
        webView = WKWebView()
        webView.navigationDelegate = self
        let url = URL(string: news.url)!
        webView.load(URLRequest(url: url))
        view.addSubview(webView)
        likeView.addSubview(likeImage)
        likeView.addSubview(likeText)
        favBar.addSubview(likeView)
        shareView.addSubview(shareImage)
        shareView.addSubview(shareText)
        favBar.addSubview(shareView)
        view.addSubview(favBar)
        setConstraints()
    }
    
    fileprivate func setConstraints()
    {
        favBar.translatesAutoresizingMaskIntoConstraints = false
        favBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -76).isActive = true
        favBar.heightAnchor.constraint(equalToConstant: 56).isActive = true
        favBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4).isActive = true
        favBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4).isActive = true
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: favBar.topAnchor).isActive = true
        
        likeView.translatesAutoresizingMaskIntoConstraints = false
        likeView.leadingAnchor.constraint(equalTo: favBar.leadingAnchor).isActive = true
        likeView.topAnchor.constraint(equalTo: favBar.topAnchor).isActive = true
        likeView.heightAnchor.constraint(equalToConstant: 56).isActive = true
        likeView.widthAnchor.constraint(equalToConstant: favBar.bounds.width/2).isActive = true
        likeView.addTapGestureRecognizer
        {
            self.favAction()
        }
        
        likeImage.translatesAutoresizingMaskIntoConstraints = false
        likeImage.leadingAnchor.constraint(equalTo: likeView.leadingAnchor, constant: 40).isActive = true
        likeImage.centerYAnchor.constraint(equalTo: likeView.centerYAnchor).isActive = true
        likeImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        likeImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        likeText.translatesAutoresizingMaskIntoConstraints = false
        likeText.centerYAnchor.constraint(equalTo: likeView.centerYAnchor).isActive = true
        likeText.leadingAnchor.constraint(equalTo: likeImage.trailingAnchor, constant: 5).isActive = true
        
        shareView.translatesAutoresizingMaskIntoConstraints = false
        shareView.leadingAnchor.constraint(equalTo: likeView.trailingAnchor, constant: 2).isActive = true
        shareView.topAnchor.constraint(equalTo: favBar.topAnchor).isActive = true
        shareView.heightAnchor.constraint(equalToConstant: 56).isActive = true
        shareView.widthAnchor.constraint(equalToConstant: favBar.bounds.width/2).isActive = true
        shareView.addTapGestureRecognizer
        {
            self.shareActions()
        }
                
        shareImage.translatesAutoresizingMaskIntoConstraints = false
        shareImage.leadingAnchor.constraint(equalTo: shareView.leadingAnchor, constant: 40).isActive = true
        shareImage.centerYAnchor.constraint(equalTo: shareView.centerYAnchor).isActive = true
        shareImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        shareImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        shareText.translatesAutoresizingMaskIntoConstraints = false
        shareText.centerYAnchor.constraint(equalTo: shareView.centerYAnchor).isActive = true
        shareText.leadingAnchor.constraint(equalTo: shareImage.trailingAnchor, constant: 5).isActive = true
    }
    
    private lazy var favBar : UIView =
    {
        var view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 10, height: 56)
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        var stroke = UIView()
        stroke.bounds = view.bounds.insetBy(dx: -1, dy: -1)
        stroke.center = view.center
        view.addSubview(stroke)
        stroke.layer.cornerRadius = 6
        view.bounds = view.bounds.insetBy(dx: -1, dy: -1)
        stroke.layer.borderWidth = 1
        stroke.layer.borderColor = UIColor(red: 0.867, green: 0.867, blue: 0.867, alpha: 1).cgColor
        return view
    }()
    
    private lazy var likeView : UIView =
    {
        var view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 164, height: 56)
        view.backgroundColor = .white
        view.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0.894, green: 0, blue: 0.169, alpha: 1).cgColor
        return view
    }()
    
    private lazy var likeImage : UIImageView =
    {
        let likeImage = UIImageView()
        likeImage.image = UIImage(systemName: "heart")
        likeImage.setImageColor(color: UIColor.red)
        likeImage.contentMode = .scaleAspectFit
        likeImage.clipsToBounds = true
        return likeImage
    }()
    
    private lazy var likeText : UILabel =
    {
        var view = UILabel()
        view.frame = CGRect(x: 0, y: 0, width: 50, height: 20)
        view.textColor = UIColor(red: 0.894, green: 0, blue: 0.169, alpha: 1)
        view.text = "Favoritar"
        return view
    }()
    
    private lazy var shareView : UIView =
    {
        var view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 164, height: 56)
        view.backgroundColor = .white
        view.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0.894, green: 0, blue: 0.169, alpha: 1).cgColor
        return view
    }()
    
    private lazy var shareImage : UIImageView =
    {
        let shareImage = UIImageView()
        shareImage.image = UIImage(systemName: "square.and.arrow.up")
        shareImage.setImageColor(color: UIColor.red)
        shareImage.contentMode = .scaleAspectFit
        shareImage.clipsToBounds = true
        return shareImage
    }()
    
    private lazy var shareText : UILabel =
    {
        var view = UILabel()
        view.frame = CGRect(x: 0, y: 0, width: 60, height: 20)
        view.textColor = UIColor(red: 0.894, green: 0, blue: 0.169, alpha: 1)
        view.text = "Compartilhar"
        return view
    }()
    
}
