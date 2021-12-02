//
//  Day9Part1.swift
//  Advent of Code 2015
//
//  Created by James Coleman on 02/12/2021.
//

import Foundation

class City {
    let name: String
    private var distances: [City: Int]
    
    init(name: String) {
        self.name = name
        self.distances = [:]
    }
    
    subscript(city: City) -> Int? {
        get {
            return distances[city]
        }
        set {
            distances[city] = newValue
            city.distances[self] = newValue
        }
    }
}

extension City: CustomStringConvertible {
    var description: String { name }
}

extension City: Equatable {
    static func == (lhs: City, rhs: City) -> Bool {
        lhs.name == rhs.name
    }
}

extension City: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

func day9() {
    
    let challengeInput = """
    Faerun to Tristram = 65
    Faerun to Tambi = 129
    Faerun to Norrath = 144
    Faerun to Snowdin = 71
    Faerun to Straylight = 137
    Faerun to AlphaCentauri = 3
    Faerun to Arbre = 149
    Tristram to Tambi = 63
    Tristram to Norrath = 4
    Tristram to Snowdin = 105
    Tristram to Straylight = 125
    Tristram to AlphaCentauri = 55
    Tristram to Arbre = 14
    Tambi to Norrath = 68
    Tambi to Snowdin = 52
    Tambi to Straylight = 65
    Tambi to AlphaCentauri = 22
    Tambi to Arbre = 143
    Norrath to Snowdin = 8
    Norrath to Straylight = 23
    Norrath to AlphaCentauri = 136
    Norrath to Arbre = 115
    Snowdin to Straylight = 101
    Snowdin to AlphaCentauri = 84
    Snowdin to Arbre = 96
    Straylight to AlphaCentauri = 107
    Straylight to Arbre = 14
    AlphaCentauri to Arbre = 46
    """
    
    var challengeCities = [City]()
    
    for line in challengeInput.components(separatedBy: .newlines) {
        let components = line.components(separatedBy: .whitespaces)
        
        let city1Name = components[0]
        let city2Name = components[2]
        let distance = Int(components[4])!
        
        let city1 = City(name: city1Name)
        let city2 = City(name: city2Name)
        
        if challengeCities.contains(city1) == false {
            challengeCities.append(city1)
        }
        
        if challengeCities.contains(city2) == false {
            challengeCities.append(city2)
        }
        
        let realCity1 = challengeCities.first(where: { $0 == city1 })!
        let realCity2 = challengeCities.first(where: { $0 == city2 })!
        
        realCity1[realCity2] = distance
    }
    
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
    
    let cityCombinations = combinations(of: challengeCities)
    
//    print(cityCombinations)
    
    var winningCombination = [City]()
    var shortestDistance: Int?
    
    for combination in cityCombinations {
        var distanceSoFar = 0
        
        for (index, city) in combination.enumerated() {
            if index == 0 { continue }
            
            let previousCity = combination[index - 1]
            
            if let distance = previousCity[city] {
                distanceSoFar += distance
            } else {
                print("No distance from \(previousCity) to \(city)")
                return
            }
        }
        
        if let shortDistanceUnwrapped = shortestDistance {
            if distanceSoFar > shortDistanceUnwrapped {
                winningCombination = combination
                shortestDistance = distanceSoFar
            }
        } else {
            winningCombination = combination
            shortestDistance = distanceSoFar
        }
    }
    
    print(winningCombination, shortestDistance)
    
    // Shortest: [Faerun, AlphaCentauri, Tambi, Snowdin, Norrath, Tristram, Arbre, Straylight] 117 (correct)
    // Longest: [Tambi, Arbre, Faerun, Norrath, AlphaCentauri, Straylight, Tristram, Snowdin] 909 (correct)
}

