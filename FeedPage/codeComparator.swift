import UIKit

//023.012.011.007.002

class codeComparator {
    
    var match = 0
    
    init(userCode : String, compareWith : String) {
        match = codeComparator(userCode : userCode, compareWith : compareWith)
    }
    
    var userMatch : Int {
        return match
    }

    func codeComparator (userCode : String, compareWith : String) -> Int {
        print("UC" + userCode)
        if userCode.isEmpty {
            return 0
        }
        print(compareWith)
        var matchLevel = 0
        let userResult : [String] = (split(length: 2, code: userCode))
        var compareResult : [String] = (split(length: 2, code: compareWith))
        while userResult.count > compareResult.count {
            compareResult.append("xx.")
        }
        while userResult.count < compareResult.count {
            compareResult.append("xx.")
        }
        for i in 0...userResult.count-1 {
            if let userInt = Int(userResult[i]), let compareInt = Int(compareResult[i]) {
                let difference = 100 - abs(userInt - compareInt)
                matchLevel += difference
            }
            else {
                matchLevel += 0
            }
        }
        matchLevel = matchLevel / userResult.count
        return matchLevel
    }

    func split(length: Int, code : String) -> [String] {
        var startIndex = code.startIndex
        var results = [Substring]()

        while startIndex < code.endIndex {
            let endIndex = code.index(startIndex, offsetBy: length, limitedBy: code.endIndex) ?? code.endIndex
            results.append(code[startIndex..<endIndex])
            startIndex = code.index(endIndex, offsetBy: 1, limitedBy: code.endIndex) ?? code.endIndex
        }

        return results.map { String($0) }
    }
}

