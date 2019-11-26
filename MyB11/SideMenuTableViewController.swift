//
//  SideMenuTableViewController.swift
//  MyB11
//
//  Created by oognus on 2019/11/17.
//  Copyright © 2019 superjersey. All rights reserved.
//

import UIKit
import RealmSwift

class SideMenuTableViewController: UITableViewController {
    
    @IBOutlet weak var testView: UILabel!
    
    //
    var arr = ["a", "b"]
    var teamList: Results<Team>!
    
    //
    let realm = try! Realm()
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        teamList = realm.objects(Team.self)
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.testView.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        self.testView.addGestureRecognizer(gesture)

    }
    @objc func checkAction(sender : UITapGestureRecognizer) {
        
        showTeamAlert()
        teamList = realm.objects(Team.self)
        self.tableView.reloadData()
        
        
        
        
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
//            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
//            print("Text field: \(textField?.text)")
//        }))
        
        
        
//        // Generate top floating entry and set some properties
//        let minEdge = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
//        //
//        var attributes = EKAttributes.bottomFloat
////        attributes.entryBackground = .gradient(gradient: .init(colors: [EKColor(.red), EKColor(.green)], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
////        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
////        attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
////        attributes.statusBar = .dark
////        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
////        attributes.positionConstraints.maxSize = .init(width: .constant(value: minEdge), height: .intrinsic)
//
//
//        attributes = .float
//        attributes.windowLevel = .normal
//        attributes.position = .top
//        attributes.displayDuration = .infinity
//        attributes.entranceAnimation = .init(
//           translate: .init(
//               duration: 0.65,
//               spring: .init(damping: 0.8, initialVelocity: 0)
//           )
//        )
//        attributes.exitAnimation = .init(
//           translate: .init(
//               duration: 0.65,
//               spring: .init(damping: 0.8, initialVelocity: 0)
//           )
//        )
//        attributes.popBehavior = .animated(
//           animation: .init(
//               translate: .init(
//                   duration: 0.65,
//                   spring: .init(damping: 0.8, initialVelocity: 0)
//               )
//           )
//        )
//        attributes.entryInteraction = .absorbTouches
//        attributes.screenInteraction = .dismiss
//        attributes.entryBackground = .visualEffect(style: .standard)
//        attributes.scroll = .enabled(
//           swipeable: false,
//           pullbackAnimation: .jolt
//        )
//        attributes.statusBar = .light
//        attributes.positionConstraints.keyboardRelation = .bind(
//           offset: .init(
//               bottom: 10,
//               screenEdgeResistance: 5
//           )
//        )
//        attributes.positionConstraints.maxSize = .init(
//           width: .constant(value: minEdge),
//           height: .intrinsic
//        )
//
//
//
//
//        ///
//        let title = EKProperty.LabelContent(
//            text: "Hi there!",
//            style: EKProperty.LabelStyle(
//                font: MainFont.bold.with(size: 16),
//                color: .black)
//        )
//        let description = EKProperty.LabelContent(
//            text: "Are you ready for some testing?",
//            style: EKProperty.LabelStyle(
//                font: MainFont.light.with(size: 14),
//                color: .black
//            )
//        )
//
//        let simpleMessage = EKSimpleMessage(title: title, description: description)
//
//        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
//        let contentView = EKNotificationMessageView(with: notificationMessage)
//        SwiftEntryKit.display(entry: contentView, using: attributes)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return teamList.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        cell.textLabel?.text = teamList[indexPath.row].name

        return cell

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let current_team = realm.objects(Team.self).filter("is_current==true").first
        if (current_team != nil) {
                try! realm.write {
                    current_team!.is_current = false
                }
        }
        
        
        let team = teamList[indexPath.row]
        try! realm.write {
            team.is_current = true
        }
        
        dismiss(animated: true, completion: nil)
        
        if let mainVC = self.presentingViewController as? HomeViewController {
            mainVC.updateGround()
        }
    }
    
    


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
