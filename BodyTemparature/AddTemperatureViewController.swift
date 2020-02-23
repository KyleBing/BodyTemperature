//
//  AddTemperatureViewController.swift
//  BodyTemparature
//
//  Created by Kyle on 2020/2/14.
//  Copyright © 2020 Cyan Maple. All rights reserved.
//

import UIKit

class AddTemperatureViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var textField: UITextField!{
        didSet{
            textField.delegate = self
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "当前体温"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.removeFromParent()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            if let temperature = Double(text) {
                print(String(describing: temperature))
                performSegue(withIdentifier: "unwindToTVC", sender: self)
            }
        }
    }
    
}
