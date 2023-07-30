//
//  DatabaseManager.swift
//  TwitterClon
//
//  Created by Николай Гринько on 28.07.2023.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift
import Combine


class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    let db = Firestore.firestore()
    let userPath: String = "users"
    
    
    func collectionUser(add user: User) -> AnyPublisher<Bool, Error> {
        let twitterUser = TwitterUser(from: user)
        return db.collection(userPath).document(twitterUser.id).setData(from: twitterUser)
            .map { _ in return true }
            .eraseToAnyPublisher()
    }
    
    func collectionUsers(retreive id: String) -> AnyPublisher<TwitterUser, Error> {
        db.collection(userPath).document(id).getDocument()
            .tryMap { try $0.data(as: TwitterUser.self) }
            .eraseToAnyPublisher()
    }
    
    func collectionUsers(updateField: [String: Any], for id: String) -> AnyPublisher<Bool, Error> {
        db.collection(userPath).document(id).updateData(updateField)
            .map { _ in true }
                    .eraseToAnyPublisher()
            }
    }
    

