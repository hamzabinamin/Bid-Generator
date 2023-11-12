//
//  String.swift
//  Bid Generator
//
//  Created by Hamza Amin on 21/01/2024.
//

import Foundation

extension String {

    func isInt() -> Bool {

        if let intValue = Int(self) {
            return true
        }
        return false
    }

    func isFloat() -> Bool {

        if let floatValue = Float(self) {
            return true
        }
        return false
    }

    func isDouble() -> Bool {

        if let doubleValue = Double(self) {
            return true
        }
        return false
    }

    func numberOfCharacters() -> Int {
        return self.count
    }
}
