//
//  ContentView.swift
//  FreeHand
//
//  Created by Kyoya Yamaguchi on 2024/11/24.
//

import CompactSlider
import PencilKit
import SwiftUI

struct DrawView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            CanvasView(viewModel: viewModel)
            HStack {
                CompactSlider(value: $viewModel.penWidth, in: 2...16, scaleVisibility: .hidden, minHeight: 50, enableDragGestureDelayForiOS: false) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 10))
                    Spacer()
                    Image(systemName: "circle.fill")
                        .font(.system(size: 20))
                }
                .frame(width: 200)
                .onChange(of: viewModel.penWidth) {
                    viewModel.updateTool()
                }
                ColorPicker(selection: $viewModel.penColor, label: { Text("") })
                    .labelsHidden()
                    .onChange(of: viewModel.penColor) {
                        viewModel.updateTool()
                    }
                Button {
                    viewModel.toggleTool()
                } label: {
                    Image(systemName: viewModel.isEraser ? "eraser" : "pencil")
                        .padding()
                        .foregroundStyle(.black)
                        .background(.ultraThinMaterial)
                        .frame(width: 44, height: 44)
                        .clipShape(.circle)
                }
            }
            .rotationEffect(.degrees(viewModel.rotation))
            .position(x: viewModel.position.x, y: viewModel.position.y)
        }
        .onPencilSqueeze { phase in
            if case let .active(value) = phase, let hoverPose = value.hoverPose {
                viewModel.updateSelectedCell(degrees: hoverPose.azimuth.degrees + 180)
            }
        }
        .onPencilDoubleTap { value in
            viewModel.toggleTool()
        }
        .onAppear {
            viewModel.canvasView.drawing = try! PKDrawing(data: viewModel.paper.drawingData)
        }
        .statusBar(hidden: true)
        .persistentSystemOverlays(.hidden)
        .ignoresSafeArea()
    }
}

#Preview {
    var viewModel = ViewModel()
    viewModel.position = .init(x: 100, y: 100)
    return DrawView()
        .environmentObject(viewModel)
}
