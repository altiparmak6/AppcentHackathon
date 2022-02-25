//
//  LoginViewController.swift
//  Hackathon2
//
//  Created by Mustafa Altıparmak on 19.02.2022.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        scrollView.backgroundColor = UIColor(named: "DarkModeColor")
        //scrollView.translatesAutoresizingMaskIntoConstraints = false  ???????
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "drop.circle.fill")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.textColor = .label
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "E-posta adresi.."
        field.translatesAutoresizingMaskIntoConstraints = false
        
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0)) //for padding
        field.leftViewMode = .always
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.textColor = .label
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.isSecureTextEntry = true
        field.placeholder = "Parola.."
        field.translatesAutoresizingMaskIntoConstraints = false
        
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0)) //for padding
        field.leftViewMode = .always
        return field
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Giriş Yap", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //title = "Giriş Yap"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Hesap Oluştur",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapRegister))
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        emailField.delegate = self
        passwordField.delegate = self
        
        //add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
        
        
        scrollView.frame = view.bounds
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120),

            emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            emailField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8),
            emailField.heightAnchor.constraint(equalToConstant: 52),

            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 10),
            passwordField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8),
            passwordField.heightAnchor.constraint(equalToConstant: 52),
            
            loginButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 10),
            loginButton.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8),
            loginButton.heightAnchor.constraint(equalToConstant: 52)
        ])
        
        
    }
    
    
    
    
    
    

    
    
    @objc private func didTapRegister() {
        let vc = RegisterViewController()
        vc.title = "Hesap Oluştur"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - LoginButtonTapped, Firebase login
    
    @objc private func loginButtonTapped() {
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let  email = emailField.text, let password = passwordField.text,
              !email.isEmpty, !password.isEmpty, password.count >= 6 else {
                  alertUserLoginError()
                  return
              }


        //Firebase login
        Auth.auth().signIn(withEmail: email, password: password) {[weak self] authResult, error in
            guard let strongSelf = self else {return}

            guard let result = authResult, error == nil else {
                print("Failed to sign in user with email: \(email)")
                return
            }

            UserDefaults.standard.set(email, forKey: "email")

            let user = result.user
            print("Logged in user \(user)")
            //strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            strongSelf.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func alertUserLoginError() {
        let ac = UIAlertController(title: "Hata",
                                   message: "Giriş yapmak için bilgilerini tam girmelisin",
                                   preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Dismiss",
                                   style: .cancel, handler: nil))
        present(ac, animated: true)
    }

    
    
}


//MARK: - TextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            loginButtonTapped()
        }
        return true
    }
}
