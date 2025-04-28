//
//  VideoAnalyzerView.swift
//  dtc206-final
//
//  Created by Kyle Parker on 4/28/25.
//

import SwiftUI
import AVKit

struct VideoAnalyzerView: View {
    @State private var selectedVideoURL: URL?
    @State private var videoThumbnail: Image?
    @State private var textLine1: String = "Text Line 1"
    @State private var textLine2: String = "Text Line 2"
    @State private var editableTextLine3: String = "Editable Text Line 3"

    var body: some View {
        VStack {
            // File Selector
            Button(action: {
                selectVideo()
            }) {
                Text("Select Video")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            // Video Thumbnail
            if let thumbnail = videoThumbnail {
                thumbnail
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(8)
                    .padding()
            } else {
                Text("No Video Selected")
                    .padding()
            }

            // Text Line 1
            Text(textLine1)
                .font(.headline)
                .padding()

            // Text Line 2
            Text(textLine2)
                .font(.subheadline)
                .padding()

            // Editable Text Line 3
            TextField("Editable Text Line 3", text: $editableTextLine3)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
        .padding()
    }

    private func selectVideo() {
        let panel = NSOpenPanel()
        panel.allowedFileTypes = ["mp4", "mov"]
        panel.canChooseFiles = true
        panel.canChooseDirectories = false

        panel.begin { result in
            if result == .OK, let url = panel.url {
                self.selectedVideoURL = url
                self.videoThumbnail = generateThumbnail(url: url)
            }
        }
    }

    private func generateThumbnail(url: URL) -> Image? {
        let asset = AVAsset(url: url)
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
}

struct VideoAnalyzerView_Previews: PreviewProvider {
    static var previews: some View {
        VideoAnalyzerView()
    }
}
