import Foundation

var greeting = "Hello, playground"

func house(number: Int) -> Int{
    var presents = 0
    
    for i in 1...number {
        if number % i == 0 {
            presents += (i * 10)
        }
    }
    
    return presents
}

house(number: 1)
house(number: 2)
house(number: 3)
house(number: 4)
house(number: 5)
house(number: 6)
house(number: 7)
house(number: 8)
house(number: 9)

//var presents = 0
//var houseNumber = 1
//
//while presents != 29_000_000 {
//    presents = house(number: houseNumber)
//    houseNumber += 1
//}
//
//houseNumber

// how many divisors does the house have?
// what is the sum of the divisors?

/// Only works for positive numbers or 0
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

//divisors(of: 6)
//divisors(of: 29_000_000).reduce(0) { soFar, next in
//    soFar + (10 * next)
//} // 744_131_100 (too high)

divisors(of: 665280).sorted()

func numberOfPresents(for number: Int) -> Int {
    divisors(of: number).reduce(0) { soFar, next in
        soFar + (10 * next)
    }
}

//let numberFormatter = NumberFormatter()
//numberFormatter.numberStyle = .decimal
//
//numberFormatter.string(for: numberOfPresents(for: 8))

func part2(number: Int) -> Int {
    var presents = 0
    
    for i in 1...number {
        if number % i == 0 && number <= (i * 50) {
            presents += (i * 11)
        }
    }
    
    return presents
}

part2(number: 6)

/*
 E.g.:
 Elf 1 50
 Elf 2 100
 Elf 3 150
 */

func divisorsPart2(of number: Int) -> Set<Int> {
    guard number != 0 else { return [] }
    
    let doubleNumber = Double(number)
    
    var divider = Double(1)
    var divided = doubleNumber / divider
    
    var newDivisors = Set<Int>([1, number])
    
    while divider < divided {
        divider += 1
        let newDivided = doubleNumber / divider
        
        if newDivided.truncatingRemainder(dividingBy: 1) == 0 && doubleNumber <= (newDivided * 50) {
            newDivisors.formUnion([Int(newDivided)])
            newDivisors.formUnion([Int(divider)])
        }
        
        divided = newDivided
    }
    
    return newDivisors
}

func numberOfPresentsPart2(for number: Int) -> Int {
    divisorsPart2(of: number).reduce(0) { soFar, next in
        soFar + (11 * next)
    }
}

numberOfPresentsPart2(for: 1_000_000)

