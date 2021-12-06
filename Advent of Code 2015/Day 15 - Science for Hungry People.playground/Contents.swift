import Foundation

var greeting = "Hello, playground"

struct Ingredient {
    let capacity: Int
    let durability: Int
    let flavour: Int
    let texture: Int
    let calories: Int
}

struct Cookie {
    let ingredients: [Ingredient]
    
    var score: Int {
        let capacitySum = ingredients.reduce(0) { soFar, next in
            soFar + next.capacity
        }
        let durabilitySum = ingredients.reduce(0) { soFar, next in
            soFar + next.durability
        }
        let flavourSum = ingredients.reduce(0) { soFar, next in
            soFar + next.flavour
        }
        let textureSum = ingredients.reduce(0) { soFar, next in
            soFar + next.texture
        }
        
        guard
            capacitySum > 0,
            durabilitySum > 0,
            flavourSum > 0,
            textureSum > 0
        else { return 0 }
        
        return capacitySum * durabilitySum * flavourSum * textureSum
    }
}

let exampleButterscotch = Ingredient(capacity: -1, durability: -2, flavour: 6, texture: 3, calories: 8)
let exampleCinnamon = Ingredient(capacity: 2, durability: 3, flavour: -2, texture: -1, calories: 3)

let exampleCookie = Cookie(ingredients: Array(repeating: exampleButterscotch, count: 44) + Array(repeating: exampleCinnamon, count: 56))

exampleCookie.score // 62842880 (correct)

let sprinkles = Ingredient(capacity: 2, durability: 0, flavour: -2, texture: 0, calories: 3)
let butterscotch = Ingredient(capacity: 0, durability: 5, flavour: -3, texture: 0, calories: 3)
let chocolate = Ingredient(capacity: 0, durability: 0, flavour: 5, texture: -1, calories: 8)
let candy = Ingredient(capacity: 0, durability: -1, flavour: 0, texture: 5, calories: 8)


