//
//  Pagination.swift
//  Mesa Thinking
//
//  Created by Lucas De Assis on 28/12/20.
//

import Foundation
struct Pagination : Codable
{
    var current_page, per_page, total_pages, total_items : Int
    enum CodingKeys: String, CodingKey {
        case current_page, per_page, total_pages, total_items
//        case published_at = "published_at"
    }
}

extension Pagination {
    init?(data: Data) {
            let me = try! JSONDecoder().decode(Pagination.self, from: data)
            self = me
        
    }
    }
