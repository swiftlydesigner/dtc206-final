//
//  Colored Words.swift
//  dtc206-final
//
//  Created by main on 4/28/25.
//

import SwiftUI
import Speech

struct WordColorPair: Identifiable {
    var id: UUID = UUID()

    var text: String
    var color: Color
}

struct ColoredWords: View {
    let segments: [SFTranscriptionSegment]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(wordsWithColors) { word in
                Text(word.text)
                    .foregroundColor(word.color)
                    .font(.headline)
                    .padding(2)
            }
        }
    }

    var wordsWithColors: [WordColorPair] {

        return segments.enumerated().map { index, word in
            let color = getColorForCI(word.confidence)
            return WordColorPair(text: word.substring, color: color)
        }
    }

    private func getColorForCI(_ ci: Float) -> Color {
        precondition(ci >= 0 && ci <= 1, "Confidence value must be between 0 and 1")

        let red: Double = Double(ci)
        let green: Double = Double(1.0 - ci)

        return Color(red: red, green: green, blue: 0.0)
    }
}
