import SwiftUI
import MultipeerConnectivity

struct HostLobbyView: View {
    @ObservedObject var multipeerManager: MultipeerManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Hosting Lobby").font(.largeTitle).padding()
                
                VStack(alignment: .leading) {
                    Text("Your Device: \(multipeerManager.displayName)")
                        .font(.headline)
                        .padding(.vertical)
                    
                    Text("Lobby Code: \(multipeerManager.lobbyCode)")
                        .font(.headline)
                        .padding(.vertical)
                    
                    Text("Connected players (\(multipeerManager.connectedPeers.count)):")
                        .font(.headline)
                        .padding(.top)
                    
                    List {
                        ForEach(multipeerManager.connectedPeers, id: \.self) { peer in
                            Text(peer.displayName)
                        }
                    }
                    .frame(height: 200)
                }
                .padding()
                
                Spacer()
                
                HStack {
                    Button("Cancel") {
                        multipeerManager.stopHosting()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .buttonStyle(.bordered)
                    .padding()
                    
                    Spacer()
                    
                    NavigationLink(destination: GameView(multipeerManager: multipeerManager)) {
                        Text("Start Game")
                            .bold()
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                    .disabled(multipeerManager.connectedPeers.isEmpty)
                     
                }
            }
            .navigationBarBackButtonHidden(true)
        }
        
    }
}

#Preview {
    HostLobbyView(multipeerManager: MultipeerManager(displayName: "Placeholder"))
}
