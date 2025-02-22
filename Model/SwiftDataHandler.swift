//
//  SwiftDataHandler.swift
//  SwiftDataSample
//
//  Created by Yuki Kuwashima on 2024/07/31.
//

import SwiftData
import PencilKit

public class SwiftDataManager {
    
    typealias DataItem = Paper
    
    public static let shared = SwiftDataManager()
    
    public var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            DataItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    public var modelContext: ModelContext
    
    init() {
        modelContext = ModelContext(sharedModelContainer)
    }
    
    func add(data: DataItem) {
        modelContext.insert(data)
    }
    
    func update(data: DataItem, drawing: PKDrawing, canvasImage: UIImage) {
        Task { @MainActor in
            data.drawingData = drawing.dataRepresentation()
            //        let image = drawing.image(from: CGRect(origin: .zero, size: UIScreen.main.bounds.size), scale: 1)
            data.imageData = canvasImage.jpegData(compressionQuality: 0.8)
            data.recognizedText = await TextExtractor.extractText(from: canvasImage)
            try? modelContext.save()
        }
    }
    
    func delete(data: DataItem) {
        modelContext.delete(data)
    }
    
    func loadAllData() -> [DataItem] {
        let fetchDesc = FetchDescriptor<DataItem>(
            predicate: nil,
            sortBy: []
        )
        guard let fetchedDatas = try? modelContext.fetch(fetchDesc) else {
            print("Error on fetch data using SwiftData")
            return []
        }
        return fetchedDatas
    }
}
