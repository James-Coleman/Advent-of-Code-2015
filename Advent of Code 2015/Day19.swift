//
//  Day19.swift
//  Advent of Code 2015
//
//  Created by James Coleman on 07/12/2021.
//

import Foundation

func day19() {
    func replacements(from input: String) -> [String: [String]] {
        var dictToReturn = [String: [String]]()
        
        let lines = input.components(separatedBy: .newlines)
        
        for line in lines {
            let components = line.components(separatedBy: .whitespaces)
            let key = components[0]
            let value = components[2]
            
            if let existingArray = dictToReturn[key] {
                let newArray = existingArray + [value]
                dictToReturn[key] = newArray
            } else {
                dictToReturn[key] = [value]
            }
        }
        
        return dictToReturn
    }
    
    func reverseReplacements(from input: String) -> [String: [String]] {
        var dictToReturn = [String: [String]]()
        
        let lines = input.components(separatedBy: .newlines)
        
        for line in lines {
            let components = line.components(separatedBy: .whitespaces)
            let key = components[2] // Note swapped key and value indexes
            let value = components[0]
            
            if let existingArray = dictToReturn[key] {
                let newArray = existingArray + [value]
                dictToReturn[key] = newArray
            } else {
                dictToReturn[key] = [value]
            }
        }
        
        return dictToReturn
    }

    /**
     - Returns:
     Intended to be like an array of ranges
     */
    func indexes(of query: String, in string: String) -> [[Int]] {
        var arrayToReturn = [[Int]]()
        
        outerloop:
        for (index, character) in string.enumerated() {
            if query.first == character {
                if query.count == 1 {
                    arrayToReturn += [[index]]
                } else {
                    var indexes = [Int]()
                    
                    for (queryIndex, queryCharacter) in query.enumerated() {
                        let testIndex = index + queryIndex
                        if let testCharacter = string[safe: String.Index(utf16Offset: testIndex, in: string)], testCharacter == queryCharacter {
                            indexes += [testIndex]
                        } else {
                            continue outerloop
                        }
                    }
                    
                    if let first = indexes.first, let last = indexes.last {
                        indexes = [first, last]
                    }
                    
                    arrayToReturn += [indexes]
                }
            }
        }
        
        return arrayToReturn
    }
    
    func molecules(of input: String, replacements: [String: [String]]) -> Set<String> {
        var setToReturn = Set<String>()
        
        for (key, value) in replacements {
            let occurrences = indexes(of: key, in: input)
            
            for occurrence in occurrences {
                if occurrence.count == 1, let first = occurrence.first {
                    let firstIndex = String.Index(utf16Offset: first, in: input)
                    let lastIndex = input.index(after: firstIndex)
                    let range = firstIndex..<lastIndex
                    
                    for replacement in value {
                        var inputCopy = input
                        inputCopy.replaceSubrange(range, with: replacement)
                        setToReturn.insert(inputCopy)
                    }
                } else if let first = occurrence.first, let last = occurrence.last {
                    let firstIndex = String.Index(utf16Offset: first, in: input)
                    let lastIndex = String.Index(utf16Offset: last, in: input)
                    let range = firstIndex...lastIndex
                    
                    for replacement in value {
                        var inputCopy = input
                        inputCopy.replaceSubrange(range, with: replacement)
                        setToReturn.insert(inputCopy)
                    }
                }
            }
        }
        
        return setToReturn
    }
    
    let puzzleCombinationsInput = """
        Al => ThF
        Al => ThRnFAr
        B => BCa
        B => TiB
        B => TiRnFAr
        Ca => CaCa
        Ca => PB
        Ca => PRnFAr
        Ca => SiRnFYFAr
        Ca => SiRnMgAr
        Ca => SiTh
        F => CaF
        F => PMg
        F => SiAl
        H => CRnAlAr
        H => CRnFYFYFAr
        H => CRnFYMgAr
        H => CRnMgYFAr
        H => HCa
        H => NRnFYFAr
        H => NRnMgAr
        H => NTh
        H => OB
        H => ORnFAr
        Mg => BF
        Mg => TiMg
        N => CRnFAr
        N => HSi
        O => CRnFYFAr
        O => CRnMgAr
        O => HP
        O => NRnFAr
        O => OTi
        P => CaP
        P => PTi
        P => SiRnFAr
        Si => CaSi
        Th => ThCa
        Ti => BP
        Ti => TiTi
        e => HF
        e => NAl
        e => OMg
        """

    let puzzleInitialMolecule = "CRnCaCaCaSiRnBPTiMgArSiRnSiRnMgArSiRnCaFArTiTiBSiThFYCaFArCaCaSiThCaPBSiThSiThCaCaPTiRnPBSiThRnFArArCaCaSiThCaSiThSiRnMgArCaPTiBPRnFArSiThCaSiRnFArBCaSiRnCaPRnFArPMgYCaFArCaPTiTiTiBPBSiThCaPTiBPBSiRnFArBPBSiRnCaFArBPRnSiRnFArRnSiRnBFArCaFArCaCaCaSiThSiThCaCaPBPTiTiRnFArCaPTiBSiAlArPBCaCaCaCaCaSiRnMgArCaSiThFArThCaSiThCaSiRnCaFYCaSiRnFYFArFArCaSiRnFYFArCaSiRnBPMgArSiThPRnFArCaSiRnFArTiRnSiRnFYFArCaSiRnBFArCaSiRnTiMgArSiThCaSiThCaFArPRnFArSiRnFArTiTiTiTiBCaCaSiRnCaCaFYFArSiThCaPTiBPTiBCaSiThSiRnMgArCaF"

    let puzzleReplacements = replacements(from: puzzleCombinationsInput)
    
//    let reversePuzzleReplacements = reverseReplacements(from: puzzleCombinationsInput)

    func stepsTo(create input: String, with replacements: [String: [String]]) -> Int {
        var seeds = Set<String>(["e"])
        var steps = 0
        
        while seeds.contains(input) == false {
            var newSeeds = seeds
            
            for seed in seeds {
                let molecules = molecules(of: seed, replacements: replacements)
                newSeeds.formUnion(molecules)
            }
            
            steps += 1
            
            if seeds == newSeeds {
                print("did nothing")
                break
            }
            
            seeds = newSeeds
        }
        
        return steps
    }
    
    func multithreadedRecursiveStepsTo(create input: String, with replacements: [String: [String]], currentStep: Int = 1, seeds: Set<String>? = nil, completedSteps: Set<String> = []) -> Int {
        let seeds = seeds ?? ["e"]
        
//        print("Step \(currentStep) starting with \(seeds.count) seeds")
        
        var newSeeds = Set<String>()
        
        let parallelQueue = OperationQueue()
        let serialQueue = DispatchQueue(label: "set", qos: .userInitiated)
        
        for seed in seeds {
            var shouldReturn = false
            
            parallelQueue.addOperation {
                let molecules = molecules(of: seed, replacements: replacements)
                if molecules.contains(input) {
                    shouldReturn = true
                }
                let newMolecules = molecules.subtracting(completedSteps)
                serialQueue.sync {
                    newSeeds.formUnion(newMolecules)
//                    print("Step \(currentStep) now \(newSeeds.count) seeds")
                }
            }
            
            if shouldReturn {
                parallelQueue.cancelAllOperations()
                return currentStep
            }
        }
        
        parallelQueue.waitUntilAllOperationsAreFinished()

        return multithreadedRecursiveStepsTo(create: input, with: replacements, currentStep: currentStep + 1, seeds: newSeeds, completedSteps: completedSteps.union(newSeeds))
    }
    
    func reverseStepsTo(reach molecule: String, with replacements: [String: [String]]) -> Int {
        var seeds = Set<String>([molecule])
        var steps = 0
        
        while seeds.contains("e") == false {
            var newSeeds = seeds
            
            for seed in seeds {
                let molecules = molecules(of: seed, replacements: replacements)
                newSeeds.formUnion(molecules)
                if molecules.contains("e") {
                    break
                }
            }
            
            steps += 1
            
            if seeds == newSeeds {
                print("did nothing")
                break
            }
            
            seeds = newSeeds
        }
        
        return steps
    }
    
    func multithreadedRecursiveReverseStepsTo(reach molecule: String, with replacements: [String: [String]], currentStep: Int = 1, seeds: Set<String>? = nil, completedSteps: Set<String> = []) -> Int {
        let seeds = seeds ?? [molecule]
        
        print("Step \(currentStep) checking \(seeds.count) seeds")
        
        var newSeeds = Set<String>()
        
        let parallelQueue = OperationQueue()
        let serialQueue = DispatchQueue(label: "set", qos: .userInitiated)
        
        for seed in seeds {
            var shouldReturn = false
            
            parallelQueue.addOperation {
                let molecules = molecules(of: seed, replacements: replacements)
                if molecules.contains("e") {
                    shouldReturn = true
                }
                let newMolecules = molecules.subtracting(completedSteps)
                serialQueue.sync {
                    newSeeds.formUnion(newMolecules)
                    print("Step \(currentStep) now \(newSeeds.count) seeds")
                }
            }
            
            if shouldReturn {
                parallelQueue.cancelAllOperations()
                return currentStep
            }
        }
        
        parallelQueue.waitUntilAllOperationsAreFinished()
        
        return multithreadedRecursiveReverseStepsTo(reach: molecule, with: replacements, currentStep: currentStep + 1, seeds: newSeeds, completedSteps: completedSteps.union(newSeeds))
    }
    
//    print(stepsTo(create: puzzleInitialMolecule, with: puzzleReplacements))
    
//    print(reverseStepsTo(reach: puzzleInitialMolecule, with: reversePuzzleReplacements))
    
//    print(multithreadedRecursiveReverseStepsTo(reach: puzzleInitialMolecule, with: reversePuzzleReplacements))
    
    print(multithreadedRecursiveStepsTo(create: puzzleInitialMolecule, with: puzzleReplacements))
}
