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
                print(arrayCopy)
                
                var totalDistance = 0
                
                for (index, city) in arrayCopy.enumerated() {
                    if index == 0 { continue }
                    
                    let previousCity = arrayCopy[index - 1]
                    
                    if let distance = previousCity[city] {
                        totalDistance += distance
                    } else {
                        print("No distance from \(previousCity) to \(city)")
                    }
                }
                
                print(totalDistance)
                
                if let shortestDistanceUnwrapped = bestDistance {
                    if totalDistance < shortestDistanceUnwrapped {
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

var testRoute = Route(cities: [london])
testRoute.shortestDistance
testRoute.append(city: dublin)
testRoute.shortestDistance
testRoute.append(city: belfast)
testRoute.shortestDistance // 605 (correct)
testRoute.visualRoute


