//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Vatsal Rustagi on 3/16/17.
//  Copyright © 2017 Calc. All rights reserved.
//

import Foundation

struct CalculatorBrain{
    
    // Operation enum, defines the operation type
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double)-> Double, (String)->String)
        case binaryOperation((Double, Double) -> Double, (String, String)->String, Precedence)
        case equals
    }
    
    private enum Precedence: Int{
        case Max = 1
        case Min = 0
    }
    
    private struct PendingBinaryOperation{
        let function: (Double, Double) -> Double
        let firstOperand: Double
        let descriptionFunc: (String, String) -> String
        let descriptionOperand: String
        
        func perform(with secondOperation: Double)-> Double{
            return function(firstOperand, secondOperation)
        }
        func updateDescription(with secondDescriptionOperand: String)-> String{
            return descriptionFunc(descriptionOperand, secondDescriptionOperand)
        }
    }
    
    private var accumalator: Double?
    private var isPending: Bool{
        get{
            return pendingBinaryOperation != nil
        }
    }
    private var descriptionAccumalator = "0" {
        didSet{
            if pendingBinaryOperation != nil{
                currentPrecedence = Precedence.Max
            }
        }
    }
    private var pendingBinaryOperation: PendingBinaryOperation?
    private var operations: Dictionary<String, Operation> =
        [
            "π": Operation.constant(Double.pi),
            "e": Operation.constant(M_E),
            "√": Operation.unaryOperation(sqrt, {"√(\($0))"}),
            "cos": Operation.unaryOperation(cos, {"cos(\($0))"}),
            "±" : Operation.unaryOperation({-$0}, {"-(\($0))"}),
            "x" : Operation.binaryOperation({$0*$1}, {"\($0) * \($1)"}, Precedence.Max),
            "/" : Operation.binaryOperation({$0/$1}, {"\($0) / \($1)"}, Precedence.Max),
            "+" : Operation.binaryOperation({$0+$1}, {"\($0) + \($1)"}, Precedence.Min) ,
            "-" : Operation.binaryOperation({$0-$1}, {"\($0) - \($1)"}, Precedence.Min),
            "=" : Operation.equals,
            "sin": Operation.unaryOperation(sin, {"sin(\($0))"})
    ]
    
    var description : String{
        get {
            if !isPending {
                return descriptionAccumalator
            } else {
                return pendingBinaryOperation!.descriptionFunc(pendingBinaryOperation!.descriptionOperand,
                                                                   pendingBinaryOperation!.descriptionOperand !=
                                                                    descriptionAccumalator ? descriptionAccumalator : "")
            }
        }
    }
    
    var result: Double?{
        get{
            return accumalator
        }
    }
    
    private var currentPrecedence = Precedence.Max

    // Functions that clears everything or resets everything
    mutating func clear()
    {
        accumalator = 0
        pendingBinaryOperation = nil
        descriptionAccumalator = "0"
    }
    
    // Performs operation based on type of operation: constant, unaryOperation, binaryOperation, equals
    mutating func performOperation(_ symbol: String)
    {
        if let operation = operations[symbol]{
            switch operation {
            case .constant(let value):
                accumalator = value
                descriptionAccumalator = symbol
            case .unaryOperation(let function, let descriptionFunction):
                if accumalator != nil{
                    accumalator = function(accumalator!)
                    descriptionAccumalator = descriptionFunction(descriptionAccumalator)
                }
            case .binaryOperation(let function, let descriptionFunction, let precedence):
                performPendingBinaryOperation()
                if currentPrecedence.rawValue < precedence.rawValue {
                    descriptionAccumalator = "(\(descriptionAccumalator))"
                }
                currentPrecedence = precedence
                if accumalator != nil{
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumalator!,
                                                                    descriptionFunc: descriptionFunction, descriptionOperand: descriptionAccumalator)
                    accumalator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    private mutating func performPendingBinaryOperation(){
        if pendingBinaryOperation != nil && accumalator != nil{
            accumalator = pendingBinaryOperation!.perform(with: accumalator!)
            descriptionAccumalator = pendingBinaryOperation!.updateDescription(with: descriptionAccumalator)
            pendingBinaryOperation = nil
        }
    }
    
    // Sets Operand 
    mutating func setOperand(_ operand: Double)
    {
        accumalator = operand
        descriptionAccumalator = "\(operand)"
        
    }
    
    func getDescription() -> String {
        let whitespace = (description.hasSuffix(" ") ? "" : " ")
        return isPending ? (description + whitespace  + "...") : (description + whitespace + "=")
    }
    
}
