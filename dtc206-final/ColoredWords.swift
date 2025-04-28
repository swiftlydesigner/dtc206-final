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
    var alternativeTexts: [String] = []
}

struct ColoredWords: View {
    let segments: [SFTranscriptionSegment]

    @State private var showActionSheet: Bool = false

    @State private var selectedOption: String?

    var body: some View {
        HStack(spacing: 0) {
            ForEach(wordsWithColors) { word in
                Text(word.text)
                    .foregroundColor(word.color)
                    .font(.headline)
                    .padding(2)
                    .onTapGesture {
                        showActionSheet = true
                    }
                    .actionSheet(isPresented: $showActionSheet) {
                        ActionSheet(
                            title: Text("Choose an option"),
                            message: nil,
                            buttons: word.alternativeTexts.enumerated().map { index, alternativeText in
                                    .default(Text(alternativeText)) {
                                        self.selectedOption = alternativeText
                                    }
                            } + [.cancel()]
                        )
                    }
            }
        }
    }

    var wordsWithColors: [WordColorTuple] {

        return segments.enumerated().map { index, word in
            let color = getColorForCI(word.confidence)
            return WordColorTuple(text: word.substring, color: color, alternativeTexts: word.alternativeSubstrings)
        }
    }

    private func getColorForCI(_ ci: Float) -> Color {
        precondition(ci >= 0 && ci <= 1, "Confidence value must be between 0 and 1")

        let red: Double = Double(ci)
        let green: Double = Double(1.0 - ci)

        return Color(red: red, green: green, blue: 0.0)
    }
}
