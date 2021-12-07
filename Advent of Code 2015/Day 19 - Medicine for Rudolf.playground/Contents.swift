import Foundation

var greeting = "Hello, playground"

extension Collection {
    subscript (safe index: Index) -> Element? {
        if indices.contains(index) {
            return self[index]
        } else {
            return nil
        }
    }
}

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


let exampleInput = """
    H => HO
    H => OH
    O => HH
    """

//let exampleReplacements = replacements(from: exampleInput)

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

//indexes(of: "H", in: "HOH")
//indexes(of: "HO", in: "HOH")
//indexes(of: "OH", in: "HOH")
//indexes(of: "HOH", in: "HOH")

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
//                    print(inputCopy)
//                    print("replaced \(key) at \(first) with \(replacement)")
                    setToReturn.insert(inputCopy)
                }
            } else if let first = occurrence.first, let last = occurrence.last {
                let firstIndex = String.Index(utf16Offset: first, in: input)
                let lastIndex = String.Index(utf16Offset: last, in: input)
                let range = firstIndex...lastIndex
                
                for replacement in value {
                    var inputCopy = input
                    inputCopy.replaceSubrange(range, with: replacement)
//                    print(inputCopy)
//                    print("replaced \(key) between \(first) and \(last) with \(replacement)")
                    setToReturn.insert(inputCopy)
                }
            }
        }
    }
    
    return setToReturn
}

//molecules(of: "HOH", replacements: exampleReplacements)
//molecules(of: "HOHOHO", replacements: exampleReplacements)

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

let puzzleReplacements = replacements(from: puzzleCombinationsInput)

let puzzleInitialMolecule = "CRnCaCaCaSiRnBPTiMgArSiRnSiRnMgArSiRnCaFArTiTiBSiThFYCaFArCaCaSiThCaPBSiThSiThCaCaPTiRnPBSiThRnFArArCaCaSiThCaSiThSiRnMgArCaPTiBPRnFArSiThCaSiRnFArBCaSiRnCaPRnFArPMgYCaFArCaPTiTiTiBPBSiThCaPTiBPBSiRnFArBPBSiRnCaFArBPRnSiRnFArRnSiRnBFArCaFArCaCaCaSiThSiThCaCaPBPTiTiRnFArCaPTiBSiAlArPBCaCaCaCaCaSiRnMgArCaSiThFArThCaSiThCaSiRnCaFYCaSiRnFYFArFArCaSiRnFYFArCaSiRnBPMgArSiThPRnFArCaSiRnFArTiRnSiRnFYFArCaSiRnBFArCaSiRnTiMgArSiThCaSiThCaFArPRnFArSiRnFArTiTiTiTiBCaCaSiRnCaCaFYFArSiThCaPTiBPTiBCaSiThSiRnMgArCaF"

let puzzleMolecules = molecules(of: puzzleInitialMolecule, replacements: puzzleReplacements)

puzzleMolecules.count // 535 (correct)
