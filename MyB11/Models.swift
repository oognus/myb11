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
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var memo = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    //
    @objc dynamic var stadium: Stadium?
    @objc dynamic var jersey: Jersey?
}

class Player: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var memo = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    //
    @objc dynamic var team: Team?
    @objc dynamic var jersey: Jersey?
    @objc dynamic var condition: Condition?
}

class Stadium: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    //image
    
    //
    override static func primaryKey() -> String? {
        return "id"
    }
}

class Jersey: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    //image
    
    //
    override static func primaryKey() -> String? {
        return "id"
    }
}

class Condition: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    //image
    
    //
    override static func primaryKey() -> String? {
        return "id"
    }
}





