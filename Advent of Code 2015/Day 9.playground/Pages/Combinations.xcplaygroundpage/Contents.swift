import Foundation

var greeting = "Hello, playground"

func combinations(of array: [String], soFar: [[String]] = []) -> [[String]] {
    if array.isEmpty {
        return soFar
    } else {
        
        if soFar.isEmpty {
            let next = array.indices.map { index -> ([String], String) in
                var copy = array
                let removed = copy.remove(at: index)
                return (copy, removed)
            }
            
            return next.flatMap { (nextArray, nextString) in
                return combinations(of: nextArray, soFar: [[nextString]])
            }
        } else {
            let next = array.indices.map { index -> ([String], [[String]]) in
                var copy = array
                let removed = copy.remove(at: index)
                
                let newSoFar = soFar.map { soFarArray in
                    return soFarArray + [removed]
                }
                
                return (copy, newSoFar)
            }
            
            return next.flatMap { (nextArray, nextSoFar) in
                return combinations(of: nextArray, soFar: nextSoFar)
            }
        }
    }
}

print(combinations(of: ["London", "Belfast", "Dublin"]))
