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
    private enum Op: CustomStringConvertible
    {
        case Variable(String)
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description : String {
            get {
                switch self {
                case .Operand( let operand) : return "\(operand)"
                case .Variable(let variable) : return variable
                case .BinaryOperation(let symbol, _): return symbol
                case .UnaryOperation(let symbol, _): return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    private var pi = M_PI
    
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
        knownOps["COS"] = Op.UnaryOperation("COS", cos)
        knownOps["SIN"] = Op.UnaryOperation("SIN", sin)
        knownOps["TAN"] = Op.UnaryOperation("TAN", tan)
        
    }
    
    // Waar word dit eigenlijk aangeroepen?
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
    
    var variableValues = [String :Double]()
    func setValueForGo( GO : String, value : Double)
    {
        
        variableValues.updateValue(value, forKey: GO)
    }
    
    
    // -> vertelt wat er gerunt moet worden
    private func evaluate( ops : [Op]) ->(result :Double?, remainingOps :[Op])
    {
        if !ops.isEmpty
        {
            var remainingOps = ops
            let op  = remainingOps.removeLast()
            switch op
            {
                
            case .Operand(let operand) :
                return(operand, remainingOps)
            case .Variable(let variable) :
                let value = variableValues[variable]
                return (value, remainingOps)
                
            case .UnaryOperation(_, let operation) :
                let operandEvalutation = evaluate(remainingOps)
                if let operand = operandEvalutation.result
                {
                    return (operation(operand),operandEvalutation.remainingOps)
                }
                
            case .BinaryOperation(_, let operation):
                let operand1Evalutation = evaluate(remainingOps)
                if let operand1 = operand1Evalutation.result
                {
                    let operand2Evalutation = evaluate(operand1Evalutation.remainingOps)
                    if let operand2 = operand2Evalutation.result
                    {
                        return (operation(operand1,operand2), operand2Evalutation.remainingOps)
                    }
                }
                
                // default : break
                
            }
        }
        return (nil, ops)
    }
    
    func evaluate() ->(result :Double?, description :String?)
    {
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        
        var currentString = descriptionString(opStack).resultString
        if let newString =  descriptionString(remainder).resultString
        {
            if let currentStringCheck =  currentString
            {
                currentString = newString + "," + currentStringCheck
                
            }
        }
        
        return (result, currentString)
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate().result
    }
    
    func removeOperand(operand: Double) -> Double {
        
        if opStack.isEmpty {
            return operand
             } else {
            opStack.removeLast()
        }
        return 0
    }
    
    func getAll() -> String? {
        var returnAll = ""
        for all in opStack {
            returnAll += ("\(all), ")
        }
        return returnAll
    }
    
    func performOperation(symbol : String) ->(result :Double?, description :String?)
    {
        if let operation = knownOps[symbol]
        {
            opStack.append(operation)
        }
        
        return evaluate()
    }
    
    func clearAll() -> Double {
        opStack.removeAll()
        return 0.0
    }
    
    private func descriptionString( ops : [Op]) ->(resultString :String?, remainingOps :[Op])
    {
        var returnString = ""
        
        if !ops.isEmpty
        {
            var remainingOps = ops
            let op  = remainingOps.removeLast()
            switch op
            {
                
            case .Operand(_) :
                returnString = returnString + op.description
                return(returnString, remainingOps)
            case .Variable(let variable) :
                if let value = variableValues[variable]
                {
                    returnString = returnString + "m"
                    return(returnString, remainingOps)
                }
                else
                {
                    returnString = returnString + "m"
                    return(returnString, remainingOps)
                }
                
                
            case .UnaryOperation(_,  _) :
                
                let operandEvalutation = descriptionString(remainingOps)
                if let operandString = operandEvalutation.resultString
                {
                    returnString = returnString + op.description +  "(" + operandString  + ")"
                    return (returnString, operandEvalutation.remainingOps)
                }
                
            case .BinaryOperation(_,  _):
                let operand1 = descriptionString(remainingOps)
                if let operand1Ev = operand1.resultString
                {
                    let operand2 = descriptionString(operand1.remainingOps)
                    if let operand2Ev = operand2.resultString
                    {
                        if (operand2.remainingOps.count > 0 )
                        {
                            returnString = returnString + "(" + operand2Ev + op.description + operand1Ev + ")"
                        }
                        else
                        {
                            returnString = returnString + operand2Ev + op.description + operand1Ev
                        }
                        return (returnString, operand2.remainingOps)
                    }
                }
            }
        }
        return (returnString, ops)
    }
    
    func graphicDisplay() -> (result :Double?, description :String?)
    {
        let (result, _) = evaluate(opStack)
        let currentString = descriptionString(opStack).resultString
        return (result, currentString)
    }
    
    
}