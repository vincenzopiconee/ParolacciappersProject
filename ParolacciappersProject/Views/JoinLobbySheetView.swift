//
//  JoinLobbySheetView.swift
//  ParolacciappersProject
//
//  Created by Vincenzo Picone on 06/03/25.
//

import SwiftUI
import MultipeerConnectivity

struct JoinLobbySheetView: View {
    @ObservedObject var multipeerManager: MultipeerManager
    var selectedLobby: MCPeerID
    @Binding var enteredCode: String
    var onDismiss: () -> Void

    var body: some View {
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
                    
                    if multipeerManager.shuldNavitgateToWaitScreen{
                        onDismiss()
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

