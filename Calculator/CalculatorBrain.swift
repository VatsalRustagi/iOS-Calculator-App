//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Vatsal Rustagi on 3/16/17.
//  Copyright © 2017 Calc. All rights reserved.
//

import Foundation

struct CalculatorBrain{
    
    private var accumalator: Double?
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double)-> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    private struct PendingBinaryOperation{
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperation: Double)-> Double{
            return function(firstOperand, secondOperation)
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private var operations: Dictionary<String, Operation> =
        [
            "π": Operation.constant(Double.pi),
            "e": Operation.constant(M_E),
            "√": Operation.unaryOperation(sqrt),
            "cos": Operation.unaryOperation(cos),
            "±" : Operation.unaryOperation({-$0}),
            "x" : Operation.binaryOperation({$0*$1}),
            "/" : Operation.binaryOperation({$0/$1}),
            "+" : Operation.binaryOperation({$0+$1}),
            "-" : Operation.binaryOperation({$0-$1}),
            "=" : Operation.equals,
            "sin": Operation.unaryOperation(sin)
        ]
    
    mutating func performOperation(_ symbol: String)
    {
        if let operation = operations[symbol]{
            switch operation {
            case .constant(let value):
                accumalator = value
            case .unaryOperation(let function):
                if accumalator != nil{
                    accumalator = function(accumalator!)
                }
            case .binaryOperation(let function):
                if accumalator != nil{
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumalator!)
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
            pendingBinaryOperation = nil
        }
    }
    
    mutating func setOperand(_ operand: Double)
    {
        accumalator = operand
    }
    
    var result: Double?{
        get{
            return accumalator
        }
    }
    
    
    
}
