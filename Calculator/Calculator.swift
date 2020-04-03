//
//  Calculator.swift
//  Calculator
//
//  Created by Mohammad Shayan on 4/3/20.
//  Copyright © 2020 Mohammad Shayan. All rights reserved.
//

import Foundation

enum WorkingOn {
    case leftSide
    case rightSide
}

enum Operation: String {
    case add = "+"
    case subtract = "-"
    case multiply = "x"
    case divide = "/"
    case equals = "="
}

struct Calculator {
    
    var current = ""
    var leftSide: Double?
    var rightSide: Double?
    var operation: Operation?
    var result: Double?
    
    var workingOn = WorkingOn.leftSide
    
    var canTakeDecimal: Bool = true
    var canTakeMinus: Bool = true
    
    var newNumberWillClear: Bool = false
    
    mutating func appendNumber(_ number: Int) {
        if newNumberWillClear {
            self.current = String(number)
        } else {
            self.current += String(number)
        }
        newNumberWillClear = false
        updateNumberCurrentlyBeingWorkedOn()
    }
    
    mutating func appendDecimal() {
        guard canTakeDecimal else {
            return
        }
        
        if newNumberWillClear {
            reset()
        }
        self.current += "."
        canTakeDecimal = false
        
    }
    
    mutating func appendOperation(_ operation: Operation) {
        if operation == .subtract && !canTakeMinus {
            return
        }
        
        if operation == .equals {
            doOperation()
            if let result = self.result {
                reset()
                self.current = "\(result)"
                newNumberWillClear = true
                self.leftSide = result
            }
            
        } else {
            
            if self.current != "" {
                
                workOnNextNumber()
                self.current = ""
                self.operation = operation
                
            } else {
                if operation == .subtract {
                    self.current += "-"
                    canTakeMinus = false
                    newNumberWillClear = false
                    updateNumberCurrentlyBeingWorkedOn()
                } else {
                    self.current = ""
                    self.operation = operation
                }
            }
        }
    }
    
    mutating func delete() {
        if newNumberWillClear {
            reset()
        } else {
            let last = self.current.popLast()
            if last == "-" {
                canTakeMinus = true
            } else if last == "." {
                canTakeDecimal = true
            }
            if self.current == "" || self.current == "-" {
                resetWorkingNumber()
            }
            updateNumberCurrentlyBeingWorkedOn()
        }
    }
    
    mutating func updateNumberCurrentlyBeingWorkedOn() {
        
        guard let newNumber = Double(self.current) else {
            return
        }
        
        if self.workingOn == .leftSide {
            self.leftSide = newNumber
        } else {
            self.rightSide = newNumber
        }
    }
    
    mutating func workOnNextNumber() {
        if self.workingOn == .leftSide {
            self.workingOn = .rightSide
        } else {
            doOperation()
            if let result = self.result {
                self.leftSide = result
            }
            self.workingOn = .rightSide
            self.rightSide = nil
        }
        
        self.canTakeMinus = true
        self.canTakeDecimal = true
        self.newNumberWillClear = false
    }
    
    mutating func resetWorkingNumber() {
        if self.workingOn == .leftSide {
            self.leftSide = nil
        } else {
            self.rightSide = nil
        }
    }
    
    mutating func doOperation() {
        guard let leftSide = self.leftSide, let rightSide = self.rightSide, let operation = self.operation else {
            return
        }
        
        switch operation {
        case .add:
            self.result = leftSide + rightSide
            break
        case .subtract:
            self.result = leftSide - rightSide
            break
        case .multiply:
            self.result = leftSide * rightSide
            break
        case .divide:
            self.result = leftSide / rightSide
            break
        default:
            return
        }
    }
    
    mutating func reset() {
        self.leftSide = nil
        self.rightSide = nil
        self.operation = nil
        self.result = nil
        self.current = ""
        self.workingOn = .leftSide
        self.canTakeMinus = true
        self.canTakeDecimal = true
        self.newNumberWillClear = false
    }
    
    func getTextForPlaceholder() -> String {
        var string = ""
        
        if let leftSide = self.leftSide {
            string += String(leftSide)
        }
        if let operation = self.operation {
            string += operation.rawValue
        }
        if let rightSide = self.rightSide {
            string += String(rightSide)
        }
        
        return string
    }
    
}
