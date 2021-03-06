//
//  Helpers.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/12/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

import CommonCrypto
import Foundation

// MARK: - String

extension String {
    static func input(forDay day: Int, year: Int = 2018) -> String {
        return try! String(contentsOfFile: "/Users/jshier/Desktop/Code/AdventOfCode/Inputs/\(year)/day\(day).txt")
    }
    
    func byLines() -> [String] {
        return split(separator: "\n").map(String.init)
    }
    
    func byTabs() -> [String] {
        return split(separator: "\t").map(String.init)
    }
    
    func bySpaces() -> [String] {
        return split(separator: " ").map(String.init)
    }
    
    mutating func swapAt(_ first: Int, _ second: Int) {
        let firstIndex = index(startIndex, offsetBy: first)
        let secondIndex = index(startIndex, offsetBy: second)
        swapAt(firstIndex, secondIndex)
    }
    
    mutating func swapAt(_ first: Index, _ second: Index) {
        let firstString = String(self[first])
        let secondString = String(self[second])
        replaceSubrange(first..<index(after: first), with: secondString)
        replaceSubrange(second..<index(after: second), with: firstString)
    }
    
    mutating func filteringDestructive(_ token: Character) {
        var currentIndex = startIndex
        while currentIndex != endIndex {
            let character = self[currentIndex]
            if character == token {
                let nextIndex = index(after: currentIndex)
                removeSubrange(currentIndex...nextIndex)
            } else {
                currentIndex = index(after: currentIndex)
            }
        }
    }
    
    var unicodeValues: [Int] {
        return map { $0.unicodeValue }
    }
    
    /// Extremely inefficient!
    subscript(index: Int) -> Character {
        return self[self.index(startIndex, offsetBy: index)]
    }
    
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

extension Character {
    var unicodeValue: Int {
        return Int(unicodeScalars.first!.value)
    }
}

// MARK: - Array

extension Collection where Index == Int {
    func cycle() -> UnfoldSequence<Element, Int> {
        return sequence(state: 0) { (index: inout Int) in
            let x = self[index]
            index = self.circularIndex(after: index)
            return x
        }
    }
    
    func circularIndex(_ from: Index, offsetBy offset: Int) -> Index {
        return (from + offset) % count
    }
    
    func circularIndex(after: Index) -> Index {
        guard after < endIndex else { return 0 }
        
        return circularIndex(after, offsetBy: 1)
    }
}

extension Sequence where Element == Int {
    var asString: String {
        return map(String.init).joined()
    }
}

extension Collection where Element: Comparable {
    func maxValueIndex() -> (value: Element, index: Index)? {
        guard !isEmpty else { return nil }
        
        var maxValue = first!
        var maxIndex = startIndex
        for (index, element) in zip(indices, self) {
            if element > maxValue {
                maxValue = element
                maxIndex = index
            }
        }
        
        return (value: maxValue, index: maxIndex)
    }
}

extension Collection where Element: Equatable {
    func allElementsEqual() -> Bool {
        guard !isEmpty else { return false }
        
        return allSatisfy { $0 == first }
    }
}

extension Sequence {
    func count(where predicate: (Element) -> Bool) -> Int {
        var count = 0
        for element in self {
            if predicate(element) {
                count += 1
            }
        }

        return count
    }
    
    func accumulate<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Element) -> Result) -> [Result] {
        var running = initialResult
        return map { next in
            running = nextPartialResult(running, next)
            return running
        }
    }
}

extension Int {
    func lower16BitsEqual(lower16BitsOf int: Int) -> Bool {
        return Int16(truncatingIfNeeded: self) == Int16(truncatingIfNeeded: int)
    }
    
    var paddedBinaryRepresentation: String {
        let string = String(self, radix: 2)
        let padding = String(repeating: "0", count: (8 - string.count))
        return padding + string
    }
}

extension Data {
    var hexString: String {
        return map { String(format: "%02x", $0) }.joined()
    }
}
