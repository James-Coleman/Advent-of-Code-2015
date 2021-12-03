//
//  Day10.swift
//  Advent of Code 2015
//
//  Created by James Coleman on 03/12/2021.
//

import Foundation

func day10() {
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

    var challenge = "3113322113"

    for _ in 1...50 { // change to 40 for part 1
        challenge = nextLookAndSay(from: challenge)
    }

    print(challenge.count) // part 1: 329356 (correct), part 2: 4666278 (correct)
}
