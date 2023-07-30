//
//  TweetComposeViewController.swift
//  TwitterClon
//
//  Created by Николай Гринько on 30.07.2023.
//

import UIKit
import Combine

class TweetComposeViewController: UIViewController {

    private var viewModel = TweetComposeViewViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    
    private let tweetButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .twitterBlueColor
        button.setTitle("Tweet", for: .normal)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button .isEnabled = false
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.7), for: .disabled)
        return button
    }()
    
    private let tweetContentTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
//        textView.backgroundColor = .secondarySystemFill
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 8
        textView.textContainerInset = .init(top: 15, left: 15, bottom: 15, right: 15)
        textView.text = "what's happening?"
        textView.font = .systemFont(ofSize: 16)
        textView.textColor = .gray
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Tweet"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapToCancel))
        tweetContentTextView.delegate = self
        view.addSubview(tweetButton)
        view.addSubview(tweetContentTextView)
        configureConstraints()
        bindWiews()
        tweetButton.addTarget(self, action: #selector(didTapToTweet), for: .touchUpInside)
    }
    
    @objc private func didTapToTweet() {
        viewModel.dispatchTweet()
        
    }
    
    private func bindWiews() {
        viewModel.$isValidToTweet.sink { [weak self] state in
            self?.tweetButton.isEnabled = state
        }.store(in: &subscriptions)
        
        viewModel.$shouldDismissComposer.sink { [weak self] success in
            if success {
                self?.dismiss(animated: true)
            }
        }
        .store(in: &subscriptions)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getUserData()
        
    }
    
    private func  configureConstraints() {
        
      let tweetbuttonConstraints = [
        tweetButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -10),
        tweetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        tweetButton.widthAnchor.constraint(equalToConstant: 120),
        tweetButton.heightAnchor.constraint(equalToConstant: 40)
      ]
        
        let tweetContentTextViewConstraints = [
            tweetContentTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tweetContentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tweetContentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tweetContentTextView.bottomAnchor.constraint(equalTo: tweetButton.topAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(tweetbuttonConstraints)
        NSLayoutConstraint.activate(tweetContentTextViewConstraints)
        
    }
    @objc private func didTapToCancel() {
        dismiss(animated: true)
    }

}

extension TweetComposeViewController: UITextViewDelegate {
    
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
            textView.text = "what's happening"
            textView.textColor = .gray
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        viewModel.tweetContent = textView.text
        viewModel.validateToTweet()
    }
}
