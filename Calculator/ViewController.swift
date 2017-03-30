//
//  ViewController.swift
//  Calculator
//
//  Created by Vatsal Rustagi on 3/6/17.
//  Copyright © 2017 Calc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var userInTheMiddleOfTyping = false
    var decimalButtonAlreadyPressed = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if(userInTheMiddleOfTyping)
        {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        }
        else{
            display.text = digit
            userInTheMiddleOfTyping = true
        }
    }
    
    var displayValue: Double{
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
            descriptionLabel.text = brain.getDescription()
        }
    }
    
    private var brain: CalculatorBrain = CalculatorBrain()
    
    @IBAction func decimalButton(_ sender: UIButton){
        if !decimalButtonAlreadyPressed
        {
            display.text = "0" + sender.currentTitle!
            decimalButtonAlreadyPressed = true
            userInTheMiddleOfTyping = true
        }
    }
    
    @IBAction func clearButton(_ sender: UIButton) {
        brain.clear()
        displayValue = 0;
        userInTheMiddleOfTyping = false
        decimalButtonAlreadyPressed = false
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userInTheMiddleOfTyping{
            brain.setOperand(displayValue)
            userInTheMiddleOfTyping = false
            decimalButtonAlreadyPressed = false
        }
        
        
        if let mathSymbol = sender.currentTitle{
                brain.performOperation(mathSymbol)
        }
        
        if let result = brain.result{
            displayValue = result
        }
    }

}

