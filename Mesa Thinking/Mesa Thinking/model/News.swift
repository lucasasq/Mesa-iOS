import Foundation
import FirebaseCore
import FirebaseDatabase
import CodableFirebase
struct News: Codable {
    
    var title, description, content, author, url, image_url, published_at: String
    var highlight : Bool
    var published : Date?
    var isFav : Bool?
    var key : String?
    
    enum CodingKeys: String, CodingKey
    {
        case title, description, content, author, url, image_url
        case highlight = "highlight"
        case published_at = "published_at"
    }        
}


// MARK: Convenience initializers

extension News {
    init?(data: Data) {
        do
        {
            var me = try JSONDecoder().decode(News.self, from: data)
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SZZZZZ"
            me.published = dateFormatter.date(from: me.published_at)!
            self = me
        }catch let error
        {
            //pt-br necessário, devido à alguns JSON's estarem vindo com nós pendentes.
            let me = try! JSONDecoder().decode(NewsOptional.self, from: data)
            var news = News.init(title: me.title!, description: me.description!, content: me.content!, author: me.author!, url: me.url!, image_url: me.image_url ?? "", published_at: me.published_at ?? "", highlight: me.highlight!)
            self = news
        }
        
    }
}
