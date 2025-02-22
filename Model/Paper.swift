import SwiftData
import PencilKit
import UIKit

@Model
class Paper: Identifiable {
    var id: UUID = UUID()
    var createdAt: Date = Date()
    var drawingData: Data
    @Attribute(.externalStorage) var imageData: Data?
    
    init(drawing: PKDrawing) {
        self.drawingData = drawing.dataRepresentation()
        self.imageData = drawing.image(from: CGRect(origin: .zero, size: UIScreen.main.bounds.size), scale: UIScreen.main.scale).jpegData(compressionQuality: 0.8)
    }
}
