//
//  Odeme.swift
//  Paramiz
//
//  Created by Furkan Sabaz on 13.05.2019.
//  Copyright © 2019 Furkan Sabaz. All rights reserved.
//

import Foundation
import RealmSwift


class Odeme : Object {
    @objc dynamic var odeyeninAdi : String = ""
    @objc dynamic var aciklama : String  = ""
    @objc dynamic var miktar : Int = -1
    var aktivite = LinkingObjects(fromType: Aktivite.self, property: "odemeler")
    
}
