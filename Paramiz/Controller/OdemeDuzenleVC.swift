//
//  OdemeDuzenleVC.swift
//  Paramiz
//
//  Created by Furkan Sabaz on 13.05.2019.
//  Copyright © 2019 Furkan Sabaz. All rights reserved.
//

import UIKit
import RealmSwift
class OdemeDuzenleVC: UIViewController {

    
    var secilenOdeme : Odeme?
    let realm = try! Realm()
    
    @IBOutlet weak var txtOdemeKisiAdi: UITextField!
    @IBOutlet weak var txtAciklama: UITextField!
    @IBOutlet weak var txtUcret: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gorunumuAyarla()
    }
    
    @IBAction func btnGuncelleClicked(_ sender: Any) {
        
        if let secilenOdeme = secilenOdeme {
            do {
                try realm.write {
                    secilenOdeme.odeyeninAdi = txtOdemeKisiAdi.text!
                    secilenOdeme.aciklama = txtAciklama.text!
                    secilenOdeme.miktar = Int((txtUcret.text)!)!
                    print("Ödeme Başarıyla Güncellendi")
                }
            } catch {
                print("Ödeme Güncellenirken Hata Meydana Geldi : \(error.localizedDescription)")
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    func gorunumuAyarla() {
        txtOdemeKisiAdi.text = secilenOdeme?.odeyeninAdi
        txtAciklama.text = secilenOdeme?.aciklama
        txtUcret.text = "\(secilenOdeme!.miktar)"
    }
    
}
