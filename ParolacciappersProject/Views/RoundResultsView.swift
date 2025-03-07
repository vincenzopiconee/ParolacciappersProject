//
//  RoundResultsView.swift
//  ParolacciappersProject
//
//  Created by Martha Mendoza Alfaro on 07/03/25.
//


import SwiftUI

struct RoundResultsView: View {
    @ObservedObject var multipeerManager: MultipeerManager

    var body: some View {
        VStack {
            Text("Round Results")
                .font(.largeTitle)
                .padding()

            if multipeerManager.winner.isEmpty {
                Text("No votes cast!")
                    .font(.title)
                    .padding()
            } else {
                Text("🏆 Winner(s):")
                    .font(.headline)
                    .padding(.top)

                ForEach(multipeerManager.winner, id: \.self) { peer in
                    Text("\(peer.displayName)")
                        .font(.title)
                        .padding()
                        .background(Color.yellow.opacity(0.5))
                        .cornerRadius(10)
                }
            }

            if multipeerManager.isHosting {
                Button("Next Round") {
                    multipeerManager.advanceToNextPhase()
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
        }
    }
}
