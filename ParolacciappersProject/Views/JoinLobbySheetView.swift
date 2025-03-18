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
    @FocusState private var isTextFieldFocused: Bool
    
    @State private var showInvalidCodeAlert = false  // Variabile per mostrare l'alert personalizzato

    var body: some View {
        ZStack {
            NavigationStack {
                ZStack {
                    Image("Background")
                        .resizable()
                        .ignoresSafeArea()
                    VStack (){
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                onDismiss()
                            }) {
                                CancelButton()
                            }
                            
                        }
                        
                        Text("Enter Lobby Code")
                            .font(.title)
                            .bold()
                            .fontDesign(.rounded)
                            .padding(.top, 15)
                        
                        
                        Spacer()
                        
                        ManualCodeEntryView(enteredCode: $enteredCode)
                            .padding(.vertical)
                            .focused($isTextFieldFocused)
                        
                        Spacer()
                        
                        Button(action: {
                            
                            isTextFieldFocused = false
                            
                            multipeerManager.joinLobbyWithCode(selectedLobby, code: enteredCode)
                            
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                if multipeerManager.shuldNavitgateToWaitScreen {
                                    onDismiss()
                                } else {
                                    showInvalidCodeAlert = true
                                }
                            }
                        }) {
                            ActionButton(title: "Join Lobby", isDisabled: enteredCode.count < 4)
                        }
                        .disabled(enteredCode.count < 4)
                        
                    }
                    .padding()
                }
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
                .accessibilityAddTraits(.isModal)
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

