import Foundation

var greeting = "Hello, playground"

class Person {
    let name: String
    var happiness: [Person: Int]
    
    init(name: String) {
        self.name = name
        self.happiness = [:]
    }
}

extension Person: Equatable {
    static func == (lhs: Person, rhs: Person) -> Bool {
        lhs.name == rhs.name
    }
}

extension Person: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

func parse(_ input: String) -> [Person] {
    var arrayToReturn = [Person]()
    
    let rows = input.components(separatedBy: .newlines)
    
    for row in rows {
        let words = row.components(separatedBy: .whitespaces)
        
        guard let firstName = words.first, var secondName = words.last else { continue }
        secondName.popLast() // Remove full stop
        
        let firstPerson = Person(name: firstName)
        let secondPerson = Person(name: secondName)
        
        if arrayToReturn.contains(firstPerson) == false {
            arrayToReturn.append(firstPerson)
        }
        if arrayToReturn.contains(secondPerson) == false {
            arrayToReturn.append(secondPerson)
        }
    }
    
    for row in rows {
        let words = row.components(separatedBy: .whitespaces)
        
        guard let firstName = words.first, var secondName = words.last else { continue }
        secondName.popLast() // Remove full stop
        
        guard let firstPerson = arrayToReturn.first(where: { $0.name == firstName }),
              let secondPerson = arrayToReturn.first(where: { $0.name == secondName }) else { continue }
        
        let modifier = words[2]
        
        let multiplier = modifier == "gain" ? 1 : -1
        
        guard let scale = Int(words[3]) else { continue }
        
        let happiness = scale * multiplier
        
        firstPerson.happiness[secondPerson] = happiness
    }
    
    return arrayToReturn
}

let exampleInput = """
    Alice would gain 54 happiness units by sitting next to Bob.
    Alice would lose 79 happiness units by sitting next to Carol.
    Alice would lose 2 happiness units by sitting next to David.
    Bob would gain 83 happiness units by sitting next to Alice.
    Bob would lose 7 happiness units by sitting next to Carol.
    Bob would lose 63 happiness units by sitting next to David.
    Carol would lose 62 happiness units by sitting next to Alice.
    Carol would gain 60 happiness units by sitting next to Bob.
    Carol would gain 55 happiness units by sitting next to David.
    David would gain 46 happiness units by sitting next to Alice.
    David would lose 7 happiness units by sitting next to Bob.
    David would gain 41 happiness units by sitting next to Carol.
    """

let examplePeople = parse(exampleInput)

func combinations<T>(of array: [T], soFar: [[T]] = []) -> [[T]] {
    if array.isEmpty {
        return soFar
    } else {
        let next = array.indices.map { index -> ([T], [[T]]) in
            var copy = array
            let removed = copy.remove(at: index)
            
            let newSoFar = soFar.isEmpty ? [[removed]] : soFar.map { soFarArray in
                return soFarArray + [removed]
            }
            
            return (copy, newSoFar)
        }
        
        return next.flatMap { (nextArray, nextSoFar) in
            return combinations(of: nextArray, soFar: nextSoFar)
        }
    }
}

let exampleSeatingArrangements = combinations(of: examplePeople)

enum HappinessError: Error {
    case noHappinessBetween(person1: Person, person2: Person)
}

func bestHappiness(from input: [[Person]]) throws -> ([Person], Int)? {
    var bestArrangement: [Person]?
    var bestScore: Int?
    
    for arrangement in input {
        var totalScore = 0
        
        for (index, person) in arrangement.enumerated() {
            if index == (arrangement.count - 1) {
                // Last item
                let otherPerson = arrangement[0]
                
                guard let firstHappiness = person.happiness[otherPerson] else { throw HappinessError.noHappinessBetween(person1: person, person2: otherPerson) }
                guard let secondHappiness = otherPerson.happiness[person] else { throw HappinessError.noHappinessBetween(person1: otherPerson, person2: person) }
                
                totalScore += firstHappiness
                totalScore += secondHappiness
            } else {
                let otherPerson = arrangement[index + 1]
                
                guard let firstHappiness = person.happiness[otherPerson] else { throw HappinessError.noHappinessBetween(person1: person, person2: otherPerson) }
                guard let secondHappiness = otherPerson.happiness[person] else { throw HappinessError.noHappinessBetween(person1: otherPerson, person2: person) }
                
                totalScore += firstHappiness
                totalScore += secondHappiness
            }
        }
        
        if let bestScoreSoFar = bestScore {
            if totalScore > bestScoreSoFar {
                bestArrangement = arrangement
                bestScore = totalScore
            }
        } else {
            bestArrangement = arrangement
            bestScore = totalScore
        }
    }
    
    if let bestArrangement = bestArrangement, let bestScore = bestScore {
        return (bestArrangement, bestScore)
    } else {
        return nil
    }
}

do {
    try bestHappiness(from: exampleSeatingArrangements) // 330 (correct) (Alice -> Bob -> Carol -> David)
} catch {
    error
}

func addMe(to array: [Person]) -> [Person] {
    var array = array
    
    let me = Person(name: "Me")
    
    for person in array {
        me.happiness[person] = 0
        person.happiness[me] = 0
    }
    
    array.append(me)
    
    return array
}

let includingMe = addMe(to: examplePeople)

let puzzleInput = """
    Alice would gain 54 happiness units by sitting next to Bob.
    Alice would lose 81 happiness units by sitting next to Carol.
    Alice would lose 42 happiness units by sitting next to David.
    Alice would gain 89 happiness units by sitting next to Eric.
    Alice would lose 89 happiness units by sitting next to Frank.
    Alice would gain 97 happiness units by sitting next to George.
    Alice would lose 94 happiness units by sitting next to Mallory.
    Bob would gain 3 happiness units by sitting next to Alice.
    Bob would lose 70 happiness units by sitting next to Carol.
    Bob would lose 31 happiness units by sitting next to David.
    Bob would gain 72 happiness units by sitting next to Eric.
    Bob would lose 25 happiness units by sitting next to Frank.
    Bob would lose 95 happiness units by sitting next to George.
    Bob would gain 11 happiness units by sitting next to Mallory.
    Carol would lose 83 happiness units by sitting next to Alice.
    Carol would gain 8 happiness units by sitting next to Bob.
    Carol would gain 35 happiness units by sitting next to David.
    Carol would gain 10 happiness units by sitting next to Eric.
    Carol would gain 61 happiness units by sitting next to Frank.
    Carol would gain 10 happiness units by sitting next to George.
    Carol would gain 29 happiness units by sitting next to Mallory.
    David would gain 67 happiness units by sitting next to Alice.
    David would gain 25 happiness units by sitting next to Bob.
    David would gain 48 happiness units by sitting next to Carol.
    David would lose 65 happiness units by sitting next to Eric.
    David would gain 8 happiness units by sitting next to Frank.
    David would gain 84 happiness units by sitting next to George.
    David would gain 9 happiness units by sitting next to Mallory.
    Eric would lose 51 happiness units by sitting next to Alice.
    Eric would lose 39 happiness units by sitting next to Bob.
    Eric would gain 84 happiness units by sitting next to Carol.
    Eric would lose 98 happiness units by sitting next to David.
    Eric would lose 20 happiness units by sitting next to Frank.
    Eric would lose 6 happiness units by sitting next to George.
    Eric would gain 60 happiness units by sitting next to Mallory.
    Frank would gain 51 happiness units by sitting next to Alice.
    Frank would gain 79 happiness units by sitting next to Bob.
    Frank would gain 88 happiness units by sitting next to Carol.
    Frank would gain 33 happiness units by sitting next to David.
    Frank would gain 43 happiness units by sitting next to Eric.
    Frank would gain 77 happiness units by sitting next to George.
    Frank would lose 3 happiness units by sitting next to Mallory.
    George would lose 14 happiness units by sitting next to Alice.
    George would lose 12 happiness units by sitting next to Bob.
    George would lose 52 happiness units by sitting next to Carol.
    George would gain 14 happiness units by sitting next to David.
    George would lose 62 happiness units by sitting next to Eric.
    George would lose 18 happiness units by sitting next to Frank.
    George would lose 17 happiness units by sitting next to Mallory.
    Mallory would lose 36 happiness units by sitting next to Alice.
    Mallory would gain 76 happiness units by sitting next to Bob.
    Mallory would lose 34 happiness units by sitting next to Carol.
    Mallory would gain 37 happiness units by sitting next to David.
    Mallory would gain 40 happiness units by sitting next to Eric.
    Mallory would gain 18 happiness units by sitting next to Frank.
    Mallory would gain 7 happiness units by sitting next to George.
    """

let puzzlePeople = parse(puzzleInput)

//let puzzleSeatingCombinations = combinations(of: puzzlePeople)

do {
//    try bestHappiness(from: puzzleSeatingCombinations)
} catch {
    error
}
