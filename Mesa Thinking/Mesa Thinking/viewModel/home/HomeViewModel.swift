import Foundation
import RxSwift
import RxCocoa
import Alamofire
import SwiftyJSON

class HomeViewModel
{    
    public enum HomeError
    {
        case internetError(String)
        case serverMessage(String)
        case allNews(String)
    }
    
    public let newsHighlights : PublishSubject<[News]> = PublishSubject()
    public var news : PublishSubject<[News]> = PublishSubject()
    public let loading: PublishSubject<Bool> = PublishSubject()
    public let error : PublishSubject<HomeError> = PublishSubject()
    
    private let disposable = DisposeBag()
    
    public var basicNews = [News]()
    public var totalNews = [News]()
    public var pagination : Pagination?
    
    var newsViewModel = NewsViewModel()
    
    public func requestData()
    {
        setBinding()
        //this method was called only 1 time
        //activate loading of screen
        self.loading.onNext(true)
        APIManager.requestData(url: "v1/client/news?current_page=&per_page=&published_at=", method: .get, parameters: nil, completion: { (result) in
            //deactivate loading of screen
            self.loading.onNext(false)
            switch result {
            case .success(let returnJson) :
                
                //parse to json
                var newsHighlights = returnJson["data"].arrayValue.compactMap {return News(data: try! $0.rawData())}
                self.basicNews = returnJson["data"].arrayValue.compactMap {return News(data: try! $0.rawData())}
                self.pagination = try! Pagination(data: returnJson["pagination"].rawData())
                
                //set news objects to respective views
                newsHighlights.removeAll{ $0.highlight == false}
                self.basicNews.removeAll{$0.highlight == true}
                
                //order by date
                newsHighlights = newsHighlights.sorted(by: { $0.published! > $1.published! })
                self.basicNews = self.basicNews.sorted(by: { $0.published! > $1.published! })
                //we will verify if this news is favorite or not
                self.newsViewModel.verifyNews(news: self.basicNews)
                self.basicNews.removeAll()
                self.newsHighlights.onNext(newsHighlights)
                                
                if(self.totalNews.count == 0)
                {
                    self.totalNews += newsHighlights
                    self.totalNews += self.basicNews
                }
            case .failure(let failure) :
                switch failure {
                case .connectionError:
                    self.error.onNext(.internetError("Verifique a sua conexão de internet"))
                case .authorizationError(let errorJson):
                    self.error.onNext(.serverMessage(errorJson["message"].stringValue))
                default:
                    self.error.onNext(.serverMessage("Erro desconhecido"))
                }
            }
        })
        
    }
    
    public func requestAllData()
    {
        setBinding()
        //this method was called only 1 time
        //activate loading of screen
        self.loading.onNext(true)
        APIManager.requestData(url: "v1/client/news?current_page=&per_page=&published_at=", method: .get, parameters: nil, completion: { (result) in
            //deactivate loading of screen
            self.loading.onNext(false)
            switch result {
            case .success(let returnJson) :
                
                self.basicNews = returnJson["data"].arrayValue.compactMap {return News(data: try! $0.rawData())}
                self.pagination = try! Pagination(data: returnJson["pagination"].rawData())
                //order by date
                
                self.basicNews = self.basicNews.sorted(by: { $0.published! > $1.published! })
                //we will verify if this news is favorite or not
                self.newsViewModel.verifyNews(news: self.basicNews)
                self.basicNews.removeAll()
                                
                if(self.totalNews.count == 0)
                {
                    self.totalNews += self.basicNews
                }
            case .failure(let failure) :
                switch failure {
                case .connectionError:
                    self.error.onNext(.internetError("Verifique a sua conexão de internet"))
                case .authorizationError(let errorJson):
                    self.error.onNext(.serverMessage(errorJson["message"].stringValue))
                default:
                    self.error.onNext(.serverMessage("Erro desconhecido"))
                }
            }
        })
        
    }
    
    public func setBinding()
    {
        newsViewModel
            .verifyNews
            .asObserver()
            .subscribe(onNext:
                        {
                            value in
                            self.basicNews.append(value)
                            self.news.onNext(self.basicNews)
                        })
            .disposed(by: disposable)
    }
    
    public func requestDataAfterTime()
    {
        //we will get a new data after 30 seconds
        getNewDataAfterTime()
    }
    
    public func requestDataWithIndex()
    {
        //we will not activate the loading view in this method
        
        //totalNews is increased 20..40..60..80. if we want more news, just divide for 20 and increase 1
        //example: if we have 40 news, we will divide 40/20 = 2. After, 2 + 1 = 3, we will get third page and show for our user
        let newPage = self.totalNews.count / 20 + 1
        if let pagination = self.pagination
        {
            //we only make a new request if newPage is lower than pagination.total_pages
            if(newPage < pagination.total_pages)
            {
                getNewData(newPage: newPage)
            }
            else
            {
                //i think its good idea show a message for our user :)
//                self.error.onNext(.allNews("Todas as notícias já foram carregadas")) - not work properly
            }
        }
    }
    
    private func getNewData(newPage : Int)
    {
        //hardcode
        let token = "eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZW1haWwiOiJqb2huQGRvZS5jb20ifQ.08rKeRUP3TiiEUbeIGZGDZRvVmxISOprpEWkWDCpbOo"        
        //set header
        let header : HTTPHeaders =  ["Content-Type": "application/x-www-form-urlencoded",
                                     "Authorization" : "Bearer \(token)"]
        let urlApi = "\(APIManager.baseUrl)v1/client/news?current_page=\(newPage)&per_page=&published_at="
        
        AF.request(urlApi, headers: header).responseJSON{
            response in
            switch response.result
            {
                case .success(let responseNews):
                    let responseNS = responseNews as! NSDictionary
                    let news = JSON(responseNS)
                    let feedNews = news["data"].arrayValue.compactMap {return News(data: try! $0.rawData())}
                    self.basicNews += feedNews
                    self.totalNews += feedNews
                    self.news.onNext(self.basicNews)
                    
                case .failure(let error):
                    self.error.onNext(.serverMessage(error.localizedDescription))
            }
        }
    }
    
    private func getNewDataAfterTime()
    {
        //show loading
        self.loading.onNext(true)
        
        //hardcode
        let token = "eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZW1haWwiOiJqb2huQGRvZS5jb20ifQ.08rKeRUP3TiiEUbeIGZGDZRvVmxISOprpEWkWDCpbOo"
        
        //hardcode
        let header : HTTPHeaders =  ["Content-Type": "application/x-www-form-urlencoded",
                                     "Authorization" : "Bearer \(token)"]
        
        let urlApi = "\(APIManager.baseUrl)v1/client/news?current_page=&per_page=&published_at="
        
        //request using alamofire
        AF.request(urlApi, headers: header).responseJSON{
            response in
            switch response.result
            {
                case .success(let responseNews):
                    //deactivate loading
                    self.loading.onNext(false)
                    //convert to json
                    let feedNews = JSON(responseNews as! NSDictionary)["data"].arrayValue.compactMap{return News(data: try! $0.rawData())}

                    //here we will get only new news, based in the title
                    for item in feedNews
                    {
                        var contains = false
                        for itemNews in self.basicNews
                        {
                            if(item.title == itemNews.title)
                            {
                                contains = true
                                break
                            }
                        }
                        for itemNews in self.totalNews
                        {
                            if(item.title == itemNews.title)
                            {
                                contains = true
                                break
                            }
                        }
                        //we will get only new data with different title
                        if(!contains)
                        {
                            self.basicNews.append(item)
                            self.totalNews.append(item)
                        }
                    }
                    //order by date
                    self.basicNews = self.basicNews.sorted(by: { $0.published ?? Date() > $1.published ?? Date() })
                    
                    //ok, let's notify our view :)
                    self.news.onNext(self.basicNews)
                    
                case .failure(let error):
                    self.loading.onNext(false)
                    self.error.onNext(.serverMessage(error.localizedDescription))
            }
            
        }
    }
}
