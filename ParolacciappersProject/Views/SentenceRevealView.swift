//
//  SentenceRevealView.swift
//  ParolacciappersProject
//
//  Created by Martha Mendoza Alfaro on 18/03/25.
//


import SwiftUI
import MultipeerConnectivity

struct SentenceRevealView: View {
    @ObservedObject var multipeerManager: MultipeerManager
    @State private var selectedPeer: MCPeerID?
    //@State private var currentIndex: Int = 0
    @Environment(\.presentationMode) var presentationMode
    
    var peers: [MCPeerID] {
        Array(multipeerManager.submittedSentences.keys).sorted(by: { $0.displayName < $1.displayName })
    }

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
                
                HStack{
                    
                    Text("Read aloud your phrase")
                        .font(.title)
                        .bold()
                        .fontDesign(.rounded)
                    
                    Spacer()
                }
                
                Spacer()

                /*TabView(selection: $currentIndex) {
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
                */
                
                
                if peers.indices.contains(multipeerManager.currentIndex) {
                    let peer = peers[multipeerManager.currentIndex]
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
                } else {
                    Text("No phrases available")
                        .font(.title2)
                        .bold()
                        .fontDesign(.rounded)
                        .foregroundColor(.gray)
                }
                Spacer()

                if multipeerManager.isHosting {
                    Button(action: {
                        if multipeerManager.currentIndex < peers.count - 1 {
                            multipeerManager.currentIndex += 1
                            multipeerManager.broadcastPhraseIndex(multipeerManager.currentIndex)
                        } else {
                            multipeerManager.advanceToNextPhase()
                        }
                    }) {
                        ActionButton(
                            title: multipeerManager.currentIndex < peers.count - 1 ? "Next Phrase" : "Continue",
                            isDisabled: false
                        )
                    }
                }

            }
            .padding()
            .background(Image("Background"))
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct SentenceRevealView_Preview: View {
    @StateObject private var multipeerManager = MultipeerManager(displayName: "PreviewUser")

    var body: some View {
        SentenceRevealView(multipeerManager: multipeerManager)
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
    SentenceRevealView_Preview()
}
