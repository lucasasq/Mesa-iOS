
import Foundation

struct NewsOptional: Codable {
    
    var title, description, content, author, url, image_url, published_at: String?
    var highlight : Bool?
    
//    var published_at : Date
    
}
