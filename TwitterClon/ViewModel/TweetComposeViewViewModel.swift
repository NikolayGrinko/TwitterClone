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
    
    
    // ETUUU
    @Published var isValidToTweet: Bool = false
    @Published var error: String = ""
    @Published var shouldDismissComposer: Bool = false
    var tweetContent: String = ""
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
    
    func validateToTweet() {
        isValidToTweet = !tweetContent.isEmpty
    }
    
    func dispatchTweet() {
        guard let user = user else {return}
        let tweet = Tweet(author: user, authorID: user.id, tweetContent: tweetContent, liceCount: 0, likers: [], isReply: false, parentReference: nil)
        DatabaseManager.shared.collectionTweets(dispatch: tweet)
            .sink {[weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] state in
                self?.shouldDismissComposer = state
            }
            .store(in: &subscriptions)
    }
    
}
