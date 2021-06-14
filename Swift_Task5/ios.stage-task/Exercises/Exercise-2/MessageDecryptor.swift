import UIKit

class MessageDecryptor: NSObject {
    var inputArray = [Character]()
    var outputString = ""
    var multipliers = [Int]()
    var currentLevel = 0

    var levelsIndicies = [[Int]]() // [number of repeat, index of "[", index of "]"]
    var multiplierString = ""
    
    func decryptMessage(_ message: String) -> String {
        inputArray = Array(message)
//        var outputString = ""
//        var multipliers = [Int]()
//        var currentLevel = 0
//
//        var levelsIndicies = [[Int]]() // [number of repeat, index of "[", index of "]"]
//        var multiplierString = ""
        
        if !inputArray[0].isNumber {
            inputArray.insert(Character("1"), at: 0)
        }
        
        if String(inputArray[1]) != "[" {
            inputArray.insert(Character("["), at: 1)
            inputArray.append(Character("]"))
        }
        
        repeat {
            createArrayWithInsideIndcies(&inputArray)
        } while inputArray.contains(Character("["))
        outputString = String(inputArray)
        print(outputString)
        return outputString
    }
    
    func createArrayWithInsideIndcies(_ inputArray:inout [Character]) {
        levelsIndicies = [[Int]]()
        currentLevel = 0
        
        for (index, character) in inputArray.enumerated() {
            switch character {
            case _ where character.isNumber:
                multipliers.append(Int(String(character))!)
                print(levelsIndicies.count)
                print(currentLevel)
                if (levelsIndicies.count < currentLevel + 1) { levelsIndicies.append([]) }
                multiplierString.append(String(character))
            case _ where String(character) == "[":
                levelsIndicies[currentLevel].append(Int(String(multiplierString))!)
                multiplierString = ""
                if (levelsIndicies.count < currentLevel + 1) { levelsIndicies.append([]) }
                levelsIndicies[currentLevel].append(index)
                currentLevel += 1
            case _ where String(character) == "]":
                currentLevel -= 1
                levelsIndicies[currentLevel].append(index)
            case _ where character.isASCII:
                continue
//                    currentLevelString += String(character)
            default:
                print("Error: Wrong symbol in input")
                break
            }
        }
        
        guard var array = levelsIndicies.last else { return }
        
        let stringInterval = String(inputArray[array[1]+1..<array[2]])
        let stringToReplace = String(repeating: stringInterval, count: array[0])
        if array[0] < 10 {
            inputArray.replaceSubrange(array[1]-1...array[2], with: Array(stringToReplace))
        } else if array[0] >= 10 && array[0] < 100 {
            inputArray.replaceSubrange(array[1]-2...array[2], with: Array(stringToReplace))
        } else if array[0] >= 100 && array[0] < 1000 {
            inputArray.replaceSubrange(array[1]-3...array[2], with: Array(stringToReplace))
        }
            array.removeSubrange(0...2)
    }
}

extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}
