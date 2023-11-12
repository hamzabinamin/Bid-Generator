//
//  Int.swift
//  Bid Generator
//
//  Created by Hamza Amin on 30/11/2023.
//

import Foundation

extension Int {
    
    static func random(min: Int, max: Int, minIncrement: Int) -> Int {
        assert(max > min)
        var set = Set<Int>()
        let minIndex = min / minIncrement
        let r = arc4random_uniform(UInt32(max / minIncrement - minIndex))
        
        return (Int(r) + minIndex) * minIncrement
        
       // return Array(set)
    }
    
    static func random2(min: Int, max: Int, count: Int, minIncrement: Int) -> [Int] {
        assert(max > min)
        var set = Set<Int>()
        while set.count < count {
            let minIndex = min / minIncrement
            let r = arc4random_uniform(UInt32(max / minIncrement - minIndex))
            set.insert((Int(r) + minIndex) * minIncrement)
        }
        
        return Array(set)
    }

    static func getUniqueRandomNumbers(min: Int, max: Int, count: Int, minIncrement: Int) -> [Int] {
        var set = Set<Int>()
        while set.count < count {
            set.insert((Int.random(in: min...max) + 1) * minIncrement)
        }
        return Array(set)
    }
    
    static func getRepeatedRandomNumbers(numbers: [Int]) -> [Int] {
        var repeatedNumbers = numbers
        var i = 0
        var j = 0
        
        while i < numbers.count {
            let randomIndex = Int.random(in: i...numbers.count - 1)
            let randomIndexValue = numbers[randomIndex]
            let repeatTill = Int.random(in: i...numbers.count - 1)
            j = randomIndex
            
            while j < repeatTill {
                repeatedNumbers[j] = randomIndexValue
                j = j + 1
            }
            i = i + 1
            
            print("*")
            print("i: ", i)
            print("j: ", j)
            print("randomIndex: ", randomIndex)
            print("randomIndexValue: ", randomIndexValue)
            print("repeatTill: ", repeatTill)
            print("repeatingNumbers: ", repeatedNumbers)
        }
        
        print("repeatingNumbers final")
        print(repeatedNumbers)
        return repeatedNumbers
    }
    
    static func getInt(string: String) -> Int? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        let number = formatter.number(from: string)
    
        return number?.intValue
    }

}
