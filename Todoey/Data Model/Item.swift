//
//  Item.swift
//  Todoey
//
//  Created by Aneesh Prabu on 05/07/19.
//  Copyright © 2019 Aneesh Prabu. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    /*
     Backward relationship
     */
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
