//
//  Day20.swift
//  Advent of Code 2015
//
//  Created by James Coleman on 08/12/2021.
//

import Foundation

func day20() {
    func divisors(of number: Int) -> Set<Int> {
        guard number != 0 else { return [] }
        
        var divider = Double(1)
        var divided = Double(number) / divider
        
        var newDivisors = Set<Int>([1, number])
        
        while divider < divided {
            divider += 1
            let newDivided = Double(number) / divider
            
            if newDivided.truncatingRemainder(dividingBy: 1) == 0 {
                newDivisors.formUnion([Int(newDivided)])
                newDivisors.formUnion([Int(divider)])
            }
            
            divided = newDivided
        }
        
        return newDivisors
    }

    func numberOfPresents(for number: Int) -> Int {
        divisors(of: number).reduce(0) { soFar, next in
            soFar + (10 * next)
        }
    }
    
    var presents = 0
    var houseNumber = 0
    
    while presents < 29_000_000 {
        houseNumber += 1
        presents = numberOfPresents(for: houseNumber)
    }
    
    print("House \(houseNumber) gets \(presents) presents")
    // House 665280 gets 29260800 presents (correct)

}
