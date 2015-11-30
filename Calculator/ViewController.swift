
//
//  ViewController.swift
//  Calculator
//
//  Created by Aaik Oosters on 16-11-15.
//  Copyright © 2015 Aaik Oosters. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    // Door output na = weet ie welk type het is dus :Bool hoeft niet meer
    var userTyped = false
    var pointTyped = false
    var brain = CalculatorBrain()
    
  
    @IBAction func appendDigit(sender: UIButton)
    {
        let digit = sender.currentTitle!
        
        if userTyped {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userTyped = true
        }
    }
    
    var displayValue : Double
        {
        get{
            print(display.text!)
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
            userTyped = false
        }
    }
  
    
    @IBAction func pointer(sender: UIButton) {
        
        if !pointTyped {
            if userTyped {
                display.text = display.text! + "." }
            else {
                display.text = "."
                userTyped = true
            }
            pointTyped = true
        }
    }

    @IBAction func operate(sender: UIButton) {
        if userTyped {
            enter()
            userTyped = false
            let sting = String(displayValue)
            brain.performOperation(sting)
        }
        let operation = sender.currentTitle!
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        
    }
    
    // Door middel van '\()' kan je argumenten in een string opnemen
    @IBAction func enter() {
        userTyped = false
        pointTyped = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    @IBAction func clear() {
        userTyped = false
        let result = brain.removeOperand(displayValue)
        displayValue = result
    }
}

