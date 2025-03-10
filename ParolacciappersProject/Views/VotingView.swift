//
//  VotingView.swift
//  ParolacciappersProject
//
//  Created by Martha Mendoza Alfaro on 07/03/25.
//

import SwiftUI
import MultipeerConnectivity

struct VotingView: View {
    @ObservedObject var multipeerManager: MultipeerManager
    @State private var selectedPeer: MCPeerID? // Track the currently selected peer

    var body: some View {
        VStack {
            Text("Vote for the Funniest Sentence!")
                .font(.largeTitle)
                .padding()

            List {
                ForEach(Array(multipeerManager.submittedSentences.keys).sorted(by: { $0.displayName < $1.displayName }), id: \.self) { peer in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(peer.displayName)")
                                .font(.headline)
                            Text("\"\(multipeerManager.submittedSentences[peer] ?? "")\"")
                                .italic()
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(selectedPeer == peer ? Color.blue.opacity(0.2) : Color.clear) // Highlight selected
                        .cornerRadius(10)

                        Button(action: {
                            selectedPeer = peer // Select the chosen sentence
                        }) {
                            Image(systemName: selectedPeer == peer ? "checkmark.circle.fill" : "circle")
                                .contentShape(Rectangle())
                        }
                        .disabled(multipeerManager.hasVoted)
                    }
                }
            }

            // "Send Vote" button appears only if a selection is made
            if selectedPeer != nil {
                Button("Send Vote") {
                    if let selected = selectedPeer {
                        multipeerManager.submitVote(for: selected) // Submit the selected vote
                        multipeerManager.hasVoted = true
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding()
                .disabled(multipeerManager.hasVoted) // Prevent resubmitting
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

/*struct VotingView: View {
    @ObservedObject var multipeerManager: MultipeerManager

    var body: some View {
        VStack {
            Text("Vote for the Funniest Sentence!")
                .font(.largeTitle)
                .padding()

            List {
                ForEach(multipeerManager.submittedSentences.keys.sorted(by: { $0.displayName < $1.displayName }), id: \.self) { peer in
                    
                    HStack {
                        
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
                        
                        Button(action: {
                            multipeerManager.submitVote(for: peer)
                        }) {
                            Image(systemName: multipeerManager.hasVoted ? "checkmark.circle.fill" : "circle")
                                .contentShape(Rectangle())
                        }
                        .disabled(multipeerManager.hasVoted) // Prevent multiple votes
                    }
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
}*/

struct VotingView_Preview: View {
    @StateObject private var multipeerManager = MultipeerManager(displayName: "PreviewUser")

    var body: some View {
        VotingView(multipeerManager: multipeerManager)
            .onAppear {
                let peer1 = MCPeerID(displayName: "Alice")
                let peer2 = MCPeerID(displayName: "Bob")
                let peer3 = MCPeerID(displayName: "Charlie")

                multipeerManager.submittedSentences = [
                    peer1: "Why did the chicken cross the road? To get to the other side!",
                    peer2: "Parallel lines have so much in common. It’s a shame they’ll never meet.",
                    peer3: "I told my suitcase that there will be no vacations this year. Now I’m dealing with emotional baggage."
                ]
                
                multipeerManager.hasVoted = false
                multipeerManager.isHosting = true
            }
    }
}

#Preview {
    VotingView_Preview()
}


