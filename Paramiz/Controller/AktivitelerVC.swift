//
//  AktivitelerVC.swift
//  Paramiz
//
//  Created by Furkan Sabaz on 1.05.2019.
//  Copyright © 2019 Furkan Sabaz. All rights reserved.
//

import UIKit
import RealmSwift
class AktivitelerVC: UITableViewController , UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
   
    var aktivitelerListesi : Results<Aktivite>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        verileriYukle()
        searchBar.delegate = self
        
    }

   

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return aktivitelerListesi?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "aktiviteCell")
       
        let sonuc : Int  = aktivitelerListesi?[indexPath.row].odemeler.sum(ofProperty: "miktar") ?? 0
        
        if let adi = aktivitelerListesi?[indexPath.row].Adi {
            cell.textLabel?.text = "\(adi) - \(sonuc)"
        } else {
            cell.textLabel?.text = "Aktivite Bulunamadı"
        }
        
        if aktivitelerListesi?[indexPath.row].Bittimi ?? false {
            cell.backgroundColor = UIColor.darkGray
            cell.textLabel?.textColor = UIColor.white
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
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Çalıştı")
        aktivitelerListesi = aktivitelerListesi?.filter("Adi CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "Adi", ascending: true)
        tableView.reloadData()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            verileriYukle() // kullanıcının girdiği bir değer yok o zaman tüm verileri yükle
            DispatchQueue.main.async {
                searchBar.resignFirstResponder() // kullanıcı tüm değerleri sildiğinde klavye yok olacak.
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let silme = UITableViewRowAction(style: UITableViewRowAction.Style.default, title: "Sil") { (action, indexPath) in
            if let silinecekAktivite = self.aktivitelerListesi?[indexPath.row] {
                
                do {
                    
                    try self.realm.write {
                        self.realm.delete(silinecekAktivite.odemeler)
                        self.realm.delete(silinecekAktivite)
                    }
                    
                } catch {
                    print("Aktiviteyi Silerken Hata Meydana Geldi : \(error.localizedDescription)")
                }
                
            }
            tableView.reloadData()
        }
        
        let odesme = UITableViewRowAction(style: UITableViewRowAction.Style.normal, title: "Ödeştik") { (action, indexPath) in
            
            if let aktivite = self.aktivitelerListesi?[indexPath.row] {
                do {
                    
                    try self.realm.write {
                        aktivite.Bittimi = true
                        print("Aktivitede Ödeşme Yapıldı")
                    }
                    
                } catch {
                    print("Ödeşmede Hata Meydana Geldi : \(error.localizedDescription)")
                }
                
            }
            tableView.reloadData()
        }
        
        odesme.backgroundColor = .green
        return [odesme,silme]
    }
}
