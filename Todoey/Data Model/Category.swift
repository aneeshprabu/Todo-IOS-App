//
//  Category.swift
//  Todoey
//
//  Created by Aneesh Prabu on 05/07/19.
//  Copyright © 2019 Aneesh Prabu. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    
    /*
     Forward relationship
     */
    //let array : Array<Int> = [1,2,3] or let array : [Int] = [1,2,3] or let array = Array<Int>()
    let items = List<Item>()
}
