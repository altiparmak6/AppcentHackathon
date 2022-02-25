//
//  InformFriendViewController.swift
//  HackathonMustafaAltıparmak
//
//  Created by Mustafa Altıparmak on 19.02.2022.
//

import UIKit
import Firebase

class InformFriendViewController: UIViewController {
    
    private let waterImageView: UIImageView = {
        let waterImageView = UIImageView()
        waterImageView.image = UIImage(named: "water-splash")
        waterImageView.contentMode = .scaleAspectFill
        waterImageView.translatesAutoresizingMaskIntoConstraints = false
        return waterImageView
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Bir arkadaşını su kaynaklarının korunması hakkında bilgilendir, butona bas ve puanını al..."
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //Not button but, will be adding gesture regocnizer
    private let approvalImageView: UIImageView = {
        let challengeImageView = UIImageView()
        challengeImageView.image = UIImage(systemName: "checkmark.seal.fill")?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        challengeImageView.translatesAutoresizingMaskIntoConstraints = false
        return challengeImageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "DarkModeColor")
        
        view.addSubview(waterImageView)
        view.addSubview(infoLabel)
        view.addSubview(approvalImageView)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapApprovalView))
        gesture.numberOfTapsRequired = 1
        approvalImageView.addGestureRecognizer(gesture)
        approvalImageView.isUserInteractionEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate([
            waterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            waterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            waterImageView.heightAnchor.constraint(equalToConstant: 150),
            waterImageView.widthAnchor.constraint(equalToConstant: 150),
            
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoLabel.topAnchor.constraint(equalTo: waterImageView.bottomAnchor, constant: 20),
            infoLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            
            approvalImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            approvalImageView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 20),
            approvalImageView.heightAnchor.constraint(equalToConstant: 80),
            approvalImageView.widthAnchor.constraint(equalToConstant: 80)
            
        ])
    }
    
    
    @objc func didTapApprovalView() {
        if Auth.auth().currentUser == nil {
            alertUser(with: "Ama puanlarını kaydedebilmek için giriş yapmalısın")
        } else {
            alertUser(with: "Arkadaşlarına bu uygulamadan bahsetmeyi de unutma")
            DataBaseManager.shared.updateScore(extra: 20)
        }
    }
    
    private func alertUser(with message: String) {
        let ac = UIAlertController(title: "Teşekkürler", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Kapat", style: .default, handler: nil))
        present(ac, animated: true)
    }
    



}
