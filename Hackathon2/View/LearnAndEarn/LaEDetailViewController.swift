//
//  LaEDetailViewController.swift
//  Hackathon2
//
//  Created by Mustafa Altıparmak on 20.02.2022.
//

import UIKit
import Firebase

class LaEDetailViewController: UIViewController {
    
    var model: QuestionModel?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let answer_1_Button: UIButton = {
        let button = UIButton()
        button.setTitle("Hesap Oluştur", for: .normal)
        button.backgroundColor = .systemOrange
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let answer_2_Button: UIButton = {
        let button = UIButton()
        button.setTitle("Hesap Oluştur", for: .normal)
        button.backgroundColor = .systemOrange
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
        view.addSubview(titleLabel)
        view.addSubview(detailLabel)
        view.addSubview(questionLabel)
        view.addSubview(answer_1_Button)
        view.addSubview(answer_2_Button)
        
        answer_1_Button.addTarget(self, action: #selector(answer_1_Tapped), for: .touchUpInside)
        answer_2_Button.addTarget(self, action: #selector(answer_2_Tapped), for: .touchUpInside)
        setup()
    }
    
    @objc func answer_1_Tapped(_ sender: UIButton) {
        if model!.correct == 1 {
            //TRUE
            sender.backgroundColor = .systemGreen
            correctAnswer()
        }else {
            sender.backgroundColor = .systemRed
            wrongAnswer()
        }
    }
    
    @objc func answer_2_Tapped(_ sender: UIButton) {
        if model!.correct == 2 {
            sender.backgroundColor = .systemGreen
            correctAnswer()
        }else {
            sender.backgroundColor = .systemRed
            wrongAnswer()
        }
    }
    
    private func correctAnswer() {
        if Auth.auth().currentUser == nil {
            let ac = UIAlertController(title: "Doğru Cevap",
                                       message: "Ama puanın giriş yapmadığın için kaydedilemedi",
                                       preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Kapat", style: .default, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }))
            present(ac, animated: true)
        } else {
            DataBaseManager.shared.updateScore(extra: 20)
            let ac = UIAlertController(title: "Doğru Cevap 🥳🥳🥳",
                                       message: "20 Puan eklendi",
                                       preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Kapat", style: .default, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }))
            present(ac, animated: true)
        }
        
    }
    private func wrongAnswer() {
        let ac = UIAlertController(title: "Yanlış Cevap ❗️",
                                   message: "Metni tekrar okumalısın",
                                   preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Kapat", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        present(ac, animated: true)
    }
    
    
    private func setup() {
        guard let model = model else {
            return
        }
        titleLabel.text = model.title
        detailLabel.text = model.detail
        questionLabel.text = model.question
        answer_1_Button.setTitle(model.answer_1, for: .normal)
        answer_2_Button.setTitle(model.answer_2, for: .normal)

    }
    
    override func viewDidLayoutSubviews() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            detailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            
            questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            questionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            questionLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 5),
            
            answer_1_Button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            answer_1_Button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            answer_1_Button.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 30),
            
            answer_2_Button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            answer_2_Button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            answer_2_Button.topAnchor.constraint(equalTo: answer_1_Button.bottomAnchor, constant: 10),
        ])
    }
    
    
    

}
