//
//  SoundEffect.swift
//  FreeHand
//
//  Created by Kyoya Yamaguchi on 2025/02/23.
//

import AVFoundation
import UIKit

enum SoundType: String {
    case curl
    case close
    case open
    case trash
    
    var data: Data {
        NSDataAsset(name: rawValue)!.data
    }
}

class SoundEffect {
    static var audioPlayer: AVAudioPlayer?
    
    /// 指定した `SoundType` を再生する
    static func play(_ sound: SoundType) {
        audioPlayer = try! AVAudioPlayer(data: sound.data)
        audioPlayer?.play()
    }
}
