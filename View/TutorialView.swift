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
    @State var notePlayer = AVPlayer(url: Bundle.main.url(forResource: "note", withExtension: "mp4")!)
    @State var sketchPlayer = AVPlayer(url: Bundle.main.url(forResource: "sketch", withExtension: "mp4")!)
    @State var collabPlayer = AVPlayer(url: Bundle.main.url(forResource: "collab", withExtension: "mp4")!)
    
    @State var currentPage: Int = 0
    
    var body: some View {
        TabView(selection: $currentPage) {
            welcome
                .tag(0)
            lock
                .tag(1)
            writing
                .tag(2)
            drawing
                .tag(3)
            collaborate
                .tag(4)
            tools
                .tag(5)
            gestures
                .tag(6)
            pages
                .tag(7)
            start
                .tag(8)
        }
        .tabViewStyle(.page)
        PageControlRepresentable(currentPage: $currentPage, numberOfPages: 9)
            .padding(.bottom, 10)
    }
    
    var welcome: some View {
        VStack(spacing: 16) {
            Image("icon")
                .resizable()
                .frame(width: 300, height: 300)
                .padding(.bottom, 50)
            Text("Welcome to FreeHand!")
                .font(.largeTitle)
                .bold()
            Text("FreeHand is a Note app that feels like paper.")
                .font(.title2)
        }
        .padding()
    }
    
    var lock: some View {
        VStack {
            Spacer()
            Spacer()
            Image(systemName: "lock.rotation")
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .overlay {
                    Image(systemName: "arrow.up.right")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .offset(x: 150, y: -150)
                }
            Spacer()
            Text("Firstly, disable screen rotation from Control Center.")
                .font(.title2)
            Spacer()
        }
        .padding()
    }
    
    var writing: some View {
        VStack {
            VideoPlayer(player: notePlayer)
                .aspectRatio(4 / 3, contentMode: .fit)
                .onAppear {
                    notePlayer.play()
                }
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .padding([.top, .horizontal], 20)
            Spacer()
            VStack(spacing: 16) {
                Text("In this app, you can start writing just as you would on paper, using any hand, from any direction.")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                Text("Left-handed? No more struggle with tool placement")
                    .font(.title2)
                    .multilineTextAlignment(.center)
            }
            Spacer()
        }
        .padding([.top, .horizontal])
    }
    
    var drawing: some View {
        VStack {
            VideoPlayer(player: sketchPlayer)
                .aspectRatio(4 / 3, contentMode: .fit)
                .onAppear {
                    sketchPlayer.play()
                }
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .padding([.top, .horizontal], 20)
            Spacer()
            VStack(spacing: 16) {
                Text("Sketch on your iPad by rotating, or holding it.")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                Text("No matter what angle you use it from, the tools adjusts automatically.")
                    .font(.title2)
                    .multilineTextAlignment(.center)
            }
            Spacer()
        }
        .padding([.top, .horizontal])
    }
    
    var collaborate: some View {
        VStack {
            VideoPlayer(player: collabPlayer)
                .aspectRatio(4 / 3, contentMode: .fit)
                .onAppear {
                    collabPlayer.play()
                }
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .padding([.top, .horizontal], 20)
            Spacer()
            VStack(spacing: 16) {
                Text("Ideal for face-to-face discussions.")
                    .font(.title2)
                Text("Bring the experience of gathering around paper to iPad.")
                    .font(.title2)
                    .multilineTextAlignment(.center)
            }
            Spacer()
        }
        .padding()
    }
    
    var tools: some View {
        VStack(spacing: 16) {
            Image("tools")
                .resizable()
                .scaledToFit()
            Text("Use your other hand for tools.")
                .font(.title2)
        }
    }
    
    var gestures: some View {
        VStack(spacing: 16) {
            Image("gesture")
                .resizable()
                .scaledToFit()
            Text("Master the gestures for a better experience.")
                .font(.title2)
        }
        .padding()
    }
    
    var pages: some View {
        VStack(spacing: 16) {
            Image("pages")
                .resizable()
                .scaledToFit()
            VStack(spacing: 16) {
                Text("View your pages list digitally.")
                Text("Your handwrites are automatically recognized and searchable from the search bar.")
                    .multilineTextAlignment(.center)
            }
            .font(.title2)
        }
        .padding()
    }
    
    var start: some View {
        VStack {
            Spacer()
            VStack(spacing: 16) {
                Text("Tutorial Completed!")
                    .font(.largeTitle)
                    .bold()
                Text("You can take note, sketch, or collaborate with others")
                    .font(.title2)
                    .multilineTextAlignment(.center)
            }
            Spacer()
            Button {
                dismiss()
            } label: {
                Text("Start!")
                    .bold()
                    .font(.system(size: 30))
                    .frame(width: 200, height: 80)
                    .background(Color.accentColor)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    Rectangle()
        .ignoresSafeArea()
        .sheet(isPresented: .constant(true)) {
            TutorialView()
        }
}
