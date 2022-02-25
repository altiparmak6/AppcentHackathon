//
//  RoutinesViewController.swift
//  HackathonMustafaAltıparmak
//
//  Created by Mustafa Altıparmak on 19.02.2022.
//

import UIKit
import Firebase

class RoutinesViewController: UIViewController {
    
    var objects = ["Dişlerimi fırçalarken musluğu kapalı tuttum",
                   "Bahçeyi gece suladım",
                   "Duşta geçirdiğim süre 20 dk altında",
                   "Bulaşıkları bulaşık makinesinde yıkıyorum",
                   "Kızartma yağını lavaboya dökmüyorum"
    ]
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Alışkanlıklar"
        
        view.addSubview(tableView)
    
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = UIColor(named: "DarkModeColor")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

}

extension RoutinesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = objects[indexPath.row]
        return cell
    }
    
    
    //MARK: - ADD SCORE
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        objects.remove(at: indexPath.row)
        let indexPath = IndexPath(item: indexPath.row, section: 0)
        tableView.deleteRows(at: [indexPath], with: .fade)
        
        let loggedInMessage = "10 puan kazandınız"
        let loggedOutMessage = "Puanları kazanmak için giriş yapmalısın"
        
        if Auth.auth().currentUser == nil {
            alertUser(title: "Harika", message: loggedOutMessage)
        }else {
            alertUser(title: "Harika", message: loggedInMessage)
            DataBaseManager.shared.updateScore(extra: 10)
        }


    }
    
    private func alertUser(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Kapat", style: .default, handler: nil))
        present(ac, animated: true)
    }
}
