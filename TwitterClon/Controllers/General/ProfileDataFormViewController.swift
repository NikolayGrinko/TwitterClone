//
//  ProfileDataFormViewController.swift
//  TwitterClon
//
//  Created by Николай Гринько on 29.07.2023.
//


import UIKit
import Combine
//MASK: modul download photos
import PhotosUI

class ProfileDataFormViewController: UIViewController {

   //MARK:
    private var viewModel = ProfileDataFormViewViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .onDrag
        return scrollView
    }()
    // MARK: Add text field
    private let displayNameTextField: UITextField = {
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
        imageView.contentMode = .scaleAspectFill
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
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Submit", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = .twitterBlueColor
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(hintLabel)
        scrollView.addSubview(avatarPlaceholderImageView)
        scrollView.addSubview(displayNameTextField)
        scrollView.addSubview(userNameTextField)
        scrollView.addSubview(bioTextView)
        scrollView.addSubview(submitButton)
        isModalInPresentation = true
        displayNameTextField.delegate = self
        userNameTextField.delegate = self
        bioTextView.delegate = self
        view.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(didTapToDismiss)))
        configureConstraints()
        submitButton.addTarget(self, action: #selector(didTapSubmit), for: .touchUpInside)
        avatarPlaceholderImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapToUpLoad)))
        bindViews()
    }

    @objc private func didTapSubmit() {
        viewModel.uploadAvatar()
    }
    
    @objc private func didUpdateDisplayName() {
        viewModel.displayName = displayNameTextField.text
        viewModel.validateUserProfileForm()
    }
    
    @objc private func didUpdateUsername() {
        viewModel.username = userNameTextField.text
        viewModel.validateUserProfileForm()
    }
    
    
    private func bindViews() {
        displayNameTextField.addTarget(self, action: #selector(didUpdateDisplayName), for: .editingChanged)
        userNameTextField.addTarget(self, action: #selector(didUpdateUsername), for: .editingChanged)
        viewModel.$isFormValid.sink { [weak self] buttonState in
            self?.submitButton.isEnabled = buttonState
        }
        .store(in: &subscriptions)
        
        viewModel.$isOnBoardingFinished.sink { [weak self] success in
            if success {
                self?.dismiss(animated: true)
            }
        }
        .store(in: &subscriptions)
    }
    
    @objc private func didTapToUpLoad() {
       var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func didTapToDismiss() {
        view.endEditing(true)
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
            displayNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            displayNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            displayNameTextField.topAnchor.constraint(equalTo: avatarPlaceholderImageView.bottomAnchor, constant: 40),
            displayNameTextField.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let userNameTextFieldConstraints = [
            userNameTextField.leadingAnchor.constraint(equalTo: displayNameTextField.leadingAnchor),
            userNameTextField.trailingAnchor.constraint(equalTo: displayNameTextField.trailingAnchor),
            userNameTextField.topAnchor.constraint(equalTo: displayNameTextField.bottomAnchor, constant: 20),
            userNameTextField.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let bioTextViewConstraints = [
            bioTextView.leadingAnchor.constraint(equalTo: displayNameTextField.leadingAnchor),
            bioTextView.trailingAnchor.constraint(equalTo: displayNameTextField.trailingAnchor),
            bioTextView.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 20),
            bioTextView.heightAnchor.constraint(equalToConstant: 150)
        ]
        
        let submitButtonConstraints = [
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            submitButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -20)
        ]
        
        NSLayoutConstraint.activate(scrollViewConstraints)
        NSLayoutConstraint.activate(hintLabelConstraints)
        NSLayoutConstraint.activate(avatarPlaceholderImageViewConstraints)
        NSLayoutConstraint.activate(displayNameTextLabelConstraint)
        NSLayoutConstraint.activate(userNameTextFieldConstraints)
        NSLayoutConstraint.activate(bioTextViewConstraints)
        NSLayoutConstraint.activate(submitButtonConstraints)
    }
    
}

extension ProfileDataFormViewController: UITextViewDelegate, UITextFieldDelegate {
    
    //MARK: Text editing started
    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: textView.frame.origin.y - 100), animated: true)
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
    
    func textViewDidChange(_ textView: UITextView) {
        viewModel.bio = textView.text
        viewModel.validateUserProfileForm()
    }
    
    //MARK: When you call the keyboard, everything moves up
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: textField.frame.origin.y - 100), animated: true)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}

//MARK: Method extension for adding a photo to a profile
extension ProfileDataFormViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        
        // MARK: Method to navigate back to profile after selecting a photo
        picker.dismiss(animated: true)
        
        //Mark: method for uploading and installing a photo in a profile avatar
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self?.avatarPlaceholderImageView.image = image
                        self?.viewModel.imageData = image
                        self?.viewModel.validateUserProfileForm()
                    }
                }
            }
        }
    }
}





