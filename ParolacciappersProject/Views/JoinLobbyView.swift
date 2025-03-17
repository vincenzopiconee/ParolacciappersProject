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
                
                HStack {
                    Text("Choose a Lobby")
                        .font(.title)
                        .bold()
                        .fontDesign(.rounded)
                    
                    Spacer()
                    
                }
                
                
                // Lobby Selection Section
                VStack {
                    if multipeerManager.availableLobbies.isEmpty {
                        Text("Searching for lobbies...")
                            .foregroundColor(.gray)
                            .bold()
                            .fontDesign(.rounded)
                            .padding()
                    } else {
                        VStack {
                            List {
                                ForEach(Array(multipeerManager.availableLobbies.keys), id: \.self) { peer in
                                    Button(action: {
                                                selectedLobby = peer
                                                isLobbySelected = true // Attiva il fullScreenCover
                                    }) {
                                        LobbySelectionView(peer: peer)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(selectedLobby == peer ? Color.black.opacity(0.2) : Color.clear)
                                            )
                                        
                                    }
                                    .listRowSeparator(.hidden)
                                    .listRowBackground(Color.accentColor)
                                    
                                }
                            }
                            .scrollContentBackground(.hidden)
                            .background(Color.accentColor)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 3))
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .background(Image("background"))
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $multipeerManager.shuldNavitgateToWaitScreen) {
                WaitStartGameView(multipeerManager: multipeerManager)
            }
            .fullScreenCover(isPresented: $isLobbySelected) {
                JoinLobbySheetView(multipeerManager: multipeerManager, selectedLobby: selectedLobby!, enteredCode: $enteredCode) {
                    isLobbySelected = false // Chiude il sheet
                    selectedLobby = nil // Resetta selectedLobby
                    enteredCode = ""
                }
            }
        }
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
