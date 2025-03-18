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
    @Environment(\.presentationMode) var presentationMode
    

    var body: some View {
        
        NavigationStack {
            VStack {
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        multipeerManager.resetGame()
                        multipeerManager.disconnect()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        CancelButton()
                    }
                    
                }
                
                HStack {
                    Text("Vote for your favorite one")
                        .font(.title)
                        .bold()
                        .fontDesign(.rounded)

                    Spacer()
                }
                
                
                Spacer()

                List {
                    ForEach(Array(multipeerManager.submittedSentences.keys).sorted(by: { $0.displayName < $1.displayName }), id: \.self) { peer in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(peer.displayName)'s phrase")
                                    .font(.headline)
                                    .bold()
                                    .fontDesign(.rounded)
                                Text("\"\(multipeerManager.submittedSentences[peer] ?? "")\"")
                                    .italic()
                                    .fontDesign(.rounded)
                            }
                            .padding()
                            .background(selectedPeer == peer ? Color.blue.opacity(0.2) : Color.clear) // Highlight selected

                            .cornerRadius(12)

                            Button(action: {
                                selectedPeer = peer // Select the chosen sentence
                            }) {
                                Image(systemName: selectedPeer == peer ? "checkmark.circle.fill" : "circle")
                                    .contentShape(Rectangle())
                            }
                            .disabled(multipeerManager.hasVoted)
                        }
                        .listRowSeparator(.hidden)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 3))

                // "Send Vote" button appears only if a selection is made
                
                Spacer()
                
                if selectedPeer != nil {
                    
                    Button(action: {
                        if let selected = selectedPeer {
                            multipeerManager.submitVote(for: selected) // Submit the selected vote
                            multipeerManager.hasVoted = true
                        }
                    }, label: {
                        ActionButton(title: "Send vote", isDisabled: multipeerManager.hasVoted)
                    })
                    
                    
                }
                
                Spacer()

                if multipeerManager.isHosting && multipeerManager.allVotesSubmitted {
                    
                    Button(action: {
                        multipeerManager.advanceToNextPhase()
                    }, label: {
                        ActionButton(title: "See Results", isDisabled: !multipeerManager.allVotesSubmitted)
                    })
                    
                }

                

            }
            .padding()
            .background(Image("background"))
            .navigationBarBackButtonHidden(true)
        }
        
    }
}

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

