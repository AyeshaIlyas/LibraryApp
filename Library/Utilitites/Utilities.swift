//
//  Utilities.swift
//  Library
//
//  Created by Ayesha Ilyas on 4/13/22.
//

import Foundation

final class Utilities {
    // static declarations are implictly final
    static func isEmpty(_ s: String ) -> Bool {
        if s.range(of: #"^\s*$"#, options: .regularExpression) != nil {
            return true
        }
        return false
    }
    
    static func parseString(_ s: String) -> String {
        return s.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
