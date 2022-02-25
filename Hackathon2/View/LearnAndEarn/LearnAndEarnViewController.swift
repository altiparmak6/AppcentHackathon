//
//  LearnAndEarnViewController.swift
//  HackathonMustafaAltıparmak
//
//  Created by Mustafa Altıparmak on 18.02.2022.
//

import UIKit

class LearnAndEarnViewController: UIViewController {
    
    var questions = [QuestionModel]()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = false
        tableView.register(LearnAndEarnTableViewCell.self, forCellReuseIdentifier: LearnAndEarnTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //MARK: - Get question
        DataBaseManager.shared.getQuestions(completion: { [weak self] questionModels in
            self?.questions = questionModels
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}


extension LearnAndEarnViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LearnAndEarnTableViewCell.identifier, for: indexPath) as! LearnAndEarnTableViewCell
        cell.configure(with: questions[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = LaEDetailViewController()
        vc.model = questions[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
