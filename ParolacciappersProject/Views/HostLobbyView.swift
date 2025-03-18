import SwiftUI
import MultipeerConnectivity

struct HostLobbyView: View {
    @ObservedObject var multipeerManager: MultipeerManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            VStack {
                
                HStack {
                    Button (action: {
                        multipeerManager.stopHosting()
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        BackButton()
                    })
                    Spacer()
                }
                
                HStack {
                    Text("\(multipeerManager.displayName)'s Lobby")
                        .font(.title)
                        .bold()
                        .fontDesign(.rounded)
                    
                    Spacer()
                }
                
                HStack(spacing: 10) {
                    ForEach(0..<4, id: \.self) { index in
                        Text(getDigit(at: index))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .frame(width: 60, height: 80)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.black, lineWidth: 3)
                            )
                            .accessibilityHidden(true) // Prevents VoiceOver from reading each digit separately
                    }
                }
                .contentShape(Rectangle())
                .padding()
                
                VStack(alignment: .leading) {
                    
                    Text("Connected players (\(multipeerManager.connectedPeers.count)):")
                        .font(.title2)
                        .bold()
                        .fontDesign(.rounded)
                    
                    List {
                        ForEach(multipeerManager.connectedPeers, id: \.self) { peer in
                            HostLobbyPlayers(peer: peer)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.accentColor)
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 3))
                }
                .padding(.vertical)
                
                Spacer()
                
                Button(action: {
                    multipeerManager.startGame()
                }, label: {
                    ActionButton(title: "Let's F*ing Play!", isDisabled: multipeerManager.connectedPeers.isEmpty)
                })
                .disabled(multipeerManager.connectedPeers.isEmpty)
                    
            }
            .padding()
            .background(Image("Background"))
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $multipeerManager.shouldNavigateToGame) {
                GameView(multipeerManager: multipeerManager)
            }
        }
        
    }
    
    private func getDigit(at index: Int) -> String {
        if index < multipeerManager.lobbyCode.count {
            return String(multipeerManager.lobbyCode[multipeerManager.lobbyCode.index(multipeerManager.lobbyCode.startIndex, offsetBy: index)])
        }
        return "-"
    }
}

struct HostLobbyView_Preview: View {
    @StateObject private var multipeerManager = MultipeerManager(displayName: "Placeholder")

    var body: some View {
        HostLobbyView(multipeerManager: multipeerManager)
            .onAppear {
                // Simulating available lobbies
                let peer1 = MCPeerID(displayName: "Lobby 1")
                let peer2 = MCPeerID(displayName: "Lobby 2")
                multipeerManager.connectedPeers = [
                    peer1,
                    peer2
                ]
            }
    }
}

#Preview {
    HostLobbyView_Preview()
}
