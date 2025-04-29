//
//  VideoAnalyzerView.swift
//  dtc206-final
//
//  Created by Kyle Parker on 4/28/25.
//

import SwiftUI
import AVKit
import Speech

struct VideoAnalyzerView: View {

    @State private var selectedVideoURL: URL?
    @State private var videoThumbnail: Image?
    @State private var transcribedData: SFSpeechRecognitionResult?
    @State private var editableEnhanced: String = "Editable Text Line 3"

    @State private var isImporting: Bool = false
    @State private var isTranscribing: Bool = false
    @State private var showAll: Bool = false

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    Toggle("Show All Transcriptions", isOn: $showAll)
                    
                    fileSelector
                    
                    thumbnailView
                    
                    TranscriptionView(showAll: $showAll,
                                      transcribedData: $transcribedData,
                                      isTranscribing: $isTranscribing,
                                      width: geometry.size.width)
                    
                    Color.secondary
                        .frame(maxWidth: .infinity, maxHeight: 1.5)
                    
                    // Text Line 2
                    EnhancedTranscriptionView(showAll: $showAll,
                                      transcribedData: $transcribedData,
                                      isTranscribing: $isTranscribing,
                                      width: geometry.size.width)
                    // TODO: Replace with ColoredWords
                    
                    // Editable Text Line 3
                    TextField("Editable Text Line 3", text: $editableEnhanced)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
            }
        }
        .padding()
    }

    private var thumbnailView: some View {
        if let thumbnail = videoThumbnail {
            return AnyView {
                thumbnail
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(8)
                    .padding()
            }
        } else {
            return AnyView {
                Text("No Video Selected")
                    .padding()
            }
        }
    }

    private var fileSelector: some View {
        Button(action: {
            isImporting = true
        }) {
            Text("Select Video")
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .fileImporter(isPresented: $isImporting, allowedContentTypes: [.movie]) { result in
            switch result {
                case .success(let url):
                    self.selectedVideoURL = url
                    self.videoThumbnail = generateThumbnail(url: url)
                    DispatchQueue.main.async {
                        self.runAnalysis()
                    }
                case .failure(let error):
                    print("Error selecting video: \(error.localizedDescription)")
            }
        }
    }

    private func generateThumbnail(url: URL) -> Image? {
        let asset = AVURLAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        let time = CMTime(seconds: 1, preferredTimescale: 600)

        do {
            let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return Image(decorative: cgImage, scale: 1.0, orientation: .up)
        } catch {
            print("Error generating thumbnail: \(error)")
            return nil
        }
    }

    private func runAnalysis() {
        let analyzer = SpeechAnalyzer()

        guard let selectedVideoURL else {
            return
        }

        isTranscribing.toggle()

        DispatchQueue.global(qos: .userInitiated).async {
            let result = analyzer.transcribeVideo(url: selectedVideoURL) { result in
                DispatchQueue.main.async {
                    self.transcribedData = result // This will trigger a view update
                    isTranscribing.toggle()
                }
            }
        }
    }
}

struct VideoAnalyzerView_Previews: PreviewProvider {
    static var previews: some View {
        VideoAnalyzerView()
    }
}
