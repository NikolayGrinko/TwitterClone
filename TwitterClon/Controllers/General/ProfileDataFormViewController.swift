//
//  ProfileDataFormViewController.swift
//  TwitterClon
//
//  Created by Николай Гринько on 29.07.2023.
//

import UIKit

class ProfileDataFormViewController: UIViewController {

    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .onDrag
        return scrollView
    }()
    // MARK: Add text field
    private let displayNameTextLabel: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .default
        textField.backgroundColor = .secondarySystemFill
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 8
        textField.attributedPlaceholder = NSAttributedString(string: "Display name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        return textField
    }()
    
    private let userNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .default
        textField.backgroundColor = .secondarySystemFill
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 8
        textField.attributedPlaceholder = NSAttributedString(string: "User name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        return textField
    }()
    
    private let hintLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Fill in you data"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .label
        return label
    }()
    // MARK: add download photo profile
    private let avatarPlaceholderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 60
        imageView.backgroundColor = .lightGray
        imageView.image = UIImage(systemName: "camera.fill")
        imageView.tintColor = .gray
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let bioTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .secondarySystemFill
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 8
        textView.textContainerInset = .init(top: 15, left: 15, bottom: 15, right: 15)
        textView.text = "Tell the world about yourself"
        textView.font = .systemFont(ofSize: 16)
        textView.textColor = .gray
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(hintLabel)
        scrollView.addSubview(avatarPlaceholderImageView)
        scrollView.addSubview(displayNameTextLabel)
        scrollView.addSubview(userNameTextField)
        scrollView.addSubview(bioTextView)
        bioTextView.delegate = self
        isModalInPresentation = true
        
        configureConstraints()
    }

    private func  configureConstraints() {
        
    let scrollViewConstraints = [
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        scrollView.topAnchor.constraint(equalTo: view.topAnchor),
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ]
        
        let hintLabelConstraints = [
            hintLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            hintLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30)
        ]
        
        let avatarPlaceholderImageViewConstraints = [
            avatarPlaceholderImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            avatarPlaceholderImageView.heightAnchor.constraint(equalToConstant: 120),
            avatarPlaceholderImageView.widthAnchor.constraint(equalToConstant: 120),
            avatarPlaceholderImageView.topAnchor.constraint(equalTo: hintLabel.bottomAnchor, constant: 30)
        ]
        
        let displayNameTextLabelConstraint = [
            displayNameTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            displayNameTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            displayNameTextLabel.topAnchor.constraint(equalTo: avatarPlaceholderImageView.bottomAnchor, constant: 40),
            displayNameTextLabel.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let userNameTextFieldConstraints = [
            userNameTextField.leadingAnchor.constraint(equalTo: displayNameTextLabel.leadingAnchor),
            userNameTextField.trailingAnchor.constraint(equalTo: displayNameTextLabel.trailingAnchor),
            userNameTextField.topAnchor.constraint(equalTo: displayNameTextLabel.bottomAnchor, constant: 20),
            userNameTextField.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let bioTextViewConstraints = [
            bioTextView.leadingAnchor.constraint(equalTo: displayNameTextLabel.leadingAnchor),
            bioTextView.trailingAnchor.constraint(equalTo: displayNameTextLabel.trailingAnchor),
            bioTextView.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 20),
            bioTextView.heightAnchor.constraint(equalToConstant: 150)
        ]
        
        NSLayoutConstraint.activate(scrollViewConstraints)
        NSLayoutConstraint.activate(hintLabelConstraints)
        NSLayoutConstraint.activate(avatarPlaceholderImageViewConstraints)
        NSLayoutConstraint.activate(displayNameTextLabelConstraint)
        NSLayoutConstraint.activate(userNameTextFieldConstraints)
        NSLayoutConstraint.activate(bioTextViewConstraints)
    }
    
}

extension ProfileDataFormViewController: UITextViewDelegate {
    
    //MARK: Text editing started
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray {
            textView.textColor = .label
            textView.text = ""
        }
    }
    // MARK: returns text back when clicking on another field
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Tell the world about yourself"
            textView.textColor = .gray
        }
    }
}
