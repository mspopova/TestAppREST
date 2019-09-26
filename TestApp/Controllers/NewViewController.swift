//
//  NewViewController.swift
//  TestApp
//
//  Created by Марина Попова on 26/09/2019.
//  Copyright © 2019 Марина Попова. All rights reserved.
//

import UIKit

class NewViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    let netManager = NetworkManager()

    let queue = DispatchQueue.global(qos: .utility)
    
    @IBAction func createEntry() {
        let text = textView.text
        netManager.makeEntry(text: text)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
    }
}

// MARK: - UITextViewDelegate
extension NewViewController: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
         if(text == "\n") {
             textView.resignFirstResponder()
             return false
         }
         return true
     }
}
