//
//  SomCalculator.swift
//  Calculator
//
//  Created by Aaik Oosters on 06-12-15.
//  Copyright © 2015 Aaik Oosters. All rights reserved.
//

import UIKit

class SomCalculator: UIViewController {
    
    var brain = CalculatorBrain()
    
    @IBOutlet weak var showSomTextView: UITextView! {
        didSet {
            showSomTextView.text = "Welkom"
//            updateUI()
        }
    }
    
    
    func updateUI() {
        let result = brain.getAll()
        showSomTextView.text = result
    }
    

    
    
    
    
}