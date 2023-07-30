//
//  Tweet.swift
//  TwitterClon
//
//  Created by Николай Гринько on 30.07.2023.
//

import Foundation

struct Tweet: Codable {
    let id: String
    let author: TwitterUser
    let tweetContent: String
    var liceCount: Int
    var likers: [String]
    let isReply: Bool
    let parentReference: String?
    
}
