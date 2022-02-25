//
//  RegisterViewController.swift
//  Hackathon2
//
//  Created by Mustafa Altıparmak on 19.02.2022.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        scrollView.backgroundColor = UIColor(named: "DarkModeColor")
        //scrollView.translatesAutoresizingMaskIntoConstraints = false  ???????
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle.badge.plus")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        //Can't make circular here. No width info yet
        //imageView.layer.cornerRadius = imageView.width / 2
        return imageView
    }()
    
    private let firstNameField: UITextField = {
        let field = UITextField()
        field.textColor = .secondaryLabel
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "İsim.."
        field.translatesAutoresizingMaskIntoConstraints = false
        
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        return field
    }()
    private let lastNameField: UITextField = {
        let field = UITextField()
        field.textColor = .secondaryLabel
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Soyisim.."
        field.translatesAutoresizingMaskIntoConstraints = false
        
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        return field
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.textColor = .secondaryLabel
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "E-posta adresi.."
        field.translatesAutoresizingMaskIntoConstraints = false
        
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.isSecureTextEntry = true
        field.placeholder = "Parola.."
        field.translatesAutoresizingMaskIntoConstraints = false
        
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        return field
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Hesap Oluştur", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        emailField.delegate = self
        passwordField.delegate = self
        
        //add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(lastNameField)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        scrollView.frame = view.bounds
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(gesture)
        imageView.isUserInteractionEnabled = true
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120),
            
            firstNameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstNameField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            firstNameField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8),
            firstNameField.heightAnchor.constraint(equalToConstant: 52),
            
            lastNameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lastNameField.topAnchor.constraint(equalTo: firstNameField.bottomAnchor, constant: 10),
            lastNameField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8),
            lastNameField.heightAnchor.constraint(equalToConstant: 52),

            emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailField.topAnchor.constraint(equalTo: lastNameField.bottomAnchor, constant: 10),
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
    
    @objc func didTapChangeProfilePic() {
        presentPhotoActionSheet()
    }
    
    
    
    
    
    
    //MARK: - registerButtonTapped, Firebase
     
     @objc private func registerButtonTapped() {
         
         firstNameField.resignFirstResponder()
         lastNameField.resignFirstResponder()
         emailField.resignFirstResponder()
         passwordField.resignFirstResponder()
         
         
         guard let firstName = firstNameField.text, let lastName = lastNameField.text, let email = emailField.text, let password = passwordField.text,
               !firstName.isEmpty, !lastName.isEmpty,
               !email.isEmpty, !password.isEmpty,
               password.count >= 6 else {
                   alertUserLoginError()
                   return
               }
         
//         Auth.auth().createUser(withEmail: email, password: password) { result, error in
//             let user = User(firstName: firstName, lastName: lastName, emailAdress: email)
//             DataBaseManager.shared.insertUser(with: user)
//         }
         
         //CREATING USER IN FIR AUTH
         Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
             guard let strongSelf = self else {
                 return
             }

             guard let result = authResult, error == nil else {
                 if let strongError = error {
                     print("Error creating new user: \(strongError)")
                 }
                 return
             }
             
             
             //INSERTING USER TO DATABASE
             let user = User(firstName: firstName, lastName: lastName, emailAdress: email)
             DataBaseManager.shared.insertUser(with: user, completion: {success in
                 if success {
                     //upload image
                     guard let image = strongSelf.imageView.image, let data = image.pngData() else {
                         return
                     }
                     let fileName = user.profilePictureFileName
                     StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName) { result in
                         switch result {
                         case .success(let downloadUrl):
                             UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                             print(downloadUrl)
                         case .failure(let error):
                             print("StorageManager error: \(error)")
                         }
                     }
                 }
             })
             
             
             
             //SENDING EMAIL VERIFICATION
//             result.user.sendEmailVerification { err in
//                 guard err == nil else {
//                     print("error sending email")
//                     return
//                 }
//                 let ac = UIAlertController(title: "E-posta gönderildi", message: "Gereksiz, istenmeyen e-postaları kontrol etmeyi unutmayın", preferredStyle: .alert)
//                 ac.addAction(UIAlertAction(title: "Kapat", style: .cancel, handler: { _ in
//                     strongSelf.navigationController?.popViewController(animated: true)
//                     //strongSelf.navigationController?.dismiss(animated: true, completion: nil)
//                 }))
//                 strongSelf.present(ac, animated: true)
//             }
             
         }
         


     }
     
     func alertUserLoginError(message: String = "Kayıt olmak için tüm bilgileri giriniz") {
         let ac = UIAlertController(title: "Hata",
                                    message: message,
                                    preferredStyle: .alert)
         ac.addAction(UIAlertAction(title: "Dismiss",
                                    style: .cancel, handler: nil))
         present(ac, animated: true)
     }


}

//MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == firstNameField {
            lastNameField.becomeFirstResponder()
        } else if textField == lastNameField {
            emailField.becomeFirstResponder()
        } else if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            registerButtonTapped()
        }
        return true
    }
}



//MARK: - UIImagePickerControllerDelegate
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profil Fotoğrafı",
                                            message: "Fotoğrafı nasıl eklemek istersiniz?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "İptal",
                                            style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Kamerayı aç",
                                            style: .default,
                                            handler: {[weak self] _ in
            self?.presentCamera()
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Fotoğraf'lardan seç",
                                            style: .default,
                                            handler: {[weak self] _ in
            self?.presentPhotoPicker()
        }))
        present(actionSheet, animated: true)
    }
    
    
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self //requires (UINavigationControllerDelegate)
        vc.allowsEditing = true
        present(vc,animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self //requires (UINavigationControllerDelegate)
        vc.allowsEditing = true
        present(vc,animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        guard let data = selectedImage.jpegData(compressionQuality: 0.1) else {return} //compress Image for storage
        self.imageView.image = UIImage(data: data)
        //image wasn't circular. Was cropping Sf symbol
        imageView.layer.cornerRadius = imageView.frame.size.width / 2

        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
