//
//  GameOverView.swift
//  ParolacciappersProject
//
//  Created by Martha Mendoza Alfaro on 07/03/25.
//
import SwiftUI
import MultipeerConnectivity

struct GameOverView: View {
    @ObservedObject var multipeerManager: MultipeerManager
    @Environment(\.presentationMode) var presentationMode

    var overallWinners: [MCPeerID] {
        multipeerManager.determineOverallWinner()
    }

    var body: some View {
        VStack {
            Text("Game Over!")
                .font(.largeTitle)
                .padding()

            Text("🏆 Overall Winner(s):")
                .font(.headline)
                .padding(.top)

            if overallWinners.isEmpty {
                Text("No overall winner")
                    .font(.title)
                    .padding()
            } else {
                ForEach(overallWinners, id: \.self) { peer in
                    Text("\(peer.displayName) - \(multipeerManager.totalWins[peer] ?? 0) Wins")
                        .font(.title)
                        .padding()
                        .background(Color.yellow.opacity(0.5))
                        .cornerRadius(10)
                }
            }

            Spacer()

            Button("Exit") {
                multipeerManager.resetGame()
                multipeerManager.disconnect()
                presentationMode.wrappedValue.dismiss()
            }
            .buttonStyle(.bordered)
            .padding(.bottom)
        }
        .navigationBarBackButtonHidden(true)
    }
}
