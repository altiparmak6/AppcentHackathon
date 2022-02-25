//
//  ShowerViewController.swift
//  HackathonMustafaAltıparmak
//
//  Created by Mustafa Altıparmak on 19.02.2022.
//

import UIKit
import Firebase

class ShowerViewController: UIViewController, CAAnimationDelegate {
    
    let shape = CAShapeLayer()
    let animation = CABasicAnimation(keyPath: "strokeEnd")
    var timer: Timer!
    let maxTime: Double = 20
    var duration: Double = 20
    
    private let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Başlat", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.backgroundColor = .systemGreen
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        return button
    }()
    
    private let stopButton: UIButton = {
        let button = UIButton()
        button.setTitle("Bitir", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.backgroundColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        return button
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Başla"
        label.font = UIFont.boldSystemFont(ofSize: 70) //84
        label.textAlignment = .center
        return label
    }()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "DarkModeColor")
        view.addSubview(startButton)
        view.addSubview(stopButton)
        view.addSubview(timeLabel)
        
        animation.delegate = self
        
        setupShape()
        startButton.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(didTapStopButton), for: .touchUpInside)
        
    }
    
    
    
    
    @objc private func didTapStartButton() {
        //show timeLabel
        //start animation
        //start timer to calculate if user completes shower before deadline
            
        timeLabel.isHidden = false
        timeLabel.text = String(format: "%0.f", duration)
        
        animation.toValue = 1
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        shape.add(animation, forKey: "animation")
        
        //begin time
        //to resume animation begin time is required
        animation.beginTime = CACurrentMediaTime()
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
    }
    
    
    @objc private func didTapStopButton() {
        timer.invalidate()
        
        shape.removeFromSuperlayer()
        shape.removeAllAnimations()
        let pausedTime = shape.convertTime(CACurrentMediaTime(), from: nil)
        shape.speed = 0.0
        shape.timeOffset = pausedTime

        //How long has it been since the beginning
        let elapsedTime = CACurrentMediaTime() - animation.beginTime
        
        
        
        //MARK: - SUCCESS, ADD SCORE
        //User did tap the stop button, if there is time left that means success
        
        if elapsedTime < maxTime {
            
            if Auth.auth().currentUser == nil {
                let ac = UIAlertController(title: "Tebrikler",
                                           message: "Ama puanın giriş yapmadığın için kaydedilemedi",
                                           preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Kapat", style: .default, handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                }))
                present(ac, animated: true)
            } else {
                DataBaseManager.shared.updateScore(extra: 80)
                let ac = UIAlertController(title: "Tebrikler 🥳",
                                           message: "80 puan kazandın",
                                           preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Kapat", style: .default, handler: {[weak self] _ in
                    self?.navigationController?.popViewController(animated: true)
                }))
                present(ac, animated: true)
                
                
            }

        }
        
    }
    
    
    @objc func updateTimer() {
        duration -= 1
        timeLabel.text = String(format: "%0.f", duration)

        
        //MARK: - FAILURE, NO EXTRA SCORE
        //There is no time left, that means failure and no score will be added
        if duration == 0 {
            timer.invalidate()
        
            let ac = UIAlertController(title: "Süre doldu ⚠️",
                                       message: "Duşta 20 dakikadan fazla zaman harcamamalısın",
                                       preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Kapat", style: .default, handler: {[weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }))
            present(ac, animated: true)
        }
    }
    
    

    
    
    private func setupShape() {
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: view.frame.width / 2, y: 300),
                                      radius: 140,
                                      startAngle: 0,
                                      endAngle: .pi * 2,
                                      clockwise: true)
        let trackShape = CAShapeLayer()
        trackShape.path = circlePath.cgPath
        trackShape.fillColor = UIColor.clear.cgColor
        trackShape.lineWidth = 15
        trackShape.strokeColor = UIColor.lightGray.cgColor
        view.layer.addSublayer(trackShape)
        
        shape.path = circlePath.cgPath
        shape.lineWidth = 15
        shape.strokeColor = UIColor.blue.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.lineCap = .round
        shape.strokeEnd = 0
        view.layer.addSublayer(shape)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate([
            
            //stop button is at the bottom
            //start botton is above stop button
            //time label is in the middle of circle
            
            stopButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            stopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stopButton.widthAnchor.constraint(equalToConstant: 150),
            stopButton.heightAnchor.constraint(equalToConstant: 60),
            
            startButton.bottomAnchor.constraint(equalTo: stopButton.topAnchor, constant: -10),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.widthAnchor.constraint(equalToConstant: 150),
            startButton.heightAnchor.constraint(equalToConstant: 60),
            
           
            
            timeLabel.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 300), //constant 300 = center of shape
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
    }
    
    

    
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    
}
