//
//  Category.swift
//  Todoey
//
//  Created by Marisha Deroubaix on 17/07/18.
//  Copyright © 2018 Marisha Deroubaix. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
  @objc dynamic var name: String = ""
  @objc dynamic var colour: String = ""
  let items = List<Item>()
  
  
}
