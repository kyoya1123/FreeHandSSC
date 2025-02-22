//
//  ListView.swift
//  FreeHand
//
//  Created by Kyoya Yamaguchi on 2025/02/21.
//

import SwiftUI
import PencilKit
import AVFAudio

struct ListView: View {
    
    @Namespace private var namespace
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 4), spacing: 20) {
                    ForEach(viewModel.filteredAndSortedPapers) { paper in
                            Button {
                                viewModel.paper = paper
                                viewModel.isShowingDrawView = true
                            } label: {
                                VStack {
                                        if let imageData = paper.imageData, let image = UIImage(data: imageData) {
                                            Image(uiImage: image)
                                                .resizable()
                                                .scaledToFit()
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                .shadow(color: .black.opacity(0.3), radius: 5)
                                                .padding()
                                        } else {
                                            Rectangle()
                                                .foregroundStyle(Color("Paper"))
                                        }
                                    Text(paper.createdAt.displayFormat)
                                        .foregroundStyle(.black)
                                        Text(paper.recognizedText)
                                            .foregroundStyle(.black.tertiary)
                                            .font(.caption)
                                            .lineLimit(1)
                                }
                            }
                            .matchedTransitionSource(id: paper.id, in: namespace)
                    }
                }
                .padding()
                .searchable(text: $viewModel.searchText)
            }
            .navigationTitle(Text("Papers"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("", systemImage: "square.and.pencil") {
                        let new = Paper(drawing: PKDrawing())
                        SwiftDataManager.shared.add(data: new)
                        viewModel.paper = new
                        viewModel.isShowingDrawView = true
                    }
                }
            }
            .navigationDestination(isPresented: $viewModel.isShowingDrawView) {
                DrawView()
                    .navigationTransition(.zoom(sourceID: viewModel.paper.id, in: namespace))
                    .environmentObject(viewModel)
                    .onDisappear {
                        viewModel.papers = SwiftDataManager.shared.loadAllData()
                    }
            }
    }
}

#Preview {
    ListView()
}
