//
//  Kisi.swift
//  Paramiz
//
//  Created by Furkan Sabaz on 12.05.2019.
//  Copyright © 2019 Furkan Sabaz. All rights reserved.
//

import Foundation
import RealmSwift


class Kisi : Object {
    @objc dynamic var adi : String = ""
    @objc dynamic var soyadi : String = ""
    @objc dynamic var yasi : Int = 1
}
