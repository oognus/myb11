//
//  HomeViewController.swift
//  MyB11
//
//  Created by oognus on 2019/11/15.
//  Copyright © 2019 superjersey. All rights reserved.
//

import UIKit
import SideMenu
import RealmSwift
import FloatingPanel
import SnapKit

class HomeViewController: UIViewController, FloatingPanelControllerDelegate {
    
    
    var fpc: FloatingPanelController!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Remove the views managed by the `FloatingPanelController` object from self.view.
//        fpc.removePanelFromParent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
            
        // 팀셋팅, 경기장셋팅, 선수셋팅
        
        initViews()
        
        
        fpc = FloatingPanelController()
        

        // Assign self as the delegate of the controller.
        fpc.delegate = self // Optional

        // Set a content view controller.
        let contentVC = PanelViewController()
        fpc.set(contentViewController: contentVC)

        // Track a scroll view(or the siblings) in the content view controller.
//        fpc.track(scrollView: contentVC.tableView)

        // Add and show the views managed by the `FloatingPanelController` object to self.view.
        fpc.addPanel(toParent: self)
    }
    
    func initViews() {
        //
        let superView = self.view!
        let sideMenuButton = UIButton()
        let groundView = UIView()
        
        //
        superView.addSubview(groundView)
        superView.addSubview(sideMenuButton)
        
        //snp
        groundView.snp.makeConstraints { (make) -> Void in
            make.top.left.right.equalTo(superView)
            make.height.equalTo(superView.snp.width)
        }
        
        sideMenuButton.snp.makeConstraints { (make) in
            make.top.left.equalTo(superView).offset(20)
        }
        
        //config
        groundView.backgroundColor = .red
        sideMenuButton.setTitle("MN", for: .normal)
        
        
        
        
        
        
    }
    
    func updateGround() {
        
    }
    
    //
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
