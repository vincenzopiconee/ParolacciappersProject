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
    @State private var selectedPeer: MCPeerID?
    @State private var currentIndex: Int = 0
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert: Bool = false
    
    var peers: [MCPeerID] {
        Array(multipeerManager.submittedSentences.keys).sorted(by: { $0.displayName < $1.displayName })
    }

    var body: some View {
        ZStack {
            NavigationStack {
                ZStack {
                    Image("Background")
                        .resizable()
                        .ignoresSafeArea()
                    
                    VStack {
                        
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                showAlert = true
                            }) {
                                CancelButton()
                            }
                        }
                        
                        HStack{
                            
                            Text("Vote for your favorite one")
                                .font(.title)
                                .bold()
                                .fontDesign(.rounded)
                            
                            Spacer()
                        }


                        
                        
                        Spacer()

                        TabView(selection: $currentIndex) {
                            ForEach(0..<peers.count, id: \.self) { index in
                                let peer = peers[index]
                                VStack {
                                    Text("\(peer.displayName)'s phrase")
                                        .font(.title2)
                                        .bold()
                                        .fontDesign(.rounded)
                                    
                                    Text("\"\(multipeerManager.submittedSentences[peer] ?? "")\"")
                                        .font(.title3)
                                        .fontDesign(.rounded)
                                        .padding(.vertical, 2)
                                    
                                }
                                .padding(24)
                                .background(Color.accentColor)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 3))
                                .padding()
                                .tag(index)
                            }
                        }
                        .tabViewStyle(.page)
                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                        
                        Spacer()

                        // Vote button
                        if multipeerManager.isHosting && multipeerManager.allVotesSubmitted {
                            Button(action: {
                                multipeerManager.advanceToNextPhase()
                            }) {
                                ActionButton(title: "See Results", isDisabled: !multipeerManager.allVotesSubmitted)
                            }
                            .disabled(!multipeerManager.allVotesSubmitted)
                        } else if peers.indices.contains(currentIndex) {
                            let peer = peers[currentIndex]
                            Button(action: {
                                selectedPeer = peer
                                multipeerManager.submitVote(for: peer)
                                multipeerManager.hasVoted = true
                            }) {
                                ActionButton(title: "Vote", isDisabled: multipeerManager.hasVoted)
                            }
                            .disabled(multipeerManager.hasVoted)
                        }
                        
                        
                    }
                    .padding()
                    
                }
                .navigationBarBackButtonHidden(true)
            }
            if showAlert {
                Color.black.opacity(0.5) // Sfondo scuro semi-trasparente
                    .edgesIgnoringSafeArea(.all)
                
                CustomExitAlert(multipeerManager: multipeerManager, title: "Why the #@%! are you leaving?", message: "You won’t partecipate to the game anymore. Are you sure?", isPresented: $showAlert
               )
                .transition(.scale)
                .accessibilityAddTraits(.isModal)
            }
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




