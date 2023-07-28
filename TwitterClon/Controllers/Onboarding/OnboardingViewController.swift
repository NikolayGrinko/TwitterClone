//
//  OnboardingViewController.swift
//  TwitterClon
//
//  Created by Николай Гринько on 27.07.2023.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "See what's happening in the world right now"
        label.font = .systemFont(ofSize: 32, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    
    private let createaccountButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Create account", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.backgroundColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        button.layer.masksToBounds = true
        button.tintColor = .white
        button.layer.cornerRadius = 30
        return button
    }()
    
    private let promtLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tintColor = .gray
        label.text = "Have an account already"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.tintColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(welcomeLabel)
        view.addSubview(createaccountButton)
        view.addSubview(promtLabel)
        view.addSubview(loginButton)
        
        createaccountButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        configureConstraints()
    }
    
    @objc private func didTapLogin() {
        let vc = LoginViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapCreateAccount() {
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func configureConstraints() {
        
        let welcomeLabelConstraints = [
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        let creatreAccountButtonConstraints = [
            createaccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createaccountButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            createaccountButton.widthAnchor.constraint(equalTo: welcomeLabel.widthAnchor, constant: -20),
            createaccountButton.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        let promtLabelConstraint = [
            promtLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            promtLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
        ]
        
        let loginButtonConstraints = [
            loginButton.centerYAnchor.constraint(equalTo: promtLabel.centerYAnchor),
            loginButton.leadingAnchor.constraint(equalTo: promtLabel.trailingAnchor, constant: 10)
        ]
        
        NSLayoutConstraint.activate(welcomeLabelConstraints)
        NSLayoutConstraint.activate(creatreAccountButtonConstraints)
        NSLayoutConstraint.activate(promtLabelConstraint)
        NSLayoutConstraint.activate(loginButtonConstraints)
    }
}
