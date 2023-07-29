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
    
    @Published var displayName: String?
    @Published var username: String?
    @Published var bio: String?
    @Published var avatarPath: String?
    @Published var imageData: UIImage?
    
}
