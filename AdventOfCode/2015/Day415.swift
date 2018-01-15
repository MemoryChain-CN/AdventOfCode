//
//  Day415.swift
//  AdventOfCode
//
//  Created by Jon Shier on 1/8/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day415: Day {
    override func perform() {
        let input = "ckczppom"
        
        var count = 0
        var hex = ""
        repeat {
            hex = "\(input)\(count)".md5()
            count += 1
        } while hex.prefix(5) != "00000"
        
        stageOneOutput = "\(count - 1)"
        
        count = 0
        var dataHex = Data()
        let threeZeroBytes = Data(repeating: 0, count: 3)
        repeat {
            dataHex = "\(input)\(count)".md5Data()
            count += 1
            if count % 1_000_000 == 0 { print(count) }
        } while dataHex.prefix(3) != threeZeroBytes
        
        stageTwoOutput = "\(count - 1)"
    }
}

extension String {
    func md5Data() -> Data {
        let messageData = Data(utf8)
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes { digestBytes in
            messageData.withUnsafeBytes { messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        
        return digestData
    }
    
    func md5() -> String {
        return md5Data().hexString
    }
}

extension Data {
    var hexString: String {
        return map { String(format: "%02x", $0) }.joined()
    }
}