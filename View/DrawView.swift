//
//  ContentView.swift
//  FreeHand
//
//  Created by Kyoya Yamaguchi on 2024/11/24.
//

import CompactSlider
import PencilKit
import SwiftUI
import AVFAudio

struct DrawView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            CanvasView(viewModel: viewModel)
            HStack(spacing: 50) {
                ForEach(0..<(Int(UIScreen.main.bounds.width) / 100), id: \.self) { _ in
                    VStack(spacing: -24) {
                        UnevenRoundedRectangle(cornerRadii: .init(bottomLeading: 20, bottomTrailing: 20))
                            .foregroundStyle(.gray)
                            .frame(width: 30, height: 40)
                        Circle()
                            .foregroundStyle(.black)
                            .frame(width: 40, height: 40)
                            .zIndex(-1)
                        Spacer()
                    }
                }
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        viewModel.newPage()
                        SoundEffect.play(.curl)
                    } label: {
                        UnevenRoundedRectangle(cornerRadii: .init(topLeading: 10))
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(stops: [
                                            .init(color: Color("Paper"), location: 0.0),
                                            .init(color: .gray, location: 0.5),
                                            .init(color: Color("Paper"), location: 1.0)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 40, height: 40)
                                .shadow(color: .gray, radius: 20)
                    }
                }
            }
            
            HStack {
                Button {
                    SoundEffect.play(.trash)
                    viewModel.newPage()
                } label: {
                    Image("trashIcon")
                        .resizable()
                        .padding(5)
                        .foregroundStyle(.black)
                        .background(Color("toolBackground"))
                        .frame(width: 44, height: 44)
                        .clipShape(.circle)
                    
                }
                Button {
                    SoundEffect.play(.close)
                    dismiss()
                } label: {
                    Image(systemName: "book.pages.fill")
                        .padding()
                        .foregroundStyle(.black)
                        .background(Color("toolBackground"))
                        .frame(width: 44, height: 44)
                        .clipShape(.circle)
                    
                }
                CompactSlider(value: $viewModel.penWidth, in: 2...16, scaleVisibility: .hidden, minHeight: 50, enableDragGestureDelayForiOS: false) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 10))
                    Spacer()
                    Image(systemName: "circle.fill")
                        .font(.system(size: 20))
                }
                .background {
                    Color("Paper")
                        .clipShape(RoundedRectangle(cornerRadius: 7))
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
                    Image(systemName: "circle")
                        .symbolVariant(viewModel.isEraser ? .fill.slash : .fill)
                        .padding()
                        .foregroundStyle(.black)
                        .background(Color("toolBackground"))
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
            if viewModel.papers.count == 1 {
                viewModel.isShowingTutorial = true
            }
        }
        .onDisappear {
            viewModel.save()
            viewModel.papers = SwiftDataManager.shared.loadAllData()
        }
        .sheet(isPresented: $viewModel.isShowingTutorial) {
            TutorialView()
        }
        .statusBar(hidden: true)
        .persistentSystemOverlays(.hidden)
        .navigationBarBackButtonHidden()
        .ignoresSafeArea()
    }
}

#Preview {
    var viewModel = ViewModel()
    viewModel.position = .init(x: 100, y: 100)
    return DrawView()
        .environmentObject(viewModel)
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.closeSubpath()
        }
    }
}
