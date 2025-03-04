import SwiftUI
import MultipeerConnectivity

struct JoinLobbyView: View {
    @ObservedObject var multipeerManager: MultipeerManager
    @State private var enteredCode = ""
    @State private var selectedLobby: MCPeerID?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Join a Lobby").font(.largeTitle).padding()
                
                if multipeerManager.availableLobbies.isEmpty {
                    Text("Searching for lobbies...")
                        .foregroundColor(.gray)
                        .italic()
                        .padding()
                } else {
                    List {
                        ForEach(Array(multipeerManager.availableLobbies.keys), id: \.self) { peer in
                            HStack {
                                Text(peer.displayName)
                                Spacer()
                                Text("Code: \(multipeerManager.availableLobbies[peer] ?? "")")
                            }
                            .onTapGesture {
                                selectedLobby = peer
                            }
                            .background(selectedLobby == peer ? Color.blue.opacity(0.2) : Color.clear)
                        }
                    }
                    .frame(height: 200)
                }
                
                if selectedLobby != nil {
                    TextField("Enter Lobby Code", text: $enteredCode)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    
                    Button("Join Lobby") {
                        if let lobby = selectedLobby {
                            multipeerManager.joinLobbyWithCode(lobby, code: enteredCode)
                        }
                        multipeerManager.shuldNavitgateToWaitScreen = true
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(enteredCode.isEmpty)
                }
                
                Spacer()
                
                Button("Cancel") {
                    multipeerManager.stopBrowsing()
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(.bordered)
                .padding()
            }
            .navigationBarBackButtonHidden(true)
            
            .navigationDestination(isPresented: $multipeerManager.shuldNavitgateToWaitScreen) {
                WaitStartGameView(multipeerManager: multipeerManager)
            }

             
        }
        
    }
}

#Preview {
    JoinLobbyView(multipeerManager: MultipeerManager(displayName: "Placeholder"))
}
