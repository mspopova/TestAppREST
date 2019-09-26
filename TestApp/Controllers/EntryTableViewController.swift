//
//  EntryTableViewController.swift
//  TestApp
//
//  Created by Марина Попова on 26/09/2019.
//  Copyright © 2019 Марина Попова. All rights reserved.
//
import UIKit
import Network

class EntryTableViewController: UITableViewController{
    
    var entries = [Entry]()
    var textEntry = String()
    var dateEntry = Date()
    var dateUpdateEntry = Date()
    
    var networkManager = NetworkManager()
    let monitor = NWPathMonitor()
    
    @IBAction func saveAction(unwindSegue: UIStoryboardSegue) {
            self.getNewEntries()
    }
    @IBAction func unwindAction(unwindSegue: UIStoryboardSegue) {
    }
    
       override func viewDidLoad() {
        super.viewDidLoad()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("Connected")
                self.networkManager.checkUserSession()
                self.getNewEntries()
                DispatchQueue.main.async {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                }
                
            } else {
                DispatchQueue.main.async {
                    self.showError()
                    self.navigationItem.rightBarButtonItem?.isEnabled = false
                }
                print("No connection")
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        
    
    }
    
    func getNewEntries() {
        DispatchQueue.global().async {
            self.networkManager.getEntries() { [weak self] entries in
                guard let selfie = self else { return }
                DispatchQueue.main.async {
                    if let entries = entries {
                        selfie.entries = entries
                        selfie.tableView.reloadData()
                    }
                    else {
                        DispatchQueue.main.async {
                            selfie.showError()
                        }
                    }
                }
            }
        }

    }
    
    func showError() {
           let alter = UIAlertController(title: "Ошибка", message: "Отсутствует соединение", preferredStyle: .alert)
           let action = UIAlertAction(title: "Обновить данные", style: .cancel, handler: { (alertAction) in
           self.getNewEntries()
           })
           alter.addAction(action)
           present(alter, animated: true, completion: nil)
       }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return entries.count
        }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EntryTableViewCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        cell.dateLabel.text = "Created: " + dateFormatter.string(from: entries[indexPath.row].da)
        if entries[indexPath.row].da != entries[indexPath.row].dm {
            cell.dateUpdateLabel.text = "Updated: " + dateFormatter.string(from: entries[indexPath.row].dm)
        }
        cell.entryLabel?.text = String(entries[indexPath.row].body.prefix(200))
        return cell
        }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewEntry" {
            let entryViewController = segue.destination as! ViewController
            if let indexPath = self.tableView.indexPathForSelectedRow {
                textEntry = entries[indexPath.row].body
                dateEntry = entries[indexPath.row].da
                dateUpdateEntry = entries[indexPath.row].dm
                entryViewController.textEntry = self.textEntry
                entryViewController.dateEntry = dateEntry
                entryViewController.dateUpdateEntry = dateUpdateEntry
                }
            }
        }
}
