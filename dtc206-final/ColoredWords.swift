//
//  Colored Words.swift
//  dtc206-final
//
//  Created by main on 4/28/25.
//

import SwiftUI
import Speech

struct WordColorTuple: Identifiable {
    var id: UUID = UUID()

    var text: String
    var color: Color
    var alternativeTexts: [String]
    var confidence: Float
}

struct ColoredWords: View {
    let segments: [SFTranscriptionSegment]

    @State private var showActionSheet: Bool = false

    @State private var selectedOption: String?

    var body: some View {
        HStack(spacing: 0) {
            ForEach(wordsWithColors) { word in
                tupleView(from: word)
            }
        }
    }

    func tupleView(from word: WordColorTuple) -> some View {
        VStack {
            Text(word.text)
                .foregroundColor(word.color)
                .font(.headline)
                .lineLimit(1)
            ForEach(word.alternativeTexts, id: \.self) { altText in
                Text("ALT: \(altText)")
            }
            Text(String(format: "CI: %.2f%%", word.confidence * 100))
                .font(.caption)
        }
        .padding() // Padding inside the VStack
        .border(word.color, width: 2) // Border color
        .cornerRadius(10) // Rounded corners
        .padding(1)
    }

    var wordsWithColors: [WordColorTuple] {

        return segments.enumerated().map { index, word in

            print(index, word)
            let color = getColorForCI(word.confidence)
            return WordColorTuple(text: word.substring, color: color, alternativeTexts: word.alternativeSubstrings, confidence: word.confidence)
        }
    }

    private func getColorForCI(_ ci: Float) -> Color {
        precondition(ci >= 0 && ci <= 1, "Confidence value must be between 0 and 1")

        let red: Double = Double(ci)
        let green: Double = Double(1.0 - ci)

        return Color(red: red, green: green, blue: 0.0)
    }
}
