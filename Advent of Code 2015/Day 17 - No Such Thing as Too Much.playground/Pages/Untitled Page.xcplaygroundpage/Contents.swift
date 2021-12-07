import Foundation

var greeting = "Hello, playground"

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

enum Goldilocks {
    case tooLow
    case justRight
    case tooHigh
}

/**
 - parameters:
    - array: Array to find the combinations of.
    - soFar: Internal argument used by recursion. Empty by default.
    - filter:
        Closure provides the next array to be assessed. Should return Bool of if the combinations should keep going or stop.
        Might have to revert to `Optional<Bool>` to allow function 3 choices
 */
func combinations<T>(of array: [T], soFar: [[T]] = [], filter: (([T]) -> Goldilocks)?) -> [[T]] {
//    print(filter)
    
    if array.isEmpty {
        return soFar
    } else {
        let next = array.indices.map { index -> ([T], [[T]]) in
            var copy = array
            let removed = copy.remove(at: index)
            
            let newSoFar = soFar.isEmpty ? [[removed]] : soFar.compactMap { soFarArray in
                let newArray = soFarArray + [removed]
                
                if let filter = filter {
                    let result = filter(newArray)
                    
                    switch result {
                        case .tooLow:
                            return newArray
                        case .justRight:
                            return newArray
                        case .tooHigh:
                            return nil
                    }
                } else {
                    return newArray
                }
            }
            
            return (copy, newSoFar)
        }
        
        return next.flatMap { (nextArray, nextSoFar) in
            return combinations(of: nextArray, soFar: nextSoFar, filter: filter)
        }
    }
}

struct Container {
    let id = UUID()
    let volume: Int
}

extension Container: ExpressibleByIntegerLiteral {
    init(integerLiteral value: Int) {
        self.volume = value
    }
}

extension Container: CustomStringConvertible {
    var description: String { String(volume) }
}

extension Container: Hashable { }

let exampleContainers: [Container] = [20, 15, 10, 5, 5]

let test = combinations(of: exampleContainers, filter: { containers -> Goldilocks in
    var fill = 25
    
    for container in containers {
        fill -= container.volume
        
//        print(fill, container, containersToReturn)
        
    }
    
    if fill == 0 {
        return .justRight
    } else if fill < 0 {
        return .tooHigh
    } else {
        return .tooLow
    }
})

test.count

print(test)

let testSet = Set(test)

testSet.count

print(testSet)

let exampleCombinations = combinations(of: exampleContainers)

exampleCombinations.count

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

//let exampleFillingCombinations = exampleCombinations.compactMap { can(containers: $0, fill: 25) }

//print(exampleFillingCombinations)

//let uniqueExampleCombinations = Set(exampleFillingCombinations)

//print(uniqueExampleCombinations)

let puzzleInput: Set<Container> = [50,
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

//let puzzleCombinations = uniqueCombinations(of: puzzleInput)
//
//let puzzleFillingCombinations = puzzleCombinations.compactMap { can(containers: $0, fill: 150) }
//
//let uniquePuzzleCombinations = Set(puzzleFillingCombinations)
//
//print(uniquePuzzleCombinations.count)
