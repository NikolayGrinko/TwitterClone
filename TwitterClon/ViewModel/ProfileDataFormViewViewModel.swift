//
//  ProfileDataFormViewViewModel.swift
//  TwitterClon
//
//  Created by Николай Гринько on 29.07.2023.
//

import Foundation
import UIKit
import Combine
import Firebase
import FirebaseStorage

final class ProfileDataFormViewViewModel: ObservableObject {
    
    private var subscriptions: Set<AnyCancellable> = []
    
    @Published var displayName: String?
    @Published var username: String?
    @Published var bio: String?
    @Published var avatarPath: String?
    @Published var imageData: UIImage?
    @Published var isFormValid: Bool = false
    @Published var error: String = ""
    @Published var isOnBoardingFinished: Bool = false
    
    func validateUserProfileForm() {
        guard let displayName = displayName,
              displayName.count > 2,
              let username = username,
              username.count > 2,
              let bio = bio,
              bio.count > 2,
              imageData != nil else {
            isFormValid = false
            return
        }
        isFormValid = true
    }
    
    //MARK: func download photo telephone
    func uploadAvatar() {
        
        let randomID = UUID().uuidString
        
        guard let imageData = imageData?.jpegData(compressionQuality: 0.5) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        StorageManager.shared.uploadProfilePhoto(with: randomID, image: imageData, metaData: metaData)
            .flatMap({ metaData in
                StorageManager.shared.getDownload(for: metaData.path)
            })
            .sink { [weak self] completion in
                
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.error = error.localizedDescription
                case .finished:
                    self?.updateUserData()
                }
                
            } receiveValue: { [weak self] url in
                self?.avatarPath = url.absoluteString
            }
            .store(in: &subscriptions)
    }
    
    
    
    
    private func updateUserData() {
        
        guard let displayName,
              let username,
              let bio,
              let avatarPath,
        let id = Auth.auth().currentUser?.uid else {return}
        
        let updatedFields: [String: Any] = [
            "displayName": displayName,
            "username": username,
            "bio": bio,
            "avatarPath": avatarPath,
            "isUserOnboarded": true
        ]
        DatabaseManager.shared.collectionUsers(updateField: updatedFields, for: id)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] onboarding in
                self?.isOnBoardingFinished = onboarding
            }
            .store(in: &subscriptions)
    }
}

