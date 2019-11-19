//
//  ViewController.swift
//  MyB11
//
//  Created by oognus on 2019/11/15.
//  Copyright © 2019 superjersey. All rights reserved.
//

import UIKit
import SideMenu
import RealmSwift

class ViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //
        let realm = try! Realm()
        
        //
        let team = Team()
        team.name = "Han"
        print("name of TEAM: \(team.name)")
        
//        try! realm.write {
//            realm.add(team)
//        }
        
        
        let teams = realm.objects(Team.self)
        print(teams)
    }

    @IBAction func didTabMenu(_ sender: UIButton) {
        print("asdf")
        
        let menu = SideMenuNavigationController(rootViewController: self)
        // SideMenuNavigationController is a subclass of UINavigationController, so do any additional configuration
        // of it here like setting its viewControllers. If you're using storyboards, you'll want to do something like:
        // let menu = storyboard!.instantiateViewController(withIdentifier: "RightMenu") as! SideMenuNavigationController
        present(menu, animated: true, completion: nil)
    }
    
}


extension UIViewController {
    
    func showTeamAlert() {
        let alert = UIAlertController(title: "title", message: "message", preferredStyle: .alert)

        alert.addTextField { (UITextField) in }
        alert.addTextField { (UITextField) in }
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { [weak alert] (_) in
            let teamNameField = alert?.textFields![0] // Force unwrapping because we know it exists.
            let teamMemoField = alert?.textFields![1] // Force unwrapping because we know it exists.
            let teamName: String = teamNameField!.text!
            let teamMemo: String = teamMemoField!.text!
            
            let realm = try! Realm()
            
            //
            let team = Team()
            team.name = teamName
            team.memo = teamMemo
            
            try! realm.write {
                realm.add(team)
            }
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func popupAlert() {
        print("pupup")
    }
//    func popupAlert(title: String?, message: String?, actionTitles:[String?], actions:[((UIAlertAction) -> Void)?]) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        for (index, title) in actionTitles.enumerated() {
//            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
//            alert.addAction(action)
//        }
//        self.present(alert, animated: true, completion: nil)
//    }
}
