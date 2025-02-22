//
//  File.swift
//  FreeHand
//
//  Created by Kyoya Yamaguchi on 2025/02/23.
//

import UIKit
import UniformTypeIdentifiers
import CoreTransferable

struct ShareableImage: Transferable {
    let image: UIImage
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .jpeg) { shareableImage in
            shareableImage.image.jpegData(compressionQuality: 1)!
        }
    }
}
