//
//  PanelViewController.swift
//  MyB11
//
//  Created by oognus on 2019/11/20.
//  Copyright © 2019 superjersey. All rights reserved.
//

import UIKit
import SnapKit

protocol TestDelegate {
    func didPressButton()
}


class PanelViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var delegate:TestDelegate!
    var collectionView: UICollectionView!
    var headerCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .black
        
        let testButton = UIButton()
        self.view.addSubview(testButton)
        testButton.setTitle("test", for: .normal)
        testButton.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
        }
    
        testButton.addTarget(self, action: #selector(pressed(sender:)), for: .touchUpInside)
        
        //
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 100) //add your height here

        

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "testCell")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView")

        self.view.addSubview(collectionView)
        
        
        collectionView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.view)
        }
        
        let headerLayout = UICollectionViewFlowLayout.init()
        headerLayout.scrollDirection = .horizontal
        
        headerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: headerLayout)
        headerCollectionView.delegate = self
        headerCollectionView.dataSource = self
        headerCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "headerCell")
        
        
    }
    
    @objc func pressed(sender: UIButton!) {
        print("asdjfajsf;")
        delegate.didPressButton()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (collectionView == self.collectionView) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "testCell", for: indexPath)
            cell.backgroundColor = .white
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headerCell", for: indexPath)
            cell.backgroundColor = .white
            return cell
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionFooter) {
            print("저기")
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CartFooterCollectionReusableView", for: indexPath)
            return footerView
        } else if (kind == UICollectionView.elementKindSectionHeader) {
            print("요기")
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView", for: indexPath)
            
            headerView.addSubview(headerCollectionView)
            
            headerCollectionView.snp.makeConstraints { (make) in
                make.top.left.right.bottom.equalTo(headerView)
            }
            
            
            return headerView
        }
        fatalError()
    }

    
}
