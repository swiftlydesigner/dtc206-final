//
//  SpeechAnalyzer.swift
//  dtc206-final
//
//  Created by main on 4/27/25.
//

import Speech

public class SpeechAnalyzer {
    public func transcribeVideo(url: URL) -> SFSpeechRecognitionResult? {
        var recognitionResult: SFSpeechRecognitionResult? = nil

        let recognizer = SFSpeechRecognizer()
        let request = SFSpeechURLRecognitionRequest(url: url)

        recognizer?.recognitionTask(with: request) { result, error in
            guard error == nil else {
                print("Error: \(error.debugDescription)")
                return
            }

            if let result {
                recognitionResult = result
            }
        }

        return recognitionResult
    }
}
