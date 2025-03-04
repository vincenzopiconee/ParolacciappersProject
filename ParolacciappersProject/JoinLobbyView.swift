//
//  ParolacciappersProject

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
                
                HStack {
                    Button(action: {
                        //back action
                        multipeerManager.stopBrowsing()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        BackButton()
                    }
                    Spacer()
                }
                
                Text("Join a Lobby and Enter Its Swearcode")
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
                                        }
                                        .listRowSeparator(.hidden)
                                        .background(selectedLobby == peer ? Color.gray.opacity(0.2) : Color.clear)
                                }
                            }
                            //.frame(height: 500)
                            .scrollContentBackground(.hidden) // Hides the default List background
                            .background(Color.clear) //no background
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 3))
                        }
                    }
                }
                .padding()
                
                if selectedLobby != nil {
                    ManualCodeEntryView(enteredCode: $enteredCode)
                        .padding(.vertical)
                    
                    Button(action: {
                        if let lobby = selectedLobby {
                            multipeerManager.joinLobbyWithCode(lobby, code: enteredCode)
                        }

                        multipeerManager.shuldNavitgateToWaitScreen = true

                    }) {
                        ActionButton(title: "Join Lobby")

                    }
                    .disabled(enteredCode.count < 4) //only enable if 4 digits are entered
                    .opacity(enteredCode.count < 4 ? 0.5 : 1.0)
                }
                Spacer()

            }
            .padding()
            .navigationBarBackButtonHidden(true)

            
            .navigationDestination(isPresented: $multipeerManager.shuldNavitgateToWaitScreen) {
                WaitStartGameView(multipeerManager: multipeerManager)

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


// Code Entry Thing (need to check for stuff)
struct ManualCodeEntryView: View {
    @Binding var enteredCode: String
    @FocusState private var isTextFieldFocused: Bool //Focus control*

    var body: some View {
        VStack {
            // Hidden text field for input
            TextField("", text: $enteredCode)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode) //Helps with auto-fill
                .focused($isTextFieldFocused) //Binds focus state
                .onChange(of: enteredCode) { oldValue, newValue in
                    enteredCode = String(newValue.prefix(4)) // Limit to 4 digits
                }
                .frame(width: 1, height: 1)
                .opacity(0.01) //Nearly invisible but still interactive
                .padding(.bottom, -20) // Ensures no UI interference
            
            // Tapable code entry UI
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
                }
            }
            .contentShape(Rectangle()) //Expands tap area
            .onTapGesture {
                isTextFieldFocused = true //Open keyboard when tapped
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isTextFieldFocused = true //Ensure it gets focus when view appears
                }
            }
        }
    }

    //Helper function to get digit at index or placeholder
    private func getDigit(at index: Int) -> String {
        if index < enteredCode.count {
            return String(enteredCode[enteredCode.index(enteredCode.startIndex, offsetBy: index)])
        }
        return "-"
    }
}

struct ActionButton: View {
    var title: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black)
                .frame(width: 250, height: 50)
                .offset(x: 5, y: 7)
            
            Text(title)
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
