//
//  models.swift
//  MyB11
//
//  Created by oognus on 2019/11/19.
//  Copyright © 2019 superjersey. All rights reserved.
//

import Foundation
import RealmSwift


// name, memo

// foreign_key - jersey_id, stadium_id
class Team: Object {

    override static func primaryKey() -> String? {
        return "id"
    }
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var memo = ""
    @objc dynamic var is_current = false

    //
    @objc dynamic var stadium: Stadium?
    @objc dynamic var jersey: Jersey?
    var players = List<Player>()
}

class Player: Object {
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var memo = ""
    @objc dynamic var x: CGFloat = 0
    @objc dynamic var y: CGFloat = 0
    
    //
    @objc dynamic var team: Team?
    @objc dynamic var jersey: Jersey?
    @objc dynamic var condition: Condition?
}

class Stadium: Object {
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var image_nm = ""
    
    //
    
}

class Jersey: Object {
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var image_nm = ""
    
    //
    
}

class Condition: Object {
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var image_nm = ""
    
    //
    
}





