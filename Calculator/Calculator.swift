//
//  Calculator.swift
//  Calculator Layout iOS13
//
//  Created by Idan Israel on 18/02/2025.
//  Copyright © 2025 The App Brewery. All rights reserved.
//

import Foundation
import UIKit

class Calculator {
    
    // Private Variables
    
    var result = "0"
    var equalsPressed = false
    weak var delegate: CalculatorDelegate?
    
    // Puiblic Functions
    
    public func handleSelected(character text: String?) {
        guard let text = text else { return }
        
        switch (text) {
        case Constants.AC:
            result = Constants.ZERO
            equalsPressed = false
        case Constants.INVERT_SIGN:
            handleInvertSign()
        case Constants.DECIMAL_POINT:
            handleDecimalPoint()
        case let mathSign where Constants.MATH_SIGNS.contains(mathSign):
            handleMathSigns(sign: text)
        case Constants.PERCENTS:
            handlePercents()
        case Constants.EQUALS:
            handleCalcResult()
        default:
            result = result == Constants.ZERO  || equalsPressed ? text : result + text
        }
        
        equalsPressed = text == Constants.EQUALS
        delegate?.didUpdateResult(result)
    }
    
    // Mathematical Private Functions
    
    private func handleInvertSign() {
        guard result != "0" else { return }
                
        if let firstChar = result.first, String(firstChar) == Constants.MINUS {
             result.removeFirst()
             return
         }
        
        result = Constants.MINUS + result
    }
    
    private func handleDecimalPoint() {
        guard (!result.contains(Constants.DECIMAL_POINT)) else { return }
        
        result += Constants.DECIMAL_POINT
    }
    
    private func handlePercents() {
        guard (!result.contains(Constants.PERCENTS)), let lastChar = result.last else { return }
        
        if (!lastChar.isNumber) {
            result.removeLast()
        }
        
        result += Constants.PERCENTS
    }
    
    private func handleMathSigns(sign: String?) {
        guard let sign = sign, let lastChar = result.last else { return }
        
        if (!lastChar.isNumber) {
            result.removeLast()
        }
        
        result += sign
    }
    
    private func replaceOperators(in expression: String) -> String {
        var updatedExpression = expression
        
        updatedExpression = updatedExpression.replacingOccurrences(of: Constants.MULTIPLICATION, with: "*")
        updatedExpression = updatedExpression.replacingOccurrences(of: Constants.DIVISION, with: "/")
        
        return updatedExpression
    }
    
    private func handleCalcResult() {
        do {
            guard let lastChar = result.last else {
                throw NSError(domain: "Invalid input", code: 0, userInfo: nil)
            }
            
            if !lastChar.isNumber && lastChar != "%" {
                throw NSError(domain: "Invalid input", code: 0, userInfo: nil)
            }

            if result.contains(Constants.PERCENTS) {
                let parts = result.components(separatedBy: Constants.PERCENTS)
                
                if let firstPart = Double(parts.first ?? ""),
                   let lastPart = Double(parts.last ?? "") {
                    let finalResult = firstPart * lastPart / 100
                    result = finalResult == floor(finalResult) ? String(Int(finalResult)) : String(finalResult)
                } else {
                    throw NSError(domain: "Invalid number format", code: 0, userInfo: nil)
                }
                return
            }

            let expressionFormat = replaceOperators(in: result)
            let expression = NSExpression(format: expressionFormat)

            if let expressionResult = expression.expressionValue(with: nil, context: nil) as? Double {
                // Handle division with quotient and remainder
                let divisionComponents = expressionFormat.components(separatedBy: "/")
                if divisionComponents.count == 2,
                   let numerator = Double(divisionComponents[0]),
                   let denominator = Double(divisionComponents[1]),
                   denominator != 0 {
                    let quotient = numerator / denominator
                    let remainder = numerator.truncatingRemainder(dividingBy: denominator)
                    if remainder == 0 {
                        result = "\(quotient == floor(quotient) ? String(Int(quotient)) : String(quotient))"
                    } else {
                        result = "\(quotient) + \(remainder)/\(denominator)"
                    }
                } else {
                    self.result = expressionResult == floor(expressionResult) ? String(Int(expressionResult)) : String(expressionResult)
                }
            } else {
                throw NSError(domain: "Invalid expression", code: 0, userInfo: nil)
            }
        } catch let error {
            delegate?.calculationError(error.localizedDescription)
        }
    }
}
