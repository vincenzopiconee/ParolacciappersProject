import SwiftUI

struct LobbyView: View {
    @StateObject var multipeerManager = MultipeerManager()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Game Lobby").font(.largeTitle).padding()
                
                Image(systemName: "gamecontroller.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                    .padding()
                
                Text("Welcome to the Multiplayer Game")
                    .font(.title2)
                    .padding(.bottom, 50)
                
                Button (action: {
                    multipeerManager.startHosting()
                }, label: {
                    HStack {
                        Image(systemName: "antenna.radiowaves.left.and.right")
                        Text("Host a Lobby")
                    }
                    .frame(width: 200)
                })
                .buttonStyle(.borderedProminent)
                .padding()
                
                Button(action: {
                    multipeerManager.startBrowsing()
                }, label: {
                    HStack {
                        Image(systemName: "person.2.fill")
                        Text("Join a Lobby")
                    }
                    .frame(width: 200)
                })
                .buttonStyle(.bordered)
                .padding()
                
                
                Spacer()
            }
            
            .navigationDestination(isPresented:  $multipeerManager.isHosting) {
                HostLobbyView(multipeerManager: multipeerManager)
            }
            .navigationDestination(isPresented: $multipeerManager.isBrowsing, destination: {
                JoinLobbyView(multipeerManager: multipeerManager)
            })
             
        }
    }
}

#Preview {
    NavigationView {
        LobbyView()
    }
}
