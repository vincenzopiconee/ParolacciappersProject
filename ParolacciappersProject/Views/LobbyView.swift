import SwiftUI

struct LobbyView: View {
    
    @StateObject private var multipeerManager = MultipeerManager(displayName: "Placeholder")
    @State private var isHost: Bool = false
    @State private var navigateToCreateUser = false

    var body: some View {
        NavigationStack {
            ZStack {
                Image("Background")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack {
                    Button(action: {
                        //multipeerManager.startHosting()
                        isHost = true
                        navigateToCreateUser = true
                    }, label: {
                        
                        ActionButton(title: "Create Game", isDisabled: false)
                        /*
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
                         */
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
                                .font(.title2)
                                .bold()
                                .fontDesign(.rounded)
                                .foregroundColor(.black)
                                .frame(width: 200, height: 50)
                                .background(Color.accentColor)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.black, lineWidth: 2)
                                )
                        }
                        
                    })
                    
                }
                .padding()
            }
            .navigationDestination(isPresented: $navigateToCreateUser) {
                CreateUserView(isHost: isHost, multipeerManager: multipeerManager)
            }
        }
    }
}

#Preview {
    NavigationView {
        LobbyView()
    }
}
