//
//  TabBarController.swift
//  HackathonMustafaAltıparmak
//
//  Created by Mustafa Altıparmak on 18.02.2022.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstVC = ChallengesViewController()
        firstVC.title = "Meydan Okuma"
        let secondVC = LearnAndEarnViewController()
        secondVC.title = "Öğren ve Kazan"
        let thirdVC = ProfileViewController()
        thirdVC.title = "Profilim"

        let controllers = [
            UINavigationController(rootViewController: firstVC),
            UINavigationController(rootViewController: secondVC),
            UINavigationController(rootViewController: thirdVC)
        ]
        setViewControllers(controllers, animated: true)

        tabBar.barTintColor = .black
        tabBar.isTranslucent = false

        
        //MARK: - Setting tab bar items' images
        guard let items = self.tabBar.items else {
            return
        }
        
        let systemImageStrings = ["circle.grid.cross.left.filled", "books.vertical.fill", "person.fill"]
        for i in 0..<items.count {
            items[i].image =  UIImage(systemName: systemImageStrings[i])
        }
        
    }


}
