//
//  TutorialView.swift
//  FreeHand
//
//  Created by Kyoya Yamaguchi on 2025/02/23.
//

import SwiftUI
import AVKit

struct TutorialView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State var player = AVPlayer(url: Bundle.main.url(forResource: "instruction", withExtension: "mp4")!)
    
    @State var currentPage: Int = 0
    
    var body: some View {
        TabView(selection: $currentPage) {
            welcome
                .tag(0)
            drawing
                .tag(1)
            writing
                .tag(2)
            collaborate
                .tag(3)
            tools
                .tag(4)
            start
                .tag(5)
        }
        .tabViewStyle(.page)
        PageControlRepresentable(currentPage: $currentPage, numberOfPages: 6)
            .padding(.bottom, 10)
    }
    
    var welcome: some View {
        VStack {
            Image("") //アイコン
            Text("Welcome to Papers!")
            Text("Papers is an iPad app that allows you to draw like paper.")
        }
    }
    
    var drawing: some View {
        VStack {
            VideoPlayer(player: player)
                .aspectRatio(1280 / 896, contentMode: .fit)
                .onAppear {
                    player.play()
                }
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .padding(.horizontal, 20)
            Text("Sketch you see")
        }
    }
    
    var writing: some View {
        VStack {
            VideoPlayer(player: player)
                .aspectRatio(1280 / 896, contentMode: .fit)
                .onAppear {
                    player.play()
                }
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .padding(.horizontal, 20)
            Text("Memo anything")
            Text("Text will be scanned automatically")
        }
    }
    
    var collaborate: some View {
        VStack {
            Text("Best for collabotation")
            Text("Draw from any direction, with any hand")
        }
    }
    
    var tools: some View {
        VStack {
            Image("") //解説画像
            
        }
    }
    
    var start: some View {
        VStack {
            Text("Tutorial Completed!")
            Button {
                dismiss()
            } label: {
                Text("Start!")
                    .bold()
                    .font(.system(size: 20))
                    .frame(width: 200, height: 60)
                    .background(Color.accentColor)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
}

#Preview {
    TutorialView()
}
