//
//  ShowTranscriptionsView.swift
//  dtc206-final
//
//  Created by Kyle Parker on 4/28/25.
//

import SwiftUI
import Speech

struct ShowTranscriptionsView: View {
    @Binding var showAll: Bool
    @Binding var transcribedData: SFSpeechRecognitionResult?


    var width: CGFloat

    var body: some View {
        // Show all translations
        if showAll {
            ScrollView {
                ForEach(Array(transcribedData!.transcriptions.enumerated()), id: \.element) { index, transcription in
                    Color.teal
                        .frame(maxWidth: width * 0.90, maxHeight: 1.5)
                    Text(
                        "[\(self.nameFor(index: index))] Transcribed Text: (Avg CI: \(String(format: "%.5f", self.getAvgConfidence(for: transcription.segments) * 100))%)"
                    )
                    .font(.title)
                    ColoredWords(segments: transcription.segments)
                }
            }
        } else { // Only show best
            Color.teal
                .frame(maxWidth: width * 0.90, maxHeight: 1.5)

            Text(
                "[Best Transcription] Transcribed Text: (Avg CI: \(String(format: "%.5f", getAvgConfidence(for: transcribedData!.bestTranscription.segments) * 100))%)"
            )
            .font(.title)

            ColoredWords(segments: transcribedData!.bestTranscription.segments)
        }
    }

    private func getAvgConfidence(for segment: [SFTranscriptionSegment]) -> Double {
        let confidences = segment.reduce(0.0) {
            $0 + Double($1.confidence)
        }

        return confidences / Double(segment.count)
    }

    private func nameFor(index: Int) -> String {
        index == 0 ? "Best Transcription" : "Alt Transcription \(index)"
    }
}
