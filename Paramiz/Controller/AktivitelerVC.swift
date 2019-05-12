//
//  AktivitelerVC.swift
//  Paramiz
//
//  Created by Furkan Sabaz on 1.05.2019.
//  Copyright © 2019 Furkan Sabaz. All rights reserved.
//

import UIKit

class AktivitelerVC: UITableViewController {

    
    var veriler = UserDefaults.standard
    //var aktivitelerListesi = ["Ev","Kapadokya Gezisi","İstanbul Gezisi","Okul Arkadaşları"]
    var aktivitelerListesi = [Aktivite]()
    let plistDosyaAdi : String  = "AktivitelerListesi.plist"
    let dosyaYolu = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("AktivitelerListesi.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
       
        
        
        let a1 = Aktivite()
        a1.Adi = "Ev"
        a1.Bittimi = true
        aktivitelerListesi.append(a1)
        let a2 = Aktivite()
        a2.Adi = "Kapadokya Gezisi"
        aktivitelerListesi.append(a2)
        let a3 = Aktivite()
        a3.Adi = "İstanbul Gezisi"
        aktivitelerListesi.append(a3)
        let a4 = Aktivite()
        a4.Adi = "Okul Arkadaşları"
        a4.Bittimi = true
        aktivitelerListesi.append(a4)
        
        
        
        verileriYukle()
        //if let aktivitiler = veriler.array(forKey: "AktivitelerListesi") as? [Aktivite] {
        //    aktivitelerListesi = aktivitiler
        //}
        
        
    }

   

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return aktivitelerListesi.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "aktiviteCell")
        //let cell = tableView.dequeueReusableCell(withIdentifier: "aktiviteCell", for: indexPath)
        cell.textLabel?.text = aktivitelerListesi[indexPath.row].Adi
        
        if aktivitelerListesi[indexPath.row].Bittimi {
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
                self.aktivitelerListesi.append(a1)
                //self.veriler.set(self.aktivitelerListesi, forKey: "AktiviteListesi")
                self.verileriKaydet()
                self.tableView.reloadData()
            }
            
        }
        alertController.addAction(ekleAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    //verileri plist'e kaydeder
    func verileriKaydet() {
        do {
            let data = try PropertyListEncoder().encode(self.aktivitelerListesi)
            try data.write(to: self.dosyaYolu)
        }catch {
            print("Veriler Kaydedilirken Hata Meydana Geldi : \(error.localizedDescription)")
        }
    }
    
    //Verileri Plist'ten çeker
    func verileriYukle() {
        
        
        if let veri = try? Data(contentsOf: dosyaYolu) {
            do {
                
                aktivitelerListesi = try PropertyListDecoder().decode([Aktivite].self, from: veri)
                
            } catch {
                print("Verileri Getirirken Hata Meydana Geldi : \(error.localizedDescription)")
            }
        }
    }
    
    

   
}
