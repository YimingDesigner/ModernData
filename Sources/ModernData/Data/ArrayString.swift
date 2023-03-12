//
//  ArrayString.swift
//  
//
//  Created by Yiming Liu on 3/12/23.
//

import Foundation

// MARK: - Array to String

public extension Array where Element == String {
    
    func encodeToString() -> String {
        var resultString = ""
        for string in self {
            if resultString != "" { resultString += ", " }
            resultString += string
        }
        return resultString
    }
    
}

public extension Array {
    
    func encodeToString(_ string: (Element) -> String) -> String {
        var resultString = ""
        for item in self {
            if resultString != "" { resultString += ", " }
            resultString += string(item)
        }
        return resultString
    }
    
}

// MARK: - String to Array

public extension String {
    func decodeToArray() -> [String] {
        var resultStrings: [String] = []
        var currentString = ""
        var started = false
        for character in self {
            if !started && character != " " { started = true }
            
            if started {
                if started && character == "," {
                    resultStrings.append(currentString)
                    currentString = ""
                    started = false
                    continue
                }
                currentString += String(character)
            }
        }
        if currentString != "" { resultStrings.append(currentString) }
        
        return resultStrings
    }
}
