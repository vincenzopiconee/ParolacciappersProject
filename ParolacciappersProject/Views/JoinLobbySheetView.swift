//
//  JoinLobbySheetView.swift
//  ParolacciappersProject
//
//  Created by Martha Mendoza Alfaro on 07/03/25.
//


import SwiftUI
import MultipeerConnectivity

struct JoinLobbySheetView: View {
    @ObservedObject var multipeerManager: MultipeerManager
    var selectedLobby: MCPeerID
    @Binding var enteredCode: String
    var onDismiss: () -> Void
    
    @State private var showInvalidCodeAlert = false  // Variabile per mostrare l'alert personalizzato

    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    HStack {
                        Button(action: {
                            onDismiss()
                        }) {
                            CancelButton()
                        }
                        Spacer()
                    }

                    Text("Enter Lobby Code")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 15)

                    ManualCodeEntryView(enteredCode: $enteredCode)
                        .padding(.vertical)

                    Button(action: {
                        multipeerManager.joinLobbyWithCode(selectedLobby, code: enteredCode)
                        
                        // Dopo 1 secondo, verifica se bisogna chiudere lo sheet o mostrare l'alert
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            if multipeerManager.shuldNavitgateToWaitScreen {
                                onDismiss()
                            } else {
                                showInvalidCodeAlert = true
                            }
                        }
                    }) {
                        ActionButton(title: "Join Lobby")
                    }
                    .disabled(enteredCode.count < 4)
                    .opacity(enteredCode.count < 4 ? 0.5 : 1.0)

                    Spacer()
                }
                .padding()
                .navigationBarBackButtonHidden(true)
            }
            
            // Mostra l'alert personalizzato sopra la UI principale
            if showInvalidCodeAlert {
                Color.black.opacity(0.5) // Sfondo scuro semi-trasparente
                    .edgesIgnoringSafeArea(.all)
                
                CustomAlert(
                    title: "Invalid Code",
                    message: "The code you entered is incorrect. Please try again."
                ) {
                    showInvalidCodeAlert = false
                }
                .transition(.scale)
            }
        }
        .animation(.easeInOut, value: showInvalidCodeAlert)
    }
}

// MARK: - Preview
#Preview {
    struct JoinLobbySheetView_Preview: View {
        @StateObject private var multipeerManager = MultipeerManager(displayName: "Test User")
        @State private var enteredCode = ""
        
        let testPeer = MCPeerID(displayName: "Test Lobby")

        var body: some View {
            JoinLobbySheetView(multipeerManager: multipeerManager, selectedLobby: testPeer, enteredCode: $enteredCode) {
                print("Sheet dismissed")
            }
        }
    }
    
    return JoinLobbySheetView_Preview()
}

