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

class HomeViewController: UIViewController, FloatingPanelControllerDelegate, UIGestureRecognizerDelegate {
    

    let realm = try! Realm()
    var fpc: FloatingPanelController!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Remove the views managed by the `FloatingPanelController` object from self.view.
//        fpc.removePanelFromParent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let current_team = realm.objects(Team.self).filter("is_current == true")
        print(current_team)
        if (current_team.first == nil) {
            let team = Team()
            team.name = "default"
            team.memo = "default"
            team.is_current = true
            
            let players = List<Player>()
            
            for i in 0...10 {
                let player = Player()
                player.x = CGFloat(100+i)
                player.y = CGFloat(100+i)
                players.append(player)
            }
            
            team.players = players
            
            try! realm.write {
                realm.add(team)
            }
        }
        
            
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
    
    let playersView = UIView()
    func initViews() {
        
        //
        let superView = self.view!
        let sideMenuButton = UIButton()
        let groundView = UIView()
        let groundImageView = UIImageView()
        let teamNameView = UIView()
        let teamNameLabel = UILabel()
        let teamMemoLabel = UILabel()
        
        //
        superView.addSubview(groundView)
        
        groundView.addSubview(groundImageView)
        groundView.addSubview(teamNameView)
        groundView.addSubview(sideMenuButton)
        groundView.addSubview(playersView)
        
        teamNameView.addSubview(teamNameLabel)
        teamNameView.addSubview(teamMemoLabel)

        
        //snp
        groundView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(superView).offset(30)
            make.left.right.equalTo(superView)
            make.height.equalTo(superView.snp.width)
        }
        
        groundImageView.snp.makeConstraints { (make) in
            make.top.equalTo(superView)
            make.left.right.bottom.equalTo(groundView)
        }
        
        sideMenuButton.snp.makeConstraints { (make) in
            make.top.left.equalTo(groundView).offset(20)
        }
        
        playersView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(groundView)
        }
        
        teamNameView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(groundView)
            make.height.equalTo(100)
        }
        
        teamNameLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(teamNameView)
            make.bottom.equalTo(teamNameView.snp.centerY)
        }
        
        teamMemoLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(teamNameView)
            make.top.equalTo(teamNameView.snp.centerY)
        }
        
        //config
        groundView.backgroundColor = .red
        sideMenuButton.setTitle("MN", for: .normal)
        groundImageView.image = UIImage(named: "dong_test.png")
        sideMenuButton.backgroundColor = .black
        teamNameView.backgroundColor = .yellow
        teamNameLabel.textAlignment = .center
        teamNameLabel.text = "Manchester Utd."
        teamMemoLabel.textAlignment = .center
        teamMemoLabel.text = "v Liverpool"
        
        updateGround()
    }

    var players = List<Player>()
    func updateGround() {
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        let playerWidth = screenSize.width * 0.1
        let playerHeight = screenSize.width * 0.1
        
        let center = screenSize.width * 0.5
        
        
        //
        let current_team = realm.objects(Team.self).filter("is_current == true").first!
        
        players = current_team.players
    
        
        // 팀 가져와서 셋팅
        //team name, memo, stadium 셋팅
        
        //
        for v in playersView.subviews {
            v.removeFromSuperview()
        }
        
        for (index, player) in players.enumerated() {
            let player_x = player.x
            let player_y = player.y
            let playerView = UIView(frame: CGRect(x: 0, y: 0, width: playerWidth, height: playerHeight))
            playersView.addSubview(playerView)
            
            playerView.backgroundColor = .black
            playerView.center.x = player_x
            playerView.center.y = player_y
            playerView.tag = index
            
            let gesture = UIPanGestureRecognizer(target: self, action: #selector(wasDragged(_:)))
            playerView.addGestureRecognizer(gesture)
            gesture.delegate = self

        }
        
        
        
    }
    
    @objc func wasDragged(_ gestureRecognizer: UIPanGestureRecognizer) {

        if gestureRecognizer.state == UIGestureRecognizer.State.began || gestureRecognizer.state == UIGestureRecognizer.State.changed {

            let translation = gestureRecognizer.translation(in: playersView)
                    
            let view_x = gestureRecognizer.view!.center.x+translation.x
            let view_y = gestureRecognizer.view!.center.y + translation.y
            
            let tag = gestureRecognizer.view?.tag
            try! realm.write {
                players[tag!].x = view_x
                players[tag!].y = view_y
            }
            
            
            gestureRecognizer.view!.center = CGPoint(
                x: view_x,
                y: view_y)
            
            gestureRecognizer.setTranslation(CGPoint(x: 0, y: 0), in: playersView)
        }
    }
    
    
    
    
    
    
    
    
    @objc func buttonTapGesture(_ gesture: UITapGestureRecognizer){
        print("UIGestureRecognizer : UITapGestureRecognizer")
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
            let current_team = realm.objects(Team.self).filter("is_current==true").first
            
            if (current_team != nil) {
                    try! realm.write {
                        current_team!.is_current = false
                    }
            }
            
            //
            
            
            let team = Team()
            team.name = teamName
            team.memo = teamMemo
            team.is_current = true
            
            let players = List<Player>()
            
            for i in 0...10 {
                let player = Player()
                player.x = CGFloat(100+i)
                player.y = CGFloat(100+i)
                players.append(player)
            }
            
            team.players = players
            
            try! realm.write {
                realm.add(team)
            }
            
            
        }))
        
        self.present(alert, animated: true, completion: nil)
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
