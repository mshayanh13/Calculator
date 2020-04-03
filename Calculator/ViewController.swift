//
//  ViewController.swift
//  Calculator
//
//  Created by Mohammad Shayan on 4/3/20.
//  Copyright © 2020 Mohammad Shayan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var currentTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var topView: UIView!
    
    var calculator: Calculator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calculator = Calculator()
        reset()
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: Selector(("clearAll:")))
        deleteButton.addGestureRecognizer(longPressGesture)
    }
    
    @IBAction func numberOrDecimalButtonPressed(_ sender: UIButton) {
        
        if sender.tag == 10 {
            calculator.appendDecimal()
        } else {
            calculator.appendNumber(sender.tag)
        }
        updateCurrent()
        
    }
    
    @IBAction func operationButtonPressed (_ sender: UIButton) {
        
        var operation: Operation
        
        let tag = sender.tag
        
        if tag == 1 {
            operation = .add
        } else if tag == 2 {
            operation = .subtract
        } else if tag == 3 {
            operation = .multiply
        } else if tag == 4 {
            operation = .divide
        } else {
            operation = .equals
        }
        
        calculator.appendOperation(operation)
        updateCurrent()
    }
    
    @IBAction func deleteButtonPressed (_ sender: UIButton) {
        
        calculator.delete()
        updateCurrent()
    }
    
    @objc func clearAll(_ sender: UIGestureRecognizer) {
        if sender.state == .began {
            UIView.animate(withDuration: 0.7, delay: 0.0, options: [.autoreverse], animations: {
                self.topView.backgroundColor = UIColor.black
            }) { _ in
                self.topView.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.7803921569, blue: 0.3490196078, alpha: 1)
            }
            reset()
        }
        
    }
    
    func updateCurrent() {
        
        if let current = calculator.current.convertFromDoubleToCleanString() {
            currentTextField.text = current
        } else {
            currentTextField.text = calculator.current
        }
        if let text = calculator.getTextForPlaceholder().convertFromDoubleToCleanString() {
            resultLabel.text = text
        } else {
            resultLabel.text = calculator.getTextForPlaceholder()
        }
    }
    
    func reset() {
        calculator.reset()
        resultLabel.text = ""
        updateCurrent()
    }

}

