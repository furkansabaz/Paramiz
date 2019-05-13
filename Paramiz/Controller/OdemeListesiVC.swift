//
//  OdemeListesiVC.swift
//  Paramiz
//
//  Created by Furkan Sabaz on 12.05.2019.
//  Copyright © 2019 Furkan Sabaz. All rights reserved.
//

import UIKit
import RealmSwift
class OdemeListesiVC: UITableViewController {

    
    
    let realm = try! Realm()
    var odemeListesi : Results<Odeme>?
    var secilenAktivite : Aktivite? {
        didSet {
            odemeleriYukle()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

   

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return odemeListesi?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let hucre = tableView.dequeueReusableCell(withIdentifier: "odemeCell", for: indexPath)
        if let odeme = odemeListesi?[indexPath.row] {
            hucre.textLabel?.text = odeme.odeyeninAdi
        } else {
            hucre.textLabel?.text = "Henüz Eklenen Bir Ödeme Bulunamadı"
        }
        return hucre
    }

    @IBAction func btnOdemeEkleClicked(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Ödeme", message: "Ödeme Ekle", preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField { txtKisiAdi in
            txtKisiAdi.placeholder = "Ödeyen Kişi"
        }
        alertController.addTextField { txtAciklama in
            txtAciklama.placeholder = "Açıklama"
        }
        
        alertController.addTextField { txtUcret in
            txtUcret.placeholder = "Ücret"
            txtUcret.keyboardType = .numberPad
        }
        
        let add = UIAlertAction(title: "Ekle", style: UIAlertAction.Style.default) { action in
            
            let txtKisi = alertController.textFields![0]
            let txtAciklama = alertController.textFields![1]
            let txtUcret = alertController.textFields![2]
            
            
            if let secilenAktivite = self.secilenAktivite {
                do {
                    try self.realm.write {
                        let yeniOdeme = Odeme()
                        yeniOdeme.odeyeninAdi = txtKisi.text ?? "Girilmedi"
                        yeniOdeme.aciklama = txtAciklama.text ?? "Girilmedi"
                        yeniOdeme.miktar = Int(txtUcret.text ?? "-1")!
                        secilenAktivite.odemeler.append(yeniOdeme)
                    }
                } catch {
                    print("Ödeme Eklerken Hata Meydana Geldi : \(error.localizedDescription)")
                }
                
            }
            self.tableView.reloadData()
        }
        
        alertController.addAction(add)
        present(alertController, animated: true, completion: nil)
        
    }
    
    func odemeleriYukle() {
        
        odemeListesi = secilenAktivite?.odemeler.sorted(byKeyPath: "odeyeninAdi", ascending: true)
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "odemeDuzenleSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "odemeDuzenleSegue" {
            
            let hedefVC = segue.destination as! OdemeDuzenleVC
            
            if let seciliIndex = tableView.indexPathForSelectedRow {
                
                if let secilenOdeme = odemeListesi?[seciliIndex.row] {
                    
                    hedefVC.secilenOdeme = secilenOdeme
                    hedefVC.title = "\(secilenOdeme.odeyeninAdi) Ödeme Bilgileri"
                }
            }
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
}
