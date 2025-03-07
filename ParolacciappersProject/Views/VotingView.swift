//
//  VotingView.swift
//  ParolacciappersProject
//
//  Created by Martha Mendoza Alfaro on 07/03/25.
//


import SwiftUI

struct VotingView: View {
    @ObservedObject var multipeerManager: MultipeerManager

    var body: some View {
        VStack {
            Text("Vote for the Funniest Sentence!")
                .font(.largeTitle)
                .padding()

            List {
                ForEach(multipeerManager.submittedSentences.keys.sorted(by: { $0.displayName < $1.displayName }), id: \.self) { peer in
                    Button(action: {
                        multipeerManager.submitVote(for: peer)
                    }) {
                        VStack(alignment: .leading) {
                            Text("\(peer.displayName)")
                                .font(.headline)
                            Text("\"\(multipeerManager.submittedSentences[peer] ?? "")\"")
                                .italic()
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(multipeerManager.hasVoted ? Color.gray.opacity(0.3) : Color.blue.opacity(0.2))
                        .cornerRadius(10)
                    }
                    .disabled(multipeerManager.hasVoted) // Prevent multiple votes
                }
            }

            if multipeerManager.isHosting {
                Button("See Results") {
                    multipeerManager.calculateWinner()
                    multipeerManager.advanceToNextPhase()
                }
                .buttonStyle(.borderedProminent)
                .padding()
                .disabled(multipeerManager.votes.isEmpty)
            }
        }
    }
}
