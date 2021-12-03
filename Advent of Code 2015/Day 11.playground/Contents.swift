import Foundation

var greeting = "Hello, playground"

let lowercaseCharacters: [Character] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]

/// Doesn't include "i", "o" or "l"
let validCharacters: [Character] = ["a", "b", "c", "d", "e", "f", "g", "h", "j", "k", "m", "n", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]

func has8Letters(_ password: String) -> Bool {
    password.count == 8
}

enum Error: Swift.Error {
    case characterNotFound(Character)
}

func hasIncreasingThreeCharacters(_ password: String) throws -> Bool {
    outerloop:
    for (index, character) in password.enumerated() {
        guard index <= password.count - 3 else { return false }
        
        guard let firstIndex = lowercaseCharacters.firstIndex(of: character) else { throw Error.characterNotFound(character) }
        guard firstIndex <= lowercaseCharacters.count - 3 else { continue }
        
        for i in 1...2 {
            let nextPasswordCharacterIndex = index + i
            let nextLowercaseIndex = firstIndex + i
            
            let nextPasswordCharacter = password[String.Index(encodedOffset: nextPasswordCharacterIndex)]
            let nextLowercaseCharacter = lowercaseCharacters[nextLowercaseIndex]
            
            guard nextPasswordCharacter == nextLowercaseCharacter else { continue outerloop }
        }
        
        return true
    }
    
    return false
}

do {
    try hasIncreasingThreeCharacters("abc")
    try hasIncreasingThreeCharacters("abd")
    try hasIncreasingThreeCharacters("abdabc")
    try hasIncreasingThreeCharacters("hijklmmn")
} catch {
    print(error)
}

func hasValidCharacters(_ password: String) -> Bool {
    for character in password {
        if validCharacters.contains(character) == false {
            return false
        }
    }
    
    return true
}

hasValidCharacters("hijklmmn")

func containsPairs(_ password: String) -> Bool {
    var firstPair: Character?
    var skipNext = false
    
    for (index, character) in password.enumerated() {
        guard index <= password.count - 2 else { return false }
        
        if skipNext {
            skipNext = false
            continue
        }
        
        let nextIndex = index + 1
        
        let nextCharacter = password[String.Index(encodedOffset: nextIndex)]
        
        if character == nextCharacter {
            if firstPair == nil {
                firstPair = character
                skipNext = true
            } else {
                return true
            }
        }
    }
    
    return false
}

containsPairs("abbceffg")
containsPairs("abbcegjk")

func isValid(password: String) throws -> Bool {
    guard has8Letters(password),
          try hasIncreasingThreeCharacters(password),
          hasValidCharacters(password),
          containsPairs(password)
    else { return false }
    
    return true
          
}

do {
    try isValid(password: "abcdefgh")
    try isValid(password: "abcdffaa")
    try isValid(password: "ghijklmn")
    try isValid(password: "ghjaabcc")
} catch {
    print(error)
}

func incrementLetter(of password: String, at index: Int) throws -> (next: String, rollover: Bool) {
    var rolledOver = false
    var characters = Array(password)
    let character = characters[index]
    guard let characterIndex = lowercaseCharacters.firstIndex(of: character) else { throw Error.characterNotFound(character) }
    var nextIndex = characterIndex + 1
    if nextIndex >= lowercaseCharacters.count {
        rolledOver = true
        nextIndex = 0
    }
    let nextCharacter = lowercaseCharacters[nextIndex]
    characters[index] = nextCharacter
    let nextPassword = characters.reduce("") { soFar, next in
        return soFar + String(next)
    }
    return (nextPassword, rolledOver)
}

func nextPassword(after password: String) throws -> String {
    var index = password.count - 1
    var password = password
    
    while try isValid(password: password) == false {
        let (nextPassword, rolledover) = try incrementLetter(of: password, at: index)
        password = nextPassword
        if rolledover {
            index -= 1
        } else {
            index = password.count - 1
        }
    }
    
    return password
}

do {
    try nextPassword(after: "hepxcrrq")
} catch {
    print(error)
}
