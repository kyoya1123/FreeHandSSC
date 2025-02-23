//
//  ContentView.swift
//  FreeHand
//
//  Created by Kyoya Yamaguchi on 2024/11/24.
//

import PencilKit
import SwiftUI
import AVFAudio

struct DrawView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            CanvasView(viewModel: viewModel)
            VStack {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 50) {
                        ForEach(0..<(Int(UIScreen.main.bounds.width) / 100), id: \.self) { _ in
                            VStack(spacing: -24) {
                                UnevenRoundedRectangle(cornerRadii: .init(bottomLeading: 20, bottomTrailing: 20))
                                    .foregroundStyle(.gray)
                                    .frame(width: 30, height: 40)
                                    .shadow(radius: 10)
                                Circle()
                                    .foregroundStyle(.black)
                                    .frame(width: 40, height: 40)
                                    .zIndex(-1)
                            }
                        }
                    }
                }
                Spacer()
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        viewModel.save()
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
                                .frame(width: 50, height: 50)
                                .shadow(color: .gray, radius: 20)
                    }
                }
            }
            
            HStack {
                Button {
                    viewModel.isShowingTrashConfirmAlert = true
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
                        .rotationEffect(.degrees(90))
                    
                }
                CompactSlider(value: $viewModel.penWidth, in: 2...16, scaleVisibility: .hidden, minHeight: 45, enableDragGestureDelayForiOS: false) {
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
        .alert("Trash This Page?", isPresented: $viewModel.isShowingTrashConfirmAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Trash", role: .destructive) {
                SwiftDataManager.shared.delete(data: viewModel.paper)
                SoundEffect.play(.trash)
                viewModel.newPage()
            }
        }
        .statusBar(hidden: true)
        .persistentSystemOverlays(.hidden)
        .navigationBarBackButtonHidden()
        .navigationAllowDismissalGestures(.none)
        .ignoresSafeArea()
    }
}

#Preview {
    var viewModel = ViewModel()
    viewModel.position = .init(x: 100, y: 100)
    return DrawView()
        .environmentObject(viewModel)
}
