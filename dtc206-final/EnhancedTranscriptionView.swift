//
//  TranscriptionView.swift
//  dtc206-final
//
//  Created by Kyle Parker on 4/28/25.
//

import SwiftUI
import Speech

struct EnhancedTranscriptionView: View {
    @Binding var showAll: Bool
    @Binding var transcribedData: SFSpeechRecognitionResult?
    @Binding var isTranscribing: Bool

    var width: CGFloat

    var body: some View {
        VStack {
            Text("Enhanced Transcript")
                .font(.title)
                .padding()
            if transcribedData != nil {
                /// Externalizing this struct reduced performance of switch.
                ShowEnhancedTranscriptionsView(showAll: $showAll,
                                       transcribedData: $transcribedData,
                                       width: width)
            } else if isTranscribing {
                Text("Transcribing...")
                    .font(.headline)
                    .padding()
            } else {
                Text("Select a video to start!")
                    .font(.headline)
                    .padding()
            }
        }
    }
}
