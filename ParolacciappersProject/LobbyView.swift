import SwiftUI

struct LobbyView: View {
    @StateObject var multipeerManager = MultipeerManager()
    
    var body: some View {
        NavigationStack {
            VStack {
                Button(action: {
                    multipeerManager.startHosting()
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.black)
                            .frame(width: 250, height: 50)
                            .offset(x: 5, y: 7)
                        
                        Text("Create Game")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(width: 250, height: 50)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                    }
                })
                .padding(.bottom)
            
                
                Button(action: {
                    multipeerManager.startBrowsing()
                    
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.black)
                            .frame(width: 200, height: 50)
                            .offset(x: 5, y: 7)
                        
                        Text("Join Game")
                            .font(.body)
                            .foregroundColor(.black)
                            .frame(width: 200, height: 50)
                            .background(Color.gray)
                        //.opacity(0.7)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                    }
                })
                
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
