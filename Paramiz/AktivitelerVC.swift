//
//  AktivitelerVC.swift
//  Paramiz
//
//  Created by Furkan Sabaz on 1.05.2019.
//  Copyright © 2019 Furkan Sabaz. All rights reserved.
//

import UIKit

class AktivitelerVC: UITableViewController {

    
    var aktivitelerListesi = ["Ev","Kapadokya Gezisi","İstanbul Gezisi","Okul Arkadaşları"]
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

   

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return aktivitelerListesi.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "aktiviteCell")
        cell.textLabel?.text = aktivitelerListesi[indexPath.row]
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let secilenHucre = tableView.cellForRow(at: indexPath)
       
        if secilenHucre?.accessoryType == UITableViewCell.AccessoryType.checkmark {
            secilenHucre?.accessoryType = .none
        } else {
            secilenHucre?.accessoryType = .checkmark
        }
        
        
    }
    

   
}
