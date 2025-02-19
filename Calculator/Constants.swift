//
//  Constants.swift
//  Calculator Layout
//
//  Created by Idan Israel on 18/02/2025.
//  Copyright © 2025 The App Brewery. All rights reserved.
//

protocol CalculatorDelegate: AnyObject {
    func didUpdateResult(_ result: String)
    func calculationError(_ error: String)
}

struct Constants {
    static let AC = "AC"
    static let ZERO = "0"
    static let PERCENTS = "%"
    static let INVERT_SIGN = "+/-"
    static let EQUALS = "="
    static let DECIMAL_POINT = "."
    static let PLUS = "+"
    static let MINUS = "-"
    static let MULTIPLICATION = "×"
    static let DIVISION = "÷"
    static let MATH_SIGNS = [ "×", "÷", "+", "-" ]
}
