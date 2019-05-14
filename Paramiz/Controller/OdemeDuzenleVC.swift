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
    var secilenAktivite : Aktivite?
    let realm = try! Realm()
    
    @IBOutlet weak var txtOdemeKisiAdi: UITextField!
    @IBOutlet weak var txtAciklama: UITextField!
    @IBOutlet weak var txtUcret: UITextField!
    @IBOutlet weak var lblAktiviteAdi: UILabel!
    
    @IBOutlet weak var lblToplamOdeme: UILabel!
    
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
        
        
        
        lblAktiviteAdi.text = "Aktivite Adı : \(secilenAktivite!.Adi)"
        
        let toplamOdeme = secilenAktivite?.odemeler.filter("odeyeninAdi == %@",secilenOdeme!.odeyeninAdi).sum(ofProperty: "miktar") ?? 0
        lblToplamOdeme.text = "Yaptığı Toplam Ödeme : \(toplamOdeme) Lira"
        
        
        
        var verim = NSMutableAttributedString(string: "Aktivite Adı : ", attributes: [NSMutableAttributedString.Key.font : UIFont.systemFont(ofSize: 18)])
        verim.append(NSAttributedString(string: "\(secilenAktivite!.Adi)", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 19), NSAttributedString.Key.foregroundColor : UIColor.red]))
        lblAktiviteAdi.attributedText = verim
        
        verim = NSMutableAttributedString(string: "Yaptığı Toplam Ödeme : ", attributes: [NSMutableAttributedString.Key.font : UIFont.systemFont(ofSize: 18)])
        verim.append(NSAttributedString(string: "\(toplamOdeme)", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 19), NSAttributedString.Key.foregroundColor : UIColor.red]))
        lblToplamOdeme.attributedText = verim
        
        
        
    }
    
}
