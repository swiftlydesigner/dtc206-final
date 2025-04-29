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
    var time: String
    var color: Color
    var alternativeTexts: [String]
    var confidence: Float

    static func wordsWithColors(from segments: [SFTranscriptionSegment]) -> [[WordColorTuple]] {

        var result = [[WordColorTuple]]()

        var intermediaryResult = [WordColorTuple]()

        var lastTime: TimeInterval = segments.first?.timestamp ?? 0
        var currentTime: TimeInterval = 0

        for (index, word) in segments.enumerated() {
            if (currentTime - lastTime > 5) {
                result.append(intermediaryResult)
                intermediaryResult = []
                lastTime = currentTime
            }

            let color = getColorForCI(word.confidence)
            intermediaryResult.append(
                WordColorTuple(text: word.substring,
                               time: stringForTimeInt(word.timestamp),
                               color: color,
                               alternativeTexts: word.alternativeSubstrings,
                               confidence: word.confidence)
            )

            currentTime = word.timestamp
        }

        if intermediaryResult.isEmpty == false {
            result.append(intermediaryResult)
        }

        return result
    }

    private static func getColorForCI(_ ci: Float) -> Color {
        precondition(ci >= 0 && ci <= 1, "Confidence value must be between 0 and 1")

        let red: Double = Double(1.0 - ci)
        let green: Double = Double(ci)

        return Color(red: red, green: green, blue: 0.0)
    }

    private static func stringForTimeInt(_ timeInt: TimeInterval) -> String {

        let hours = Int(timeInt) / 3600
        let minutes = (Int(timeInt) % 3600) / 60
        let seconds = Int(timeInt) % 60

        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

struct ColoredWords: View {
    let segments: [SFTranscriptionSegment]

    @State private var showActionSheet: Bool = false

    @State private var selectedOption: String?

    var body: some View {
        VStack(spacing: 2) {
            ForEach(0..<wordsWithColors.count, id: \.self) { index in
                Text("\(wordsWithColors[index].first?.time ?? "???") - \(wordsWithColors[index].last?.time ?? "???")")
                timeDurationView(wordsWithColors[index])
            }
        }
    }

    func timeDurationView(_ section: [WordColorTuple]) -> some View {
        HStack(spacing: 0) {
            ForEach(section) { word in
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

    var wordsWithColors: [[WordColorTuple]] {
        return WordColorTuple.wordsWithColors(from: segments)
    }
}
