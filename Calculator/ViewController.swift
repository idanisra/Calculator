//
//  ViewController.swift
//  Calculator Layout iOS13
//
//  Created by Angela Yu on 01/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CalculatorDelegate {
    
    // Private Variables
    
    var calculator = Calculator()
    
    // IBOutlets
    
    @IBOutlet weak var resultLabel: UILabel!
    
    // IBActions
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        calculator.handleSelected(character: sender.titleLabel?.text)
    }
    
    // Private Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculator.delegate = self
    }
    
    internal func didUpdateResult(_ result: String) {
        resultLabel.text = result
    }
    
    internal func calculationError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
