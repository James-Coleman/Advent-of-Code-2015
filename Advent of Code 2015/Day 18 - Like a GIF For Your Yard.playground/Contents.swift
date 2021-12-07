import Foundation

var greeting = "Hello, playground"

extension Collection {
    subscript (safe i: Index) -> Element? {
        if indices.contains(i) {
            return self[i]
        } else {
            return nil
        }
    }
}

class Light {
    var on: Bool
    var neighbours: [Light] = []
    var nextState: Bool = false
    
    init(_ on: Bool) {
        self.on = on
    }
    
    static func factory(_ input: String) -> [[Light]] {
        let lines = exampleInput.components(separatedBy: .newlines)
        
        let lights = lines.map { string in
            string.map { character in
                Light(character == "#")
            }
        }
        
        for (y, row) in lights.enumerated() {
            for (x, column) in row.enumerated() {
                var newNeighbours = [Light]()
                
                if let light = lights[safe: y - 1]?[safe: x - 1] {
                    newNeighbours += [light]
                }
                if let light = lights[safe: y - 1]?[safe: x] {
                    newNeighbours += [light]
                }
                if let light = lights[safe: y - 1]?[safe: x + 1] {
                    newNeighbours += [light]
                }
                if let light = lights[safe: y]?[safe: x + 1] {
                    newNeighbours += [light]
                }
                if let light = lights[safe: y + 1]?[safe: x + 1] {
                    newNeighbours += [light]
                }
                if let light = lights[safe: y + 1]?[safe: x] {
                    newNeighbours += [light]
                }
                if let light = lights[safe: y + 1]?[safe: x - 1] {
                    newNeighbours += [light]
                }
                if let light = lights[safe: y]?[safe: x - 1] {
                    newNeighbours += [light]
                }
                column.neighbours = newNeighbours
            }
        }
        
        return lights
    }
    
    static func debugString(_ input: [[Light]]) -> String {
        var stringToReturn = ""
        
        for row in input {
            for light in row {
                if light.on {
                    stringToReturn += "#"
                } else {
                    stringToReturn += "."
                }
            }
            
            stringToReturn += "\n"
        }
        
        return stringToReturn
    }
    
    static func nextStep(_ input: [[Light]]) {
        for row in input {
            for light in row {
                let neighboursOn = light.neighbours.filter { $0.on }
                let neighboursOnCount = neighboursOn.count
                
                if light.on {
                    light.nextState = (neighboursOnCount == 2 || neighboursOnCount == 3)
                } else {
                    light.nextState = (neighboursOnCount == 3)
                }
            }
        }
        
        for row in input {
            for light in row {
                light.on = light.nextState
            }
        }
    }
}

let exampleInput = """
    .#.#.#
    ...##.
    #....#
    ..#...
    #.#..#
    ####..
    """

let exampleLights = Light.factory(exampleInput)

print(Light.debugString(exampleLights))

for _ in 1...4 {
    Light.nextStep(exampleLights)
    
    print("-")
    
    print(Light.debugString(exampleLights))
}

let exampleAnswer = exampleLights.flatMap { $0.filter { $0.on }}.count
exampleAnswer // 4 (correct)