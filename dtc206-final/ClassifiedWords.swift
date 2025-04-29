//
//  ClassifiedWords.swift
//  dtc206-final
//
//  Created by Kyle Parker on 4/28/25.
//

import SwiftUI
import Speech

struct ClassifiedWords: View {

    let data: String
    let segments: [SFTranscriptionSegment]

    @State private var row = 0

    var body: some View {
        VStack(spacing: 2) {
            ForEach(0..<splitString.count, id: \.self) { index in
                Text("Word \(row + 1) - \(row + 19)")
                createRow(splitString[index])
            }
        }
    }

    var splitString: [[String]] {
        let words = data.split(separator: " ").map { String($0) }
        var result: [[String]] = []
        var currentLine: [String] = []

        for word in words {
            currentLine.append(word)
            if currentLine.count == 20 {
                result.append(currentLine)
                currentLine = []
            }
        }

        if !currentLine.isEmpty {
            result.append(currentLine)
        }

        return result
    }

    func createRow(_ row: [String]) -> some View {
        HStack(spacing: 0) {
            ForEach(row, id: \.self) { word in
                tupleView(from: word)
            }
        }
    }

    func tupleView(from word: String) -> some View {
        let results = NLTAnalyzer().process(word)

        return VStack {
            Text(results.first?.origWord ?? "UNKNOWN")
                .font(.headline)
                .lineLimit(1)
            Text(results.first?.modifiedWord ?? "UNKNOWN")
                .font(.subheadline)
                .lineLimit(1)
            Text(results.first?.type ?? "UNKNOWN")
                .font(.caption)
                .lineLimit(1)
        }
        .padding() // Padding inside the VStack
        .border(results.first?.valid ?? false ? Color.green : Color.red, width: 2) // Border color
        .cornerRadius(10) // Rounded corners
        .padding(1)
    }
}
