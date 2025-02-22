//
//  DrawView.swift
//  Graffiti
//
//  Created by Kyoya Yamaguchi on 2024/02/18.
//

import SwiftUI
import UIKit
import PencilKit

class TouchHandlablePKCanvasView: PKCanvasView {
    var onTouchBegan: ((UITouch) -> Void)?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first, touch.type == .pencil {
            onTouchBegan?(touch)
        }
    }
    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let touch = touches.first, touch.type == .pencil {
//            onTouchBegan?(touch)
//        }
//    }
}

struct CanvasView: UIViewRepresentable {

    @ObservedObject var viewModel: ViewModel

    func makeUIView(context: Context) -> TouchHandlablePKCanvasView {
        viewModel.canvasView.drawingPolicy = .pencilOnly
        viewModel.canvasView.delegate = viewModel
        viewModel.canvasView.backgroundColor = .clear
        viewModel.canvasView.onTouchBegan = { touch in
            let azimuth = touch.azimuthAngle(in: viewModel.canvasView)
            let degrees = azimuth * 180 / .pi + 180
            viewModel.updateSelectedCell(degrees: degrees)
        }
        return viewModel.canvasView
    }

    func updateUIView(_ uiView: TouchHandlablePKCanvasView, context: Context) {}
}
