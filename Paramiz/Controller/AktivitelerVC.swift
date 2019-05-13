//
//  AktivitelerVC.swift
//  Paramiz
//
//  Created by Furkan Sabaz on 1.05.2019.
//  Copyright © 2019 Furkan Sabaz. All rights reserved.
//

import UIKit
import RealmSwift
class AktivitelerVC: UITableViewController {

    
   
    var aktivitelerListesi : Results<Aktivite>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        verileriYukle()
        
    }

   

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return aktivitelerListesi?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "aktiviteCell")
        //let cell = tableView.dequeueReusableCell(withIdentifier: "aktiviteCell", for: indexPath)
        cell.textLabel?.text = aktivitelerListesi?[indexPath.row].Adi ?? "Aktivite Bulunamadı"
        
        if aktivitelerListesi?[indexPath.row].Bittimi ?? false {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       /*
        aktivitelerListesi[indexPath.row].Bittimi = !aktivitelerListesi[indexPath.row].Bittimi
        
       
        if secilenHucre?.accessoryType == UITableViewCell.AccessoryType.checkmark {
            secilenHucre?.accessoryType = .none
        } else {
            secilenHucre?.accessoryType = .checkmark
        }
 
        tableView.reloadData()//cellForRowAt metodu tekrar çalışacak ve bütün satırlar yeniden oluşacak
        */
        
        performSegue(withIdentifier: "odemeListesiSegue", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "odemeListesiSegue" {
            
            let hedefVC = segue.destination as! OdemeListesiVC
            
            if let seciliIndex = tableView.indexPathForSelectedRow {
                hedefVC.secilenAktivite = aktivitelerListesi?[seciliIndex.row]
            }
            
        }
        
        
    }
    @IBAction func btnAktiviteEkle(_ sender: UIBarButtonItem) {
    
        let alertController = UIAlertController(title: "Aktivite Ekle", message: "Eklemek İstediğiniz Aktivite", preferredStyle: .alert)
        alertController.addTextField { txtAktiviteAdi in
            txtAktiviteAdi.placeholder = "Aktivite Adı"
        }
        
        let ekleAction = UIAlertAction(title: "Ekle", style: .default) { action in
            let txtAktiviteAdi = alertController.textFields![0]
            
            if !txtAktiviteAdi.text!.isEmpty {
                let a1 = Aktivite()
                a1.Adi = txtAktiviteAdi.text!
                self.verileriKaydet(aktivite: a1)
                self.tableView.reloadData()
            }
            
        }
        alertController.addAction(ekleAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    func verileriKaydet(aktivite : Aktivite) {
        do {
            try realm.write {
                realm.add(aktivite)
            }
        }catch {
            
        }
    }
    
    func verileriYukle() {
        aktivitelerListesi = realm.objects(Aktivite.self)
        tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            if let silinecekAktivite = aktivitelerListesi?[indexPath.row] {
                
                do {
                    
                    try realm.write {
                        realm.delete(silinecekAktivite.odemeler)
                        realm.delete(silinecekAktivite)
                    }
                    
                } catch {
                    print("Aktiviteyi Silerken Hata Meydana Geldi : \(error.localizedDescription)")
                }
                
            }
            
            
        }
        tableView.reloadData()
    }
    
   
}
