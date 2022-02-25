//
//  ActivityViewController.swift
//  Hackathon2
//
//  Created by Mustafa Altıparmak on 20.02.2022.
//

import UIKit

class ActivityViewController: UIViewController {
    
    private let denemeButton: UIButton = {
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

        view.backgroundColor = UIColor(named: "DarkModeColor")
        view.addSubview(denemeButton)
        denemeButton.addTarget(self, action: #selector(denemeTapped), for: .touchUpInside)
    }
    
    @objc func denemeTapped() {
        //DataBaseManager.shared.deneme()
    }
    
    override func viewDidLayoutSubviews() {
        NSLayoutConstraint.activate([
            denemeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            denemeButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            denemeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    


}
