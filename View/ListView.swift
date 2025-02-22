//
//  ListView.swift
//  FreeHand
//
//  Created by Kyoya Yamaguchi on 2025/02/21.
//

import SwiftUI
import PencilKit

struct ListView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 4), spacing: 20) {
                    ForEach(viewModel.papers) { paper in
                            Button {
                                viewModel.paper = paper
                                viewModel.isShowingDrawView = true
                            } label: {
                                VStack {
                                    if let imageData = paper.imageData, let image = UIImage(data: imageData) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFit()
                                        Text("aaa")
                                    }
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.gray, lineWidth: 1)
                                }
                            }
                    }
                }
                .padding()
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
                    .environmentObject(viewModel)
            }
    }
}

#Preview {
    ListView()
}
