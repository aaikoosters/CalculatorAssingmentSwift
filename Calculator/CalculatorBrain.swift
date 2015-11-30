//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Aaik Oosters on 23-11-15.
//  Copyright © 2015 Aaik Oosters. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private enum Op
    {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    private var pi = 3.14159265359
    
    init () {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["÷"] = Op.BinaryOperation("÷") {$0 / $01}
        knownOps["×"] = Op.BinaryOperation("×", *)
        knownOps["-"] = Op.BinaryOperation("-") {$0 - $01}
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
        knownOps["Pi"] = Op.UnaryOperation("Pi") {$0 * self.pi }
        
    }
    
    typealias  PropertyList = AnyObject
    var program: PropertyList { // guaranteed to be a propertyList
        get {
            return opStack.map { $0.description }
        }
        set {
            if let opSymbols = newValue as? Array<String> {
                var newOpstack = [Op]()
                for opSymbol in opSymbols {
                    if let op = knownOps[opSymbol] {
                        newOpstack.append(op)
                    } else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue {
                        newOpstack.append(.Operand(operand))
                    }
                }
                opStack = newOpstack
            }
        }
    }
    
    
    // -> vertelt wat er gerunt moet worden
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? { // make optional because + or - or * or / isnt a double
     let (result, remainder) = evaluate(opStack)
        print("\(result!) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func removeOperand(operand: Double) -> Double {
        
        if opStack.isEmpty {
            return 0
             } else {
            opStack.removeLast()
        }
        return 0
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}