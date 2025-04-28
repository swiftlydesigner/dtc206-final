//
//  SpeechAnalyzer.swift
//  dtc206-final
//
//  Created by main on 4/27/25.
//

import Speech

public class SpeechAnalyzer {
    public func transcribeVideo(url: URL, completion: @escaping (SFSpeechRecognitionResult?) -> Void) {

        // Specify a locale
        let locale = Locale(identifier: "en-US") // Change to your desired locale
        guard let recognizer = SFSpeechRecognizer(locale: locale) else {
            print("Speech recognizer is not available for the specified locale.")
            return
        }

        let request = SFSpeechURLRecognitionRequest(url: url)

        recognizer.recognitionTask(with: request) { result, error in
            guard error == nil else {
                print("Error: \(error!.localizedDescription)")
                return
            }

            if let result = result {
                completion(result)
            }
        }
    }

    public func getStats(from result: SFSpeechRecognitionResult) -> [String : Any] {
        var stats: [String : Any] = [:]
        var count = 0
        stats["Number of Transcriptions"] = result.transcriptions.count
        stats["Average CI For Each Transcription"] = getAverageCIIndvTranscription(result)

        stats["Best Transcription"] = "\"\(result.bestTranscription.formattedString)\""
//        stats["Best Transcription Average CI"] = result.bestTranscription.segments.reduce(Float(0)) {
//            $0 + $1.confidence
//        } / result.bestTranscription.segments.count

        stats["Best Transctition"] = result.bestTranscription.segments.first!.alternativeSubstrings


        return stats
    }

    private func getAverageCIIndvTranscription(_ result: SFSpeechRecognitionResult) -> [Int : Float] {
        var averageCI: [Int : Float] = [:]
        for (index, transcription) in result.transcriptions.enumerated() {
            averageCI[index] = transcription
                                    .segments
                                    .reduce(Float(0)) { $0 + $1.confidence } / Float(transcription.segments.count)
        }
        return averageCI
    }
}
