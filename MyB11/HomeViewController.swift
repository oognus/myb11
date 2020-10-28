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
//import FloatingPanel
import SnapKit
import CircleMenu
import MenuItemKit


class HomeViewController: UIViewController,  UIGestureRecognizerDelegate, TestDelegate, CircleMenuDelegate {

    
    
    func didPressButton() {
        print("didPressedButton")
    }
    
    

    let realm = try! Realm()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if (realm.objects(Team.self).filter("is_current == true").first == nil) {
            let name = "My First Team"
            let memo = "click to change"
            createTeam(name: name, memo: memo)
        }
        
        //
        initViews()
        
        //
        updateGround()
//
//        //
//        fpc = FloatingPanelController()
//        fpc.delegate = self // Optional
//        let contentVC = PanelViewController()
//        contentVC.delegate = self
//        fpc.set(contentViewController: contentVC)
//        fpc.track(scrollView: contentVC.collectionView)
//        fpc.surfaceView.containerMargins = .init(top: 0, left: 0, bottom: 100.0, right: 0)
//        fpc.addPanel(toParent: self)
//        fpc.hide()
    }
    
    @objc func pressedShareButton(sender: UITapGestureRecognizer) {
//        let text = "This is some text that I want to share."
//
//        // set up activity view controller
//        let textToShare = [ text ]
//        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
//        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
//
//        // exclude some activity types from the list (optional)
//
////        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
//
//        // present the view controller
//        self.present(activityViewController, animated: true, completion: nil)
        


        // image to share
//        let image = UIImage(named: "dong_test.png")
        
        
        //
        let renderer = UIGraphicsImageRenderer(size: self.groundView.bounds.size)
        let image = renderer.image { ctx in
            self.groundView.drawHierarchy(in: self.groundView.bounds, afterScreenUpdates: true)
        }

        // set up activity view controller
        let imageToShare = [ image ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]

        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)

    }
    
//    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
//        return MyFloatingPanelLayout()
//    }
    
    let playersView = UIView()
    let teamNameLabel = UILabel()
    let teamMemoLabel = UILabel()
    let groundView = UIView()
    func initViews() {
        
        
        let adView = UIView()
        let menuView = UIView()
        let shareButton = UIButton()
        
        self.view.addSubview(adView)
        self.view.addSubview(menuView)
        menuView.addSubview(shareButton)
        
        adView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.height.equalTo(100)
        }
        
        menuView.snp.makeConstraints { (make) in
            make.bottom.equalTo(adView.snp.top)
            make.left.right.equalTo(self.view)
            make.height.equalTo(100)
        }
        
        shareButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(menuView)
            make.right.equalTo(menuView).offset(-10)
        }
        
        //
        adView.backgroundColor = .yellow
        menuView.backgroundColor = .darkGray
        shareButton.setTitle("share", for: .normal)
        
        //
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.pressedShareButton))
        shareButton.addGestureRecognizer(gesture)
        
        // ground views
        let superView = self.view!
        superView.addSubview(groundView)
        
        //
        let groundImageView = UIImageView()
        let teamNameView = UIView()
        let sideMenuButton = UIButton()
        
        groundView.addSubview(groundImageView)
        groundView.addSubview(playersView)
        groundView.addSubview(teamNameView)
        groundView.addSubview(sideMenuButton)
        
//
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
        
        
        
        teamNameView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(groundView)
            make.height.equalTo(100)
        }
        
        playersView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(groundView)
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
        teamNameView.backgroundColor = .blue
        teamNameLabel.textAlignment = .center
        teamNameLabel.text = "Manchester Utd."
        teamMemoLabel.textAlignment = .center
        teamMemoLabel.text = "v Liverpool"
        
        let gg = UITapGestureRecognizer(target: self, action: #selector(editTeamName))
        teamNameView.addGestureRecognizer(gg)
    }
    
    var players = List<Player>()
    func updateGround() {
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        let playerWidth = screenSize.width * 0.1
        let playerHeight = screenSize.width * 0.2
        
        let shadowHeight = screenSize.width * 0.05
        let statusWidth = screenSize.width * 0.03
        
        
        //
        let current_team = realm.objects(Team.self).filter("is_current == true").first!
        
        //
        teamNameLabel.text = current_team.name
        teamMemoLabel.text = current_team.memo
        
        //
        players = current_team.players
    
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
            playerView.center.x = CGFloat(player_x)
            playerView.center.y = CGFloat(player_y)
            playerView.tag = index
            
            let jerseyView = UIImageView()
            let shadowView = UIImageView()
            let statusView = UIImageView()
            let nameView = UILabel()
            
            
            playerView.addSubview(jerseyView)
            playerView.addSubview(shadowView)
            playerView.addSubview(nameView)
            jerseyView.addSubview(statusView)
            
            //
            
            jerseyView.snp.makeConstraints { (make) in
                make.top.left.right.equalTo(playerView)
                make.height.equalTo(playerView.snp.width)
            }
            
            shadowView.snp.makeConstraints { (make) in
                make.top.equalTo(jerseyView.snp.bottom)
                make.left.right.equalTo(playerView)
                make.height.equalTo(shadowHeight)
            }
            
            nameView.snp.makeConstraints { (make) in
                make.top.equalTo(shadowView.snp.bottom)
                make.bottom.equalTo(playerView.snp.bottom)
                make.centerX.equalTo(playerView.snp.centerX)
            }
            
            statusView.snp.makeConstraints { (make) in
                make.right.equalTo(jerseyView.snp.right)
                make.bottom.equalTo(jerseyView.snp.bottom)
                make.width.height.equalTo(statusWidth)
            }
            
            //
            nameView.restorationIdentifier = "nameView"
            nameView.text = "이름이름이름"
            
            //
            jerseyView.image = UIImage(named: "dong_test.png")
            shadowView.image = UIImage(named: "dong_test.png")
            statusView.image = UIImage(named: "dong_test.png")
            nameView.textColor = .white
            nameView.backgroundColor = .red
            // 유니폼, 이름(백그라운드), 그림자, 컨디션
            nameView.text = player.name
            
            let pan_gesture = UIPanGestureRecognizer(target: self, action: #selector(playerDragged))
            playerView.addGestureRecognizer(pan_gesture)
            pan_gesture.delegate = self
            
            let tap_gesture = UITapGestureRecognizer(target: self, action: #selector(playerTapped))
            playerView.addGestureRecognizer(tap_gesture)
            tap_gesture.delegate = self
        }
    }
    
    @objc func meneTapped(_ sender: UIMenuItem) {
        
    }
    
    
    @objc func playerTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        
        print("playerTapped")
        
        let playerView = gestureRecognizer.view!
        
        
        let controller = UIMenuController.shared
        let textItem = UIMenuItem(title: "Toggle Color Item") { [weak self] _ in }

        let image = UIImage(named: "jersey_test")
        let imageItem = UIMenuItem(title: "Image", image: image) { [weak self] _ in }

        let colorImage = UIImage(named: "dong_test.png")
        let colorImageItem = UIMenuItem(title: "ColorImage", image: colorImage) { [weak self] _ in }

        controller.menuItems = [textItem, imageItem]
        UIMenuController.installTo(responder: playerView) { action, `default` in
            if action == colorImageItem.action { return true }
            return UIMenuItem.isMenuItemKitSelector(action)
        }
        
        
        controller.showMenu(from: gestureRecognizer.view!, rect: CGRect.zero)

        playerView.becomeFirstResponder()
        

        
        
//        becomeFirstResponder()
//        let zeddMenuItem = UIMenuItem(title: "Zedd", action: #selector(meneTapped))
//        let alanMenuItem = UIMenuItem(title: "Alan Walker", action: #selector(meneTapped))
//        UIMenuController.shared.menuItems = [zeddMenuItem, alanMenuItem]
//        UIMenuController.shared.showMenu(from: gestureRecognizer.view!, rect: CGRect.zero)
        
        
        

        

        
//        let menuController: UIMenuController = UIMenuController.shared
//        menuController.isMenuVisible = true
//        menuController.arrowDirection = UIMenuController.ArrowDirection.default
//        menuController.setTargetRect(CGRect.zero, in: view)
//
//        let menuItem1: UIMenuItem = UIMenuItem(title: "Menu 1", action: #selector(meneTapped))
//        let menuItem2: UIMenuItem = UIMenuItem(title: "Menu 2", action: #selector(meneTapped))
//        let menuItem3: UIMenuItem = UIMenuItem(title: "Menu 3", action: #selector(meneTapped))
//
//        // Store MenuItem in array.
//        let myMenuItems: [UIMenuItem] = [menuItem1, menuItem2, menuItem3]
//
//        // Added MenuItem to MenuController.
//        menuController.menuItems = myMenuItems
        
        
//        let playerView = gestureRecognizer.view!
//        let tag = gestureRecognizer.view?.tag
//        let player_id = players[tag!].id
//        editPlayerName(playerView: playerView, id: player_id)
    }
    
    @objc func playerDragged(_ gestureRecognizer: UIPanGestureRecognizer) {

        if gestureRecognizer.state == UIGestureRecognizer.State.began || gestureRecognizer.state == UIGestureRecognizer.State.changed {

            let translation = gestureRecognizer.translation(in: playersView)
                    
            let view_x = gestureRecognizer.view!.center.x+translation.x
            let view_y = gestureRecognizer.view!.center.y + translation.y
            
            let tag = gestureRecognizer.view?.tag
            try! realm.write {
                players[tag!].x = Float(view_x)
                players[tag!].y = Float(view_y)
            }
            
            gestureRecognizer.view!.center = CGPoint(
                x: view_x,
                y: view_y)
            
            gestureRecognizer.setTranslation(CGPoint(x: 0, y: 0), in: playersView)
        }
    }
    
    
    @objc func editPlayerName(playerView: UIView, id: String) {
        
        let current_player = realm.objects(Player.self).filter("id==%@", id).first!
        
        //
        let name = current_player.name
        
        let alert = UIAlertController(title: "선수이름변경", message: "변경변경", preferredStyle: .alert)
        alert.addTextField { (tf) in
            tf.text = name
        }
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { [weak alert] (_) in
            let playerNameField = alert?.textFields![0] // Force unwrapping because we know it exists.
            let playerName: String = playerNameField!.text!

            try! self.realm.write {
                current_player.name = playerName
            }

//            let nameView: UILabel = playerView.viewWithTag(0) as! UILabel
//            nameView.text = playerName
            
            if let nameView: UILabel = playerView.viewWithTag(0) as? UILabel {
                print("if")
                nameView.text = playerName
            } else {
                print("else")
            }
            
            for view in playerView.subviews {
                if (view.restorationIdentifier == "nameView") {
                    let nameView: UILabel = view as! UILabel
                    nameView.text = playerName
                }
            }

            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func editTeamName() {
        
        let current_team = realm.objects(Team.self).filter("is_current == true").first!
        
        //
        let name = current_team.name
        let memo = current_team.memo
        
        let alert = UIAlertController(title: "title", message: "message", preferredStyle: .alert)
        alert.addTextField { (tf) in
            tf.text = name
        }
        alert.addTextField { (tf) in
            tf.text = memo
        }
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { [weak alert] (_) in
            let teamNameField = alert?.textFields![0] // Force unwrapping because we know it exists.
            let teamMemoField = alert?.textFields![1] // Force unwrapping because we know it exists.
            let teamName: String = teamNameField!.text!
            let teamMemo: String = teamMemoField!.text!
            
            //
            try! self.realm.write {
                current_team.name = teamName
                current_team.memo = teamMemo
            }
            
            self.teamNameLabel.text = teamName
            self.teamMemoLabel.text = teamMemo
            
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func buttonTapGesture(_ gesture: UITapGestureRecognizer){
        print("UIGestureRecognizer : UITapGestureRecognizer")
    }
    
    //
    @IBAction func didTabMenu(_ sender: UIButton) {
        
        let menu = SideMenuNavigationController(rootViewController: self)
        // SideMenuNavigationController is a subclass of UINavigationController, so do any additional configuration
        // of it here like setting its viewControllers. If you're using storyboards, you'll want to do something like:
        // let menu = storyboard!.instantiateViewController(withIdentifier: "RightMenu") as! SideMenuNavigationController
        present(menu, animated: true, completion: nil)
    }
    
    @IBAction func didTabFloating(_ sender: Any) {
//        fpc.show(animated: true) {
//            print("asdf")
//        }
    }
    
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        
    }

    // call before animation
    func circleMenu(_ circleMenu: CircleMenu, buttonWillSelected button: UIButton, atIndex: Int) {
        
    }

    // call after animation
    func circleMenu(_ circleMenu: CircleMenu, buttonDidSelected button: UIButton, atIndex: Int) {
        
    }

    // call upon cancel of the menu - fires immediately on button press
    func menuCollapsed(_ circleMenu: CircleMenu) {
        print("menuCollapsed")
    }

    // call upon opening of the menu - fires immediately on button press
    func menuOpened(_ circleMenu: CircleMenu) {
        print("menuOpened")
    }
}

//class MyFloatingPanelLayout: FloatingPanelLayout {
//    var position: FloatingPanelPosition = .bottom
//
//    var initialState: FloatingPanelState = .tip
//
//    var anchors: [FloatingPanelState : FloatingPanelLayoutAnchoring] = [:]
//
//    public var initialPosition: FloatingPanelPosition {
//        return .bottom
//    }
//
//    public func insetFor(position: FloatingPanelPosition) -> CGFloat? {
//        switch position {
//            case .bottom: return 100.0 // A top inset from safe area
//            case .bottom: return 400.0 // A bottom inset from the safe area
//            case .bottom: return -50.0 // A bottom inset from the safe area
//            default: return nil // Or `case .hidden: return nil`
//        }
//    }
//
//
//}

extension UIViewController {
    
    func createTeam(name: String, memo: String) {
        
        //
        let realm = try! Realm()
        
        //
        let current_team = realm.objects(Team.self).filter("is_current==true").first
        
        if (current_team != nil) {
            try! realm.write {
                current_team!.is_current = false
            }
        }
        
        let team = Team()
        team.name = name
        team.memo = memo
        team.is_current = true
        
        let players = List<Player>()
        print(UIScreen.main.bounds.width)
        for i in 0...10 {
            let player = Player()
            var x, y: Float!
            let width = UIScreen.main.bounds.width
            let sb_y: CGFloat = 0.7
            let sb_x: CGFloat = 0.15
            let cb_y: CGFloat = 0.75
            let cb_x: CGFloat = 0.35
            let dm_x: CGFloat = 0.4
            let dm_y: CGFloat = 0.6
            let am_x: CGFloat = 0.5
            let am_y: CGFloat = 0.4
            let wf_x: CGFloat = 0.2
            let wf_y: CGFloat = 0.3
            let cf_x: CGFloat = 0.5
            let cf_y: CGFloat = 0.2
            let gk_x: CGFloat = 0.5
            let gk_y: CGFloat = 0.9

            if i == 0 {
                x = Float(width*gk_x)
                y = Float(width*gk_y)
            } else if i == 1 {
                x = Float(width*sb_x)
                y = Float(width*sb_y)
            } else if i == 2 {
                x = Float(width*(1-sb_x))
                y = Float(width*sb_y)
            } else if i == 3 {
                x = Float(width*cb_x)
                y = Float(width*cb_y)
            } else if i == 4 {
                x = Float(width*(1-cb_x))
                y = Float(width*cb_y)
            } else if i == 5 {
                x = Float(width*dm_x)
                y = Float(width*dm_y)
            } else if i == 6 {
                x = Float(width*(1-dm_x))
                y = Float(width*dm_y)
            } else if i == 7 {
                x = Float(width*am_x)
                y = Float(width*am_y)
            } else if i == 8 {
                x = Float(width*wf_x)
                y = Float(width*wf_y)
            } else if i == 9 {
                x = Float(width*(1-wf_x))
                y = Float(width*wf_y)
            } else if i == 10 {
                x = Float(width*cf_x)
                y = Float(width*cf_y)
            } else {
                x = Float(width*0.5)
                y = Float(width*0.5)
            }
            player.x = x
            player.y = y
            players.append(player)
        }
        
        team.players = players
        
        try! realm.write {
            realm.add(team)
        }
    }
    
    func showTeamAlert() {
        
        let alert = UIAlertController(title: "title", message: "message", preferredStyle: .alert)
        alert.addTextField { (UITextField) in }
        alert.addTextField { (UITextField) in }
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { [weak alert] (_) in
            let teamNameField = alert?.textFields![0] // Force unwrapping because we know it exists.
            let teamMemoField = alert?.textFields![1] // Force unwrapping because we know it exists.
            let teamName: String = teamNameField!.text!
            let teamMemo: String = teamMemoField!.text!
            
            self.createTeam(name: teamName, memo: teamMemo)
            if let mainVC = self.presentingViewController as? HomeViewController {
                mainVC.updateGround()
            }
            
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
