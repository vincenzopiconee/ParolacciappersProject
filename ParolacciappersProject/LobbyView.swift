import SwiftUI

struct LobbyView: View {
    
    @StateObject private var multipeerManager = MultipeerManager(displayName: "Placeholder")
    //@StateObject var multipeerManager = MultipeerManager(displayName: "Placeholder")
    @State private var isHost: Bool = false
    @State private var navigateToCreateUser = false

    var body: some View {
        NavigationStack {
            VStack {
                Button(action: {
                    //multipeerManager.startHosting()
                    isHost = true
                    navigateToCreateUser = true
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
                    //multipeerManager.startBrowsing()
                    isHost = false
                    navigateToCreateUser = true
                    
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
            .navigationDestination(isPresented: $navigateToCreateUser) {
                CreateUserView(isHost: isHost, multipeerManager: multipeerManager)
            }
            
            /*.navigationDestination(isPresented:  $multipeerManager.isHosting) {
                HostLobbyView(multipeerManager: multipeerManager)
            }
            .navigationDestination(isPresented: $multipeerManager.isBrowsing, destination: {
                JoinLobbyView(multipeerManager: multipeerManager)
            })*/
             
        }
    }
}

#Preview {
    NavigationView {
        LobbyView()
    }
}
