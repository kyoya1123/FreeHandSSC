//
//  TextExtractor.swift
//  FreeHand
//
//  Created by Kyoya Yamaguchi on 2025/02/22.
//

import UIKit
@preconcurrency import Vision

class TextExtractor {
    
    static func extractText(from image: UIImage) async -> String {
        guard let cgImage = image.cgImage else { return "" }
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        return await withCheckedContinuation { continuation in
            let request = VNRecognizeTextRequest { request, error in
                if error != nil {
                    continuation.resume(returning: "")
                    return
                }
                
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    continuation.resume(returning: "")
                    return
                }
                
                let recognizedStrings = observations.compactMap { observation in
                    observation.topCandidates(1).first?.string
                }
                
                let finalText = recognizedStrings.joined(separator: " ")
                continuation.resume(returning: finalText)
            }
            
            request.recognitionLevel = .accurate
            request.recognitionLanguages = ["en"]
            request.usesLanguageCorrection = true
            
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try requestHandler.perform([request])
                } catch {
                    continuation.resume(returning: "")
                }
            }
        }
    }
}
