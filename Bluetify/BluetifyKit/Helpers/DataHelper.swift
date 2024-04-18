//
//  DataHelper.swift
//  Bluetify
//
//  Created by M Alfin Syahruddin on 03/04/24.
//

import Foundation


extension Data {
    func asString() -> String {
        String(data: self, encoding: .utf8) ?? ""
    }
    
    func asBool() -> Bool {
        Bool(self.asString()) ?? false
    }
    
    func asInt() -> Int {
        self.withUnsafeBytes { $0.load(as: Int.self) }
    }
    
    func asReversedInt() -> Int {
        Int(self.reversed().withUnsafeBytes { $0.load(as: Int32.self) })
    }
}

extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }
    
    func asHex(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
}

extension Int {
    func asData() -> Data {
        return withUnsafeBytes(of: self) { Data($0) }
    }
}

extension String {
    func asData() -> Data {
        self.data(using: .utf8) ?? Data()
    }
}
