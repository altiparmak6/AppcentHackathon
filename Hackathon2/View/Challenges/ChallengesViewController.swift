//
//  Challenges.swift
//  HackathonMustafaAltıparmak
//
//  Created by Mustafa Altıparmak on 18.02.2022.
//

import UIKit

class ChallengesViewController: UIViewController {
  
    var challenges = [ChallengesModel]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = false
        tableView.register(ChallengesTableViewCell.self, forCellReuseIdentifier: ChallengesTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        challenges = [
            ChallengesModel(title: "Duş Süresi",
                            detail: "Duş süresini 20 dk altında tut ve 80 puan kazan",
                            totalScore: 80,
                            image: UIImage(named: "shower"),
                            vc: ShowerViewController()),
            ChallengesModel(title: "Alışkanlıklar",
                            detail: "Günlük alışkanlıklarımızı gözden geçirelim",
                            totalScore: 50,
                            image: UIImage(named: "routines"),
                            vc: RoutinesViewController()),
            ChallengesModel(title: "Arkadaşını bilgilendir",
                            detail: "Arkadaşına bildiklerinden bahset ve puanını al",
                            totalScore: 20,
                            image: UIImage(named: "inform"),
                            vc: InformFriendViewController())
        ]
    }
    


}

extension ChallengesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChallengesTableViewCell.identifier, for: indexPath) as! ChallengesTableViewCell
        
        cell.configure(with: challenges[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challenges.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = challenges[indexPath.row].vc
        navigationController?.pushViewController(vc, animated: true)
    }
}
