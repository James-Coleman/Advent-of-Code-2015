import Foundation

var greeting = "Hello, playground"

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
    
    func distancesToCities(existing: [([City], Int)]) -> [([City], Int)] {
        if existing.isEmpty {
            let firstDistances = distances.map { city, distance in
                ([self, city], distance)
            }
            
            return distances.flatMap { $0.key.distancesToCities(existing: firstDistances) }
        } else if let first = existing.first, first.0.count == distances.count {
            // All cities have been visited
            // Could this return early?
            return existing
        } else {
            return existing
            
            return distances.compactMap { (city, distance) in
                nil
            }
            
            for (cities, distanceSoFar) in existing {
                for (city, distance) in distances {
                    if cities.contains(city) { continue }
                    
                    
                }
            }
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

//City(name: "London", distances: ["Dublin": 464,
//                                 "Belfast": 518])
//City(name: "Dublin", distances: ["Belfast": 141])

let dict: [String: [String: Int]] = ["London": ["Dublin": 464,
                                                "Belfast": 518],
                                     "Dublin": ["Belfast": 141]]

// MARK: Tried to get simple and failed

let distances = [464, 518, 141]

var smallestDistance: Int? = nil

outerLoop:
for (index1, distance1) in distances.enumerated() {
    var distanceSoFar = distance1
    
    innerLoop:
    for (index2, distance2) in distances.enumerated() {
        guard index2 > index1 else { continue }
        
        distanceSoFar += distance2
        
        if let smallestDistance = smallestDistance, distanceSoFar > smallestDistance {
            continue outerLoop
        }
    }
    
    if let smallestDistanceUnwrapped = smallestDistance {
        if distanceSoFar < smallestDistanceUnwrapped {
            smallestDistance = distanceSoFar
        }
    } else {
        smallestDistance = distanceSoFar
    }
}

smallestDistance

// MARK: Re-trying class approach

let london = City(name: "London")
let dublin = City(name: "Dublin")
let belfast = City(name: "Belfast")

london[dublin] = 464
london[belfast] = 518
dublin[belfast] = 141

london[dublin]
dublin[london]

let cities = [london, dublin]
cities.contains(london)
cities.contains(belfast)

func visualRoute(_ tuple: ([City], Int)) -> String {
    let cityString = tuple.0.enumerated().reduce("") { soFar, next in
        let (index, city) = next
        if index == 0 {
            return city.name
        } else {
            return soFar + " -> " + city.name
        }
    }
    
    return cityString + " = " + String(tuple.1)
}

//let testDistances = london.distancesToCities(existing: [])
//
//for route in testDistances {
//    print(visualRoute(route))
//}

if let belfastToDublin = belfast[dublin], let dublinToLondon = dublin[london] {
    belfastToDublin + dublinToLondon
}

struct Routes {
    let cities: [City]
    
    var shortestRoute: ([City], Int)?
    
    mutating func calculateShortestRoute() {
        let cityCount = cities.count
        
        for startingCity in cities {
            
        }
        
        shortestRoute = ([], 0)
    }
}

struct Route {
    var cities = [City]()
    var shortestDistance: Int? = nil
    
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



