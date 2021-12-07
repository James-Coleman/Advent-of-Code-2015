import Foundation

var greeting = "Hello, playground"

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

let exampleContainers: Set<Container> = [20, 15, 10, 5, 5]

enum Goldilocks {
    case tooLow
    case justRight
    case tooHigh
}

func can(_ containers: Set<Container>, fill: Int) -> Goldilocks {
    var fill = fill
    
    for container in containers {
        fill -= container.volume
        
        if fill < 0 {
            return .tooHigh
        }
    }
    
    if fill == 0 {
        return .justRight
    } else if fill < 0 {
        return .tooHigh
    } else {
        return .tooLow
    }
}

func setCombinations(of containers: Set<Container>, target: Int) -> Set<Set<Container>> {
//    var containers = containers
    var inProgress = Set<Set<Container>>()
    var done = Set<Set<Container>>()
    
    for _ in 0..<containers.count {
        if inProgress.isEmpty {
            for container in containers {
                let seed: Set<Container> = [container]
                inProgress.insert(seed)
            }
        }
        
        for inProgressSet in inProgress {
            for container in containers {
                var inProgressSet = inProgressSet
                inProgressSet.insert(container)
                let result = can(inProgressSet, fill: target)
                switch result {
                    case .tooLow:
                        inProgress.insert(inProgressSet)
                    case .justRight:
                        done.insert(inProgressSet)
                    case .tooHigh:
                        continue
                }
            }
            
            inProgress.remove(inProgressSet)
        }
    }
    
    return done
}

let example = setCombinations(of: exampleContainers, target: 25)
example.count
print(example)

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

let part1 = setCombinations(of: puzzleInput, target: 150)
part1.count


