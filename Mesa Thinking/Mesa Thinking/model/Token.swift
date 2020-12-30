//
//  Token.swift
//  Mesa Thinking
//
//  Created by Lucas De Assis on 28/12/20.
//

import Foundation

// MARK: - Token
struct Token: Codable
{
    let token: String
    
}

extension Token {
    init?(data: Data)
    {
        var me = try! JSONDecoder().decode(Token.self, from: data)
        self = me        
    }
}
