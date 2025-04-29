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

    var body: some View {
        VStack(spacing: 2) {
            ForEach(0..<naturalLanguageResults.count, id: \.self) { index in
                Text("Words \(index * 20 + 1) thru \(index * 20 + naturalLanguageResults[index].count)")
                    .font(.title)
                createRow(naturalLanguageResults[index])
            }
        }
    }

//    var splitString: [[String]] {
//        let words = data.split(separator: " ").map { String($0) }
//
//        return splitInto(maxPerRow: 20, words)
//    }

    var naturalLanguageResults: [[NLTAnalyzerResult]] {
        print("DATA: \(data)")
        let result = NLTAnalyzer().process(data)

        return splitInto(maxPerRow: 20, result)
    }

    func createRow(_ row: [NLTAnalyzerResult]) -> some View {
        HStack(spacing: 0) {
            ForEach(row) { ele in
                tupleView(from: ele)
            }
        }
    }

    func tupleView(from result: NLTAnalyzerResult) -> some View {
        VStack {
            Text(result.origWord)
                .font(.title)
                .lineLimit(1)
            Text(result.modifiedWord)
                .font(.title2)
                .lineLimit(1)
            Text(result.type)
                .font(.title3)
                .lineLimit(1)
        }
        .padding() // Padding inside the VStack
        .border(result.valid ? Color.green : Color.red, width: 2) // Border color
        .cornerRadius(10) // Rounded corners
        .padding(1)
    }

    private func splitInto<T>(maxPerRow max: Int, _ arr: [T]) -> [[T]] {
        var result: [[T]] = []
        var currentLine: [T] = []

        for ele in arr {
            currentLine.append(ele)
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
}
