//
//  ParolacciappersProject

import SwiftUI
import MultipeerConnectivity

struct JoinLobbyView: View {
    @ObservedObject var multipeerManager: MultipeerManager
    @State private var enteredCode = ""
    @State private var selectedLobby: MCPeerID?
    @State private var isLobbySelected = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            VStack {
                
                HStack {
                    Button(action: {
                        multipeerManager.stopBrowsing()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        BackButton()
                    }
                    Spacer()
                }
                
                Text("Choose a Lobby")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 15)
                
                // Lobby Selection Section
                VStack {
                    if multipeerManager.availableLobbies.isEmpty {
                        Text("Searching for lobbies...")
                            .foregroundColor(.gray)
                            .italic()
                            .padding()
                    } else {
                        VStack {
                            List {
                                ForEach(Array(multipeerManager.availableLobbies.keys), id: \.self) { peer in
                                    LobbySelectionView(peer: peer)
                                        .onTapGesture {
                                            selectedLobby = peer
                                            isLobbySelected = true // Attiva il sheet
                                        }
                                        .listRowSeparator(.hidden)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(selectedLobby == peer ? Color.black.opacity(0.2) : Color.clear)
                                        )
                                }
                            }
                            .scrollContentBackground(.hidden)
                            .background(Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 3))
                        }
                    }
                }
                .padding()
                
                Spacer()
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $multipeerManager.shuldNavitgateToWaitScreen) {
                WaitStartGameView(multipeerManager: multipeerManager)
            }
            .sheet(isPresented: $isLobbySelected) {
                JoinLobbySheetView(multipeerManager: multipeerManager, selectedLobby: selectedLobby!, enteredCode: $enteredCode) {
                    isLobbySelected = false // Chiude il sheet
                    selectedLobby = nil // Resetta selectedLobby
                    enteredCode = ""
                }

            }
        }
    }
}



struct LobbySelectionView: View {
    var peer: MCPeerID
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(peer.displayName)
                    .font(.headline)
                    .foregroundColor(.black)
            }
            Spacer()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 3))
    }
}


struct JoinLobbyView_Preview: View {
    @StateObject private var multipeerManager = MultipeerManager(displayName: "Placeholder")

    var body: some View {
        JoinLobbyView(multipeerManager: multipeerManager)
            .onAppear {
                // Simulating available lobbies
                let peer1 = MCPeerID(displayName: "Lobby 1")
                let peer2 = MCPeerID(displayName: "Lobby 2")
                multipeerManager.availableLobbies = [
                    peer1: "1234",
                    peer2: "5678"
                ]
            }
    }
}

#Preview {
    JoinLobbyView_Preview()
}
