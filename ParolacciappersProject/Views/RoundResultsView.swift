//
//  RoundResultsView.swift
//  ParolacciappersProject
//
//  Created by Martha Mendoza Alfaro on 07/03/25.
//

import SwiftUI
import MultipeerConnectivity

struct RoundResultsView: View {
    @ObservedObject var multipeerManager: MultipeerManager
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            VStack {
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        multipeerManager.disconnect()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        CancelButton()
                    }
                    
                }
                
                HStack {
                    Text("Round Results")
                        .font(.title)
                        .bold()
                        .fontDesign(.rounded)

                    Spacer()
                }
                
                Spacer()

                if multipeerManager.winner.isEmpty {
                    Text("No votes cast!")
                        .font(.title)
                        .padding()
                } else {
                    Text("The Winner is:")
                        .font(.title)
                        .bold()
                        .fontDesign(.rounded)

                    ForEach(multipeerManager.winner, id: \.self) { peer in
                        HostLobbyPlayers(peer: peer)
                            .padding()
                    }
                }
                
                Spacer()

                if multipeerManager.isHosting {
                    
                    Button(action: {
                        multipeerManager.advanceToNextPhase()
                    }, label: {
                        ActionButton(title: "Continue", isDisabled: false)
                    })
                    
                }
            }
            .padding()
            .background(Image("Background"))
            .navigationBarBackButtonHidden(true)
        }

        
    }
}

struct RoundResultsView_Preview: View {
    @StateObject private var multipeerManager = MultipeerManager(displayName: "Placeholder")

    var body: some View {
        RoundResultsView(multipeerManager: multipeerManager)
            .onAppear {
                multipeerManager.isHosting = true
                // Simulating available lobbies
                let peer1 = MCPeerID(displayName: "Mario")
                let peer2 = MCPeerID(displayName: "Marco")
                multipeerManager.availableLobbies = [
                    peer1: "1234",
                    peer2: "5678"
                ]
                multipeerManager.winner = [peer1]
            }
    }
}

#Preview {
    RoundResultsView_Preview()
}
