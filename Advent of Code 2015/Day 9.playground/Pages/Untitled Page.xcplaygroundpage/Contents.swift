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

// MARK: Re-trying class approach

let london = City(name: "London")
let dublin = City(name: "Dublin")
let belfast = City(name: "Belfast")

london[dublin] = 464
london[belfast] = 518
dublin[belfast] = 141

struct Route {
    var cities = [City]()
    var shortestDistance: Int? = nil
    
    var visualRoute: String {
        guard let shortestDistance = shortestDistance else { return "No distance calculated" }
        
        let cityString = cities.enumerated().reduce("") { soFar, next in
            let (index, city) = next
            if index == 0 {
                return city.name
            } else {
                return soFar + " -> " + city.name
            }
        }
        
        return cityString + " = " + String(shortestDistance)
    }
    
    mutating func append(city: City) {
        guard cities.contains(city) == false else { print("Already added \(city.name)"); return }
        
        if cities.isEmpty {
            cities = [city]
        } else {
            var bestCities = cities
            var bestDistance: Int?
            
            for insertionIndex in 0...cities.count {
                var arrayCopy = cities
                arrayCopy.insert(city, at: insertionIndex)
                
                var totalDistance = 0
                
                for (index, city) in arrayCopy.enumerated() {
                    if index == 0 { continue }
                    
                    let previousCity = arrayCopy[index - 1]
                    
                    if let distance = previousCity[city] {
                        totalDistance += distance
                    } else {
                        print("No distance from \(previousCity) to \(city)")
                        return
                    }
                }
                
                print(arrayCopy)
                print(totalDistance)
                
                if let bestDistanceUnwrapped = bestDistance {
                    if totalDistance < bestDistanceUnwrapped {
                        bestCities = arrayCopy
                        bestDistance = totalDistance
                    }
                } else {
                    bestCities = arrayCopy
                    bestDistance = totalDistance
                }
            }
            
            cities = bestCities
            shortestDistance = bestDistance
        }
    }
}

//var testRoute = Route(cities: [london])
//testRoute.shortestDistance
//testRoute.append(city: dublin)
//testRoute.shortestDistance
//testRoute.append(city: belfast)
//testRoute.shortestDistance // 605 (correct)
//testRoute.visualRoute

let exampleInput = """
    London to Dublin = 464
    London to Belfast = 518
    Dublin to Belfast = 141
    """

var exampleCities = [City]()

for line in exampleInput.components(separatedBy: .newlines) {
    let components = line.components(separatedBy: .whitespaces)
    
    let city1Name = components[0]
    let city2Name = components[2]
    let distance = Int(components[4])!
    
    let city1 = City(name: city1Name)
    let city2 = City(name: city2Name)
    
    if exampleCities.contains(city1) == false {
        exampleCities.append(city1)
    }
    
    if exampleCities.contains(city2) == false {
        exampleCities.append(city2)
    }
    
    let realCity1 = exampleCities.first(where: { $0 == city1 })!
    let realCity2 = exampleCities.first(where: { $0 == city2 })!
    
    realCity1[realCity2] = distance
}

exampleCities.count

var exampleRoute = Route()

for city in exampleCities {
    exampleRoute.append(city: city)
}

exampleRoute.cities
exampleRoute.visualRoute
exampleRoute.shortestDistance // 605 (correct)

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

challengeCities.count

//var challengeRoute = Route()
//
//for city in challengeCities {
//    challengeRoute.append(city: city)
//}
//
//challengeRoute.cities
//challengeRoute.visualRoute // Straylight -> Tambi -> Snowdin -> Norrath -> Tristram -> Arbre -> AlphaCentauri -> Faerun = 192 (too high)
//challengeRoute.shortestDistance // 192 (too high)

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

//let cityCombinations = combinations(of: challengeCities)

//print(cityCombinations)
