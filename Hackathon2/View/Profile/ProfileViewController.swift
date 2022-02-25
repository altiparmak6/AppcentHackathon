//
//  ProfileViewController.swift
//  HackathonMustafaAltıparmak
//
//  Created by Mustafa Altıparmak on 18.02.2022.
//

import UIKit
import Firebase
import SDWebImage

class ProfileViewController: UIViewController {
    

    var list2 = [
        ProfileModel(name: "Aktivite", vc: ActivityViewController(), color: .systemBlue),
        ProfileModel(name: "Konum", vc: LocationViewController(), color: .systemOrange),
        ProfileModel(name: "Giriş Yap", vc: LoginViewController(), color: .systemGreen),
        ProfileModel(name: "Çıkış yap", vc: nil, color: .systemRed)
    ]
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(named: "DarkModeColor")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        createTableHeader()
    }
    
    

    public func createTableHeader(){
        
        guard let email = Auth.auth().currentUser?.email else {
            return
        }
        
        let safeEmail = DataBaseManager.safeEmail(email: email)
        let fileName = safeEmail + "_profile_picture.png"
        let path = "/images/" + fileName
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 300))
    
        
        headerView.backgroundColor = .link
        
        let imageView = UIImageView(frame: CGRect(x: (headerView.frame.size.width - 150)/2, y: 75, width: 150, height: 150))
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.layer.masksToBounds = true
        
        let scoreLabel = UILabel(frame: CGRect(x: (headerView.frame.size.width - 150)/2, y: 240, width: 150, height: 40))
        scoreLabel.backgroundColor = .systemOrange
        scoreLabel.layer.cornerRadius = 20
        scoreLabel.layer.masksToBounds = true
        //scoreLabel.font = UIFont.systemFont(ofSize: 25)
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 25)
        scoreLabel.textAlignment = .center
        
        headerView.addSubview(imageView)
        headerView.addSubview(scoreLabel)
        
        //get url for profile picture
        StorageManager.shared.downloadURL(for: path) { result in
            switch result {
            case .success(let url):
                //self?.downloadImage(imageView: imageView, url: url)
                imageView.sd_setImage(with: url)
            case .failure(let error):
                print("Failed to get download url: \(error)")
            }
        }
        
        //get score
        DataBaseManager.shared.getScore { score in
            scoreLabel.text = "Puan: \(score)"
        }
        
        tableView.tableHeaderView = headerView
    }
    
    func downloadImage(imageView: UIImageView, url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                imageView.image = image
            }
        }.resume()
    }
    
    
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list2.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = list2[indexPath.row].name
        cell.textLabel?.textColor = list2[indexPath.row].color
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //The last element is for log-out, only last element has no view controller
        guard list2[indexPath.row].vc != nil else {
            logOut()
            return
        }
        
        //if list item has a vc, push it
        navigationController?.pushViewController(list2[indexPath.row].vc!, animated: true)
    }
    
    
    
    
    private func logOut() {
        let actionSheet = UIAlertController(title: "Çıkış yapılacak",
                                      message: "Çıkış yapmak istediğinizden emin misiniz?",
                                      preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Çıkış yap", style: .destructive, handler: { [weak self] _ in
            
            guard let strongSelf = self else {return}
            
            do {
                try FirebaseAuth.Auth.auth().signOut()
                
                //strongSelf.navigationController?.popViewController(animated: true)
                //When signOut go to first tab

                self?.tableView.tableHeaderView = nil
                strongSelf.tabBarController?.selectedIndex = 2
                
            } catch {
                print("Failed to log out")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "İptal", style: .cancel))
        present(actionSheet, animated: true)
    }
}


