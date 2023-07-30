//
//  TweetComposeViewViewModel.swift
//  TwitterClon
//
//  Created by Николай Гринько on 30.07.2023.
//

import Foundation
import Combine
import FirebaseAuth

final class TweetComposeViewViewModel: ObservableObject {
 
    private var subscriptions: Set<AnyCancellable> = []
    
    @Published var isValidToTweet: Bool = true
    @Published var error: String = ""
    
    private var user: TwitterUser?
    
    func getUserData() {
        guard let userId = Auth.auth().currentUser?.uid else {return}
        DatabaseManager.shared.collectionUsers(retreive: userId)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] TwitterUser in
                self?.user = TwitterUser
            }
            .store(in: &subscriptions)
    }
    
    
}
