//
//  ViewController.swift
//  TestApp
//
//  Created by Марина Попова on 26/09/2019.
//  Copyright © 2019 Марина Попова. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var textEntry: String = ""
    var dateEntry = Date()
    var dateUpdateEntry = Date()
    
    @IBOutlet weak var textEntryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateUpdateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        textEntryLabel.text = textEntry
        dateLabel.text = "Created: " + dateFormatter.string(from: dateEntry)
        if dateEntry != dateUpdateEntry {
            dateUpdateLabel.text = "Updated: " + dateFormatter.string(from: dateUpdateEntry)
        }
    }

}

