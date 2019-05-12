//
//  Aktivite.swift
//  Paramiz
//
//  Created by Furkan Sabaz on 2.05.2019.
//  Copyright © 2019 Furkan Sabaz. All rights reserved.
//

import Foundation
import RealmSwift
class Aktivite : Object {
    @objc dynamic var Adi : String = ""
    @objc dynamic var Bittimi : Bool = false
    let odemeler = List<Odeme>()
}
