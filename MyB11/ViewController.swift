//
//  ViewController.swift
//  MyB11
//
//  Created by oognus on 2019/11/15.
//  Copyright © 2019 superjersey. All rights reserved.
//

import UIKit
import SideMenu

class ViewController: UIViewController {
    
    let transition = SlideTransition()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    @IBAction func didTabMenu(_ sender: UIButton) {
        print("asdf")
        
        
        guard let menuViewController = storyboard?.instantiateViewController(identifier: "MenuViewController") else { return }
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        present(menuViewController, animated: true)
    }
    
}

extension ViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}

