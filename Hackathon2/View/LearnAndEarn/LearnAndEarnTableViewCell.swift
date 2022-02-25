//
//  LearnAndEarnTableViewCell.swift
//  HackathonMustafaAltıparmak
//
//  Created by Mustafa Altıparmak on 18.02.2022.
//

import UIKit

class LearnAndEarnTableViewCell: UITableViewCell {

    static let identifier = "LearnAndEarnTableViewCell"
    
    private let challengeImageView: UIImageView = {
        let challengeImageView = UIImageView()
        challengeImageView.image = UIImage(systemName: "brain.head.profile")?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        challengeImageView.translatesAutoresizingMaskIntoConstraints = false
        challengeImageView.contentMode = .scaleAspectFit
        return challengeImageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let scoreView: UIView = {
        let scoreView = UIView()
        scoreView.backgroundColor = UIColor(red: 28/255, green: 161/255, blue: 8/255, alpha: 1)
        scoreView.translatesAutoresizingMaskIntoConstraints = false
        scoreView.layer.cornerRadius = 20
        return scoreView
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.text = "+20"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        contentView.addSubview(challengeImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(scoreView)
        contentView.addSubview(detailLabel)
        
        scoreView.addSubview(scoreLabel)
    }
    
    func configure(with model: QuestionModel) {
        titleLabel.text = model.title
        detailLabel.text = model.detail
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            challengeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            challengeImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            challengeImageView.widthAnchor.constraint(equalToConstant: 120),
            challengeImageView.heightAnchor.constraint(equalToConstant: 120),
            
            titleLabel.topAnchor.constraint(equalTo: challengeImageView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: challengeImageView.trailingAnchor, constant: 10),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -10),
            
            detailLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            detailLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6),
  
            scoreView.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 5),
            scoreView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            scoreView.widthAnchor.constraint(equalToConstant: 50),
            scoreView.heightAnchor.constraint(equalToConstant: 40),
            
            scoreLabel.centerXAnchor.constraint(equalTo: scoreView.centerXAnchor),
            scoreLabel.centerYAnchor.constraint(equalTo: scoreView.centerYAnchor)

        ])
    }

}
