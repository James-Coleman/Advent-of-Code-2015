import Foundation

var greeting = "Hello, playground"

func nextLookAndSay(from input: String) -> String {
    var stringToReturn = ""
    
    var currentCharacter: Character?
    var currentCharacterCount = 0
    
    for character in input {
        if let existingCharacter = currentCharacter {
            if character == existingCharacter {
                currentCharacterCount += 1
            } else {
                stringToReturn += String(currentCharacterCount)
                stringToReturn.append(existingCharacter)
                
                currentCharacter = character
                currentCharacterCount = 1
            }
        } else {
            currentCharacter = character
            currentCharacterCount = 1
        }
    }
    
    if let existingCharacter = currentCharacter {
        stringToReturn += String(currentCharacterCount)
        stringToReturn.append(existingCharacter)
    }
    
    return stringToReturn
}

nextLookAndSay(from: "1")
nextLookAndSay(from: "11")
nextLookAndSay(from: "21")
nextLookAndSay(from: "1211")
nextLookAndSay(from: "111221")

var challenge = "3113322113"

//for _ in 1...40 {
//    challenge = nextLookAndSay(from: challenge)
//}

challenge.count // Would be 329356 (correct)
