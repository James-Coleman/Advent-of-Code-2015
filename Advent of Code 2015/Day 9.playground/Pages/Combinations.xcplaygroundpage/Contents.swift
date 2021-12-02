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

print(combinations(of: ["London", "Belfast", "Dublin"]))
//print(combinations(of: ["A", "B", "C", "D"]))
