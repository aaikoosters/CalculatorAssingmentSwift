
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
    @IBOutlet weak var somDisplay: UILabel!
    
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
    
    var displaySomValue: Double {
        get {
            return NSNumberFormatter().numberFromString(somDisplay.text!)!.doubleValue
        } set {
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
        let resultStr = brain.performOperation(operation)
            if let result = resultStr.result {
                displayValue = result
        }
        if let som = resultStr.description {
            somDisplay.text = som
        }         else {
            displayValue = 0
        }
        
    }
    
    
    var memValue = Double()
    var geheugen = Double()
    
    @IBAction func memory(sender: UIButton) {
        /*
        Als Mc is gedrukt: dan memoryValue is 0
        Als M+ is gedrukt: dan displayValue opslaan in memoryValue
        Als M is gedrukt: memoryValue weergeven
        */
        let operation = sender.currentTitle!
        
        switch operation {
            case "MC":
                memValue = 0
                display.text! = String(memValue)
            case "M+":
                memValue = Double(display.text!)!
                geheugen = memValue
                setValueForAs(memValue)
            case "M":
                display.text! = String(memValue)
        default: break
        }
        userTyped = false
        
    }
    
    func setValueForAs(let getalM: Double?) {
        brain.setValueForGo("M", value: getalM!)
        let resultString = brain.evaluate()
        if let result = resultString.result {
            displayValue = result
            print("dit is eeen fackingg result jaaaaa", result)
        }
        if let test = resultString.description {
            somDisplay.text = test
            print("dit is eeen fackingg testttt jaaaaa", test)
        }
    }
    
    @IBAction func pushTableValue()
    {
        brain.setValueForGo("GO", value: displayValue)
        
        let resultString = brain.evaluate()
        
        if let result = resultString.result
        {
            displayValue = result
        }
        if let text = resultString.description
        {
            somDisplay.text = text
        }
    }

    
    
    // Door middel van '\()' kan je argumenten in een string opnemen
    @IBAction func enter() {
        userTyped = false
        pointTyped = false
        if let result = brain.pushOperand(displayValue) {
            somDisplay.text! += "\(result), "
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    @IBAction func clear(sender: UIButton) {
        userTyped = false
        if sender.currentTitle! == "←" {
            let result = brain.clearAll()
            displaySomValue = result
            somDisplay.text! = "0"
        } else {
            somDisplay.text! = brain.getAll()!
            let result = brain.removeOperand(displayValue)
            displayValue = result
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let GraphicController = segue.destinationViewController as? GraphicViewController {
            if let identifier = segue.identifier {
                if identifier == "graphic" {
                    GraphicController.brain = brain
                }
            }
        }
    }
}

