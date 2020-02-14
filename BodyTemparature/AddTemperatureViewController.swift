//
//  AddTemperatureViewController.swift
//  BodyTemparature
//
//  Created by Kyle on 2020/2/14.
//  Copyright © 2020 Cyan Maple. All rights reserved.
//

import UIKit

class AddTemperatureViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var textField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            if let temperature = Double(text) {
                print(String(describing: temperature))
                self.dismiss(animated: true, completion: nil)
                performSegue(withIdentifier: "unwindToTVC", sender: self)
            }
        }
    }
    
}
