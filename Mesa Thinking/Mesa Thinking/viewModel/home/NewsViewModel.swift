import Foundation
import FirebaseDatabase
import FirebaseCore
import CodableFirebase
import RxSwift
import RxCocoa

class NewsViewModel
{
    public let newsStatus : PublishSubject<News> = PublishSubject()
    public let verifyNews : PublishSubject<News> = PublishSubject()
    
    public func insertOrDeleteNewsFav(news: News)
    {
        let userDefaults = UserDefaults.standard
        var email = userDefaults.string(forKey: "email")!
        email = email.strip(unformatted: email)
        let databaseReference = Database.database().reference()
        var newsModel = news
        //news.title will be our ref id to firebase, because our response json haven't id to identificate specifique news
        let refParent = news.title.MD5(string: news.title).map { String(format: "%02hhx", $0) }.joined()
        
        //we will parse news to json
        let model = try! FirebaseEncoder().encode(news)
        
        DispatchQueue.global(qos: .default).async
        {
            databaseReference.child("\(String(describing: email))/\(refParent)").observeSingleEvent(of: .value, with: {
                snapshot in
                    if(snapshot.exists())
                    {
                        //we will delete
                        newsModel.key = refParent
                        newsModel.isFav = false
                        databaseReference.child("\(String(describing: email))/\(refParent)").setValue(nil)
                        self.newsStatus.onNext(newsModel)
                    }
                    else
                    {
                        //we will insert
                        newsModel.key = refParent
                        newsModel.isFav = true
                        databaseReference.child("\(String(describing: email))/\(refParent)").setValue(model)
                        self.newsStatus.onNext(newsModel)
                    }
            })
        }
    }
    
    public func verifyNews(news: News)
    {
        let userDefaults = UserDefaults.standard
        var email = userDefaults.string(forKey: "email")!
        email = email.strip(unformatted: email)
        let databaseReference = Database.database().reference()
        var newsModel = news
        //news.title will be our ref id to firebase, because our response json haven't id to identificate specifique news
        let refParent = news.title.MD5(string: news.title).map { String(format: "%02hhx", $0) }.joined()
        
        //we will parse news to json
        let model = try! FirebaseEncoder().encode(news)
        
        DispatchQueue.global(qos: .default).async
        {
            databaseReference.child("\(String(describing: email))/\(refParent)").observeSingleEvent(of: .value, with: {
                snapshot in
                    if(snapshot.exists())
                    {
                        //we will delete
                        newsModel.key = refParent
                        newsModel.isFav = true
                        self.verifyNews.onNext(newsModel)
                    }
                    
            })
        }
    }
    public func verifyNews(news: [News])
    {
        let userDefaults = UserDefaults.standard
        var email = userDefaults.string(forKey: "email")!
        email = email.strip(unformatted: email)
        let databaseReference = Database.database().reference()
        for item in news
        {
            var newsModel = item
            //news.title will be our ref id to firebase, because our response json haven't id to identificate specifique news
            let refParent = item.title.MD5(string: item.title).map { String(format: "%02hhx", $0) }.joined()
            
            //we will parse news to json
            let model = try! FirebaseEncoder().encode(news)
            
            DispatchQueue.global(qos: .default).async
            {
                databaseReference.child("\(String(describing: email))/\(refParent)").observeSingleEvent(of: .value, with: {
                    snapshot in
                        if(snapshot.exists())
                        {
                            newsModel.key = refParent
                            newsModel.isFav = true
                            self.verifyNews.onNext(newsModel)
                        }
                    else
                    {
                            newsModel.key = refParent
                            newsModel.isFav = false
                            self.verifyNews.onNext(newsModel)
                    }
                        
                })
            }
        }
        
    }
}
