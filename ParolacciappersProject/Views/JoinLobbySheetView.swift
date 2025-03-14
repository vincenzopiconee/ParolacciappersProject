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
    
    @State private var showInvalidCodeAlert = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                ZStack {
                    Image("background")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        HStack {
                            Button(action: {
                                onDismiss()
                            }) {
                                CancelButton()
                            }
                            Spacer()
                        }
                        
                        Text("Enter the %@#! Lobby Code")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top, 45)
                        
                        ManualCodeEntryView(enteredCode: $enteredCode)
                            .padding(.vertical)
                            .focused($isTextFieldFocused)
                        
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
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.black)
                                    .frame(width: 250, height: 50)
                                    .offset(x: 5, y: 7)
                                
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(hex: "#BAE575"))
                                    .frame(width: 250, height: 50)
                                
                                Text("Join Lobby")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .frame(width: 250, height: 50)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.black, lineWidth: 3)
                                    )
                            }
                        }
                        .padding(.top, 20)
                        .disabled(enteredCode.count < 4)
                        
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
                    .accessibilityAddTraits(.isModal)
                }
            }
            .animation(.easeInOut, value: showInvalidCodeAlert)
        }
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

