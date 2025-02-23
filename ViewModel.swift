//
//  ViewModel.swift
//  FreeHand
//
//  Created by Kyoya Yamaguchi on 2024/11/24.
//

import PencilKit
import SwiftUI

class ViewModel: NSObject, ObservableObject {
    
    @Published var canvasView = TouchHandlablePKCanvasView()
    @Published var inkType: PKInk.InkType = .pencil
    @Published var penColor: Color = .black
    @Published var penWidth: Double = 5
    @Published var rotation: Double = 270
    @Published var position: CGPoint = .init(x: 45, y: UIScreen.main.bounds.height / 2)
    @Published var isEraser = false
    
    @Published var papers: [Paper] = []
    @Published var paper: Paper = Paper(drawing: PKDrawing())
    @Published var isShowingDrawView = false
    @Published var searchText: String = ""
    @Published var isShowingTutorial = false
    @Published var isShowingTrashConfirmAlert = false
    @Published var pageCurlOnRight = false
    
    override init() {
        super.init()
        updateTool()
        papers = SwiftDataManager.shared.loadAllData()
        SoundEffect.play(.open)
        if let lastPage = filteredAndSortedPapers.first {
            paper = lastPage
        } else {
            newPage()
        }
        
        isShowingDrawView = true
        
        let pinch = UIPinchGestureRecognizer(
            target: self,
            action: #selector(handlePinch)
        )
        canvasView.addGestureRecognizer(pinch)
        
        let swipeUpGesture = UISwipeGestureRecognizer(
            target: self,
            action: #selector(swipeUp)
        )
        swipeUpGesture.direction = .up
        canvasView.addGestureRecognizer(swipeUpGesture)
        
        let swipeDownGesture = UISwipeGestureRecognizer(
            target: self,
            action: #selector(swipeDown)
        )
        swipeDownGesture.direction = .down
        canvasView.addGestureRecognizer(swipeDownGesture)
    }
    
    var initialDegree: Double?
    
    var filteredAndSortedPapers: [Paper] {
        var filtered = papers
        if !searchText.isEmpty {
            filtered = filtered.filter({ $0.recognizedText.lowercased().contains(searchText.lowercased()) })
        }
        return filtered.sorted(by: { $0.createdAt < $1.createdAt })
    }
    
    func updateSelectedCell(degrees: Double) {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let padding: CGFloat = 45
        switch degrees {
        case 0..<45, 315..<360: // Right
            pageCurlOnRight = true
            animateTool(rotation: 90, position: .init(x: screenWidth - padding, y: screenHeight / 2))
        case 45..<135: // Bottom
            animateTool(rotation: 0, position: .init(x: screenWidth / 2, y: screenHeight - padding))
        case 135..<225: // Left
            pageCurlOnRight = false
            animateTool(rotation: 270, position: .init(x: padding, y: screenHeight / 2))
        case 225..<315: // Top
            animateTool(rotation: 0, position: .init(x: screenWidth / 2, y: padding))
        default:
            break
        }
    }
    
    func animateTool(rotation: Double, position: CGPoint) {
        withAnimation {
            self.rotation = rotation
            self.position = position
        }
    }
    
    func updateTool() {
        if isEraser {
            canvasView.tool = PKEraserTool(.bitmap, width: penWidth)
        } else {
            canvasView.tool = PKInkingTool(inkType, color: UIColor(penColor), width: penWidth)
        }
    }
    
    func toggleTool() {
        isEraser.toggle()
        updateTool()
    }
    
    func save() {
        SwiftDataManager.shared.update(data: paper, drawing: canvasView.drawing, canvasImage: canvasView.asImage()!)
    }
    
    func newPage() {
        let new = Paper(drawing: PKDrawing())
        SwiftDataManager.shared.add(data: new)
        paper = new
        canvasView.drawing = .init()
        papers = SwiftDataManager.shared.loadAllData()
    }
    
    @objc func swipeUp() {
        if let nextPage = nextPage() {
            SoundEffect.play(.curl)
            paper = nextPage
            canvasView.drawing = try! PKDrawing(data: paper.drawingData)
        } else {
            if canvasView.drawing.strokes.isEmpty { return }
            SoundEffect.play(.curl)
            newPage()
        }
    }
    
    @objc func swipeDown() {
        if let previousPage = previousPage() {
            save()
            SoundEffect.play(.curl)
            paper = previousPage
            canvasView.drawing = try! PKDrawing(data: paper.drawingData)
        }
    }
    
    @objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        if gesture.state == .changed, gesture.scale < 1, gesture.numberOfTouches == 2 {
            isShowingTrashConfirmAlert = true
        }
    }
    
    func previousPage() -> Paper? {
        guard let index = papers.firstIndex(of: paper), index > 0 else { return nil }
        return papers[index - 1]
    }
    
    func nextPage() -> Paper? {
        guard let index = papers.firstIndex(of: paper), index < papers.count - 1 else { return nil }
        return papers[index + 1]
    }
}

extension UIView {
    func asImage() -> UIImage? {
        UIGraphicsImageRenderer(bounds: bounds).image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
    }
}

extension Date {
    var displayFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        return dateFormatter.string(from: self)
    }
}


extension ViewModel: PKCanvasViewDelegate, UIPencilInteractionDelegate {
    func pencilInteraction(_ interaction: UIPencilInteraction,
                           didReceiveSqueeze squeeze: UIPencilInteraction.Squeeze) {
        if UIPencilInteraction.preferredSqueezeAction == .showContextualPalette &&
            squeeze.phase == .began, let hoverPose = squeeze.hoverPose {
            let azimuthAngle = hoverPose.azimuthAngle * 180 / .pi
            let zOffset = hoverPose.zOffset
            print(azimuthAngle, zOffset)
        }
    }
    
    func canvasViewDidEndUsingTool(_ canvasView: PKCanvasView) {
        save()
    }
}
