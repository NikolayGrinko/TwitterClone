//
//  Tweet.swift
//  TwitterClon
//
//  Created by Николай Гринько on 30.07.2023.
//

import Foundation

struct Tweet: Codable, Identifiable {
    var id = UUID().uuidString
    let author: TwitterUser
    let authorID: String
    let tweetContent: String
    var liceCount: Int
    var likers: [String]
    let isReply: Bool
    let parentReference: String?
    
}
