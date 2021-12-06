//
//  Day17.swift
//  Advent of Code 2015
//
//  Created by James Coleman on 06/12/2021.
//

import Foundation

struct Container {
    let id = UUID()
    let volume: Int
}

extension Container: ExpressibleByIntegerLiteral {
    typealias IntegerLiteralType = Int
    
    init(integerLiteral value: Int) {
        self.volume = value
    }
}

extension Container: CustomStringConvertible {
    var description: String { String(volume) }
}

extension Container: Hashable { }

func day17() {
    func can(containers: [Container], fill: Int) -> Set<Container>? {
        var fill = fill
        var containersToReturn = Set<Container>()
        
        for container in containers {
            fill -= container.volume
            containersToReturn.insert(container)
            
    //        print(fill, container, containersToReturn)
            
            if fill == 0 {
                return containersToReturn
            } else if fill < 0 {
                return nil
            }
        }
        
        if fill == 0 {
            return containersToReturn
        } else {
            return nil
        }
    }

    let puzzleInput: [Container] = [50,
                                    44,
                                    11,
                                    49,
                                    42,
                                    46,
                                    18,
                                    32,
                                    26,
                                    40,
                                    21,
                                    7,
                                    18,
                                    43,
                                    10,
                                    47,
                                    36,
                                    24,
                                    22,
                                    40]

    let puzzleCombinations = combinations(of: puzzleInput)

    let puzzleFillingCombinations = puzzleCombinations.compactMap { can(containers: $0, fill: 150) }

    let uniquePuzzleCombinations = Set(puzzleFillingCombinations)

    print(uniquePuzzleCombinations.count)
}
