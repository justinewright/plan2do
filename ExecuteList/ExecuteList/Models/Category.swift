//
//  Category.swift
//  ExecuteList
//
//  Created by Justine Wright on 2021/06/13.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List <Item>()
}
