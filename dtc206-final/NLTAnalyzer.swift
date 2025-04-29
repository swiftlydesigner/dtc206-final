//
//  NLTAnalyzer.swift
//  dtc206-final
//
//  Created by Kyle Parker on 4/28/25.
//

import SwiftUI
import NaturalLanguage

struct NLTAnalyzerResult: Identifiable {
    var id: UUID = UUID()

    // Required members
    var origWord: String
    var modifiedWord: String
    var type: String

    // Computed vars
    var valid: Bool { return origWord == modifiedWord }
}

public class NLTAnalyzer {
    func process(_ text: String) -> [NLTAnalyzerResult] {
        var result: [NLTAnalyzerResult] = []

        let tagger = NLTagger(tagSchemes: [.lexicalClass])
        tagger.string = text


        // Use the full range of the string
        let range = text.startIndex..<text.endIndex

        tagger.enumerateTags(in: range, unit: .word, scheme: .lexicalClass) { tag, tokenRange in
            let token = String(text[tokenRange])
            var modifiedToken = token

            if tag == .personalName || tag == .organizationName || tag == .placeName {
                modifiedToken = token.uppercased()
            }

            result.append(
                NLTAnalyzerResult(origWord: token,
                                  modifiedWord: modifiedToken,
                                  type: tag?.rawValue ?? "Unknown")
            )
            return true // Continue enumeration
        }

        return result
    }
}
