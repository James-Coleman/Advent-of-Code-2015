import Foundation

var greeting = "Hello, playground"

struct Item {
    let cost: Int
    let damage: Int?
    let heal: Int?
    let armour: Int?
    let mana: Int?
    /// This might not be necessary as items will be treated on an individual basis
    let lifetime: Int?
    var elapsedLife: Int? = nil
    
    static let magicMissile = Item(cost: 53, damage: 4, heal: nil, armour: nil, mana: nil, lifetime: nil)
    static let drain = Item(cost: 73, damage: 2, heal: 2, armour: nil, mana: nil, lifetime: nil)
    static let shield = Item(cost: 113, damage: nil, heal: nil, armour: 7, mana: nil, lifetime: 6)
    static let poison = Item(cost: 173, damage: 3, heal: nil, armour: nil, mana: nil, lifetime: 6)
    static let recharge = Item(cost: 229, damage: 0, heal: 0, armour: 0, mana: 101, lifetime: 5)

}

struct Player {
    var hitPoints = 50
    var mana = 500
    var manaSpent = 0
    
    
    var shield: Item?
    var poison: Item?
    var recharge: Item?
}

struct PlayerGenerator {
    static func oneStep(after player: Player) -> Player {
        var player = player
        if let shield = player.shield {
            if shield.elapsedLife == nil {
                
            } else {
                
            }
        }
        
        return player
    }
    
    static func nextPlayers(from player: Player) -> [Player] {
        var array = [Player]()
        
        
        
        return array
    }
}
