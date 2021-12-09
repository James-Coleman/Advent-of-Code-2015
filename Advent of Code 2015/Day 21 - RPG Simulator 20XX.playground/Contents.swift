import Foundation

var greeting = "Hello, playground"

struct Item: Equatable {
    let name: String
    let cost: Int
    let damage: Int
    let armour: Int
}

let weapons = [Item(name: "Dagger", cost: 8, damage: 4, armour: 0),
               Item(name: "Shortsword", cost: 10, damage: 5, armour: 0),
               Item(name: "Warhammer", cost: 25, damage: 6, armour: 0),
               Item(name: "Longsword", cost: 40, damage: 7, armour: 0),
               Item(name: "Greataxe", cost: 74, damage: 8, armour: 0)]

let armours = [nil,
              Item(name: "Leather", cost: 13, damage: 0, armour: 1),
              Item(name: "Chainmail", cost: 31, damage: 0, armour: 2),
              Item(name: "Splintmail", cost: 53, damage: 0, armour: 3),
              Item(name: "Bandedmail", cost: 75, damage: 0, armour: 4),
              Item(name: "Platemail", cost: 102, damage: 0, armour: 5)]

let rings = [nil,
             Item(name: "Damage +1", cost: 25, damage: 1, armour: 0),
             Item(name: "Damage +2", cost: 50, damage: 2, armour: 0),
             Item(name: "Damage +3", cost: 100, damage: 3, armour: 0),
             Item(name: "Defence +1", cost: 20, damage: 0, armour: 1),
             Item(name: "Defence +2", cost: 40, damage: 0, armour: 2),
             Item(name: "Defence +3", cost: 80, damage: 0, armour: 3)]

struct Player {
    let items: [Item]
    
    let totalCost: Int
    let totalDamage: Int
    let totalArmour: Int
    
    init(items: [Item?]) {
        let realItems = items.compactMap { $0 }
        
        self.items = realItems
        
        let (cost, damage, armour) = realItems.reduce((0, 0, 0)) { soFar, next in
            (soFar.0 + next.cost, soFar.1 + next.damage, soFar.2 + next.armour)
        }
        
        self.totalCost = cost
        self.totalDamage = damage
        self.totalArmour = armour
    }
    
    init(damage: Int, armour: Int) {
        self.items = []
        
        self.totalCost = 0
        self.totalDamage = damage
        self.totalArmour = armour
    }
    
    func win(against opponent: Player) -> Bool {
        var selfHealth = 100
        var opponentHealth = 100
        
        let continueScenario = { selfHealth > 0 && opponentHealth > 0 }
        let winningScenario = { selfHealth > 0 && opponentHealth <= 0 }
        
        while continueScenario() {
            let damageToOpponent = totalDamage - opponent.totalArmour
            let realDamageToOpponent = damageToOpponent < 1 ? 1 : damageToOpponent
            opponentHealth -= realDamageToOpponent
            
            if continueScenario() == false {
                return winningScenario()
            }
            
            let damageToSelf = opponent.totalDamage - totalArmour
            let realDamageToSelf = damageToSelf < 1 ? 1 : damageToSelf
            selfHealth -= realDamageToSelf
        }
        
        return winningScenario()
    }
}

let opponent = Player(damage: 8, armour: 2)

func part1() {
    var cheapestWin: Player?
    
    for weapon in weapons {
        for armour in armours {
            for ring1 in rings {
                for ring2 in rings {
                    if let ring1 = ring1, let ring2 = ring2, ring1 == ring2 { continue }
                    
                    let player = Player(items: [weapon, armour, ring1, ring2])
                    
                    player.totalCost
                    
                    if player.win(against: opponent) {
                        if let existingCheapestWin = cheapestWin, player.totalCost < existingCheapestWin.totalCost {
                            cheapestWin = player
                        } else if cheapestWin == nil {
                            cheapestWin = player
                        }
                    }
                }
            }
        }
    }
    
    cheapestWin?.totalCost // 91 (correct)
    cheapestWin?.items // Longsword, chainmail, defence + 1
}

//part1()

func part2() {
    var mostExpensiveLoss: Player?
    
    for weapon in weapons {
        for armour in armours {
            for ring1 in rings {
                for ring2 in rings {
                    if let ring1 = ring1, let ring2 = ring2, ring1 == ring2 { continue }
                    
                    let player = Player(items: [weapon, armour, ring1, ring2])
                    
                    player.totalCost
                    
                    if player.win(against: opponent) == false {
                        if let existingExpensiveLoss = mostExpensiveLoss, player.totalCost > existingExpensiveLoss.totalCost {
                            mostExpensiveLoss = player
                        } else if mostExpensiveLoss == nil {
                            mostExpensiveLoss = player
                        }
                    }
                }
            }
        }
    }

    mostExpensiveLoss?.totalCost // 158 (correct)
    mostExpensiveLoss?.items // dagger, damage +2, damage +3
}

//part2()
