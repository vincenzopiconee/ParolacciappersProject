//
//  WordSubmissionView.swift
//  ParolacciappersProject
//
//  Created by Martha Mendoza Alfaro on 10/03/25.
//

import SwiftUI

struct WordSubmissionView: View {
    @ObservedObject var multipeerManager: MultipeerManager
    @State private var message = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Game Session")
                        .font(.title)
                        .padding()
                    
                    Spacer()
                    
                    Text("Connected: \(multipeerManager.connectedPeers.count)")
                        .foregroundColor(multipeerManager.connectedPeers.isEmpty ? .red : .green)
                        .padding(.trailing)
                }
                
  
                if multipeerManager.submittedWords[multipeerManager.myPeerID] == nil {
                    TextField("Enter your word", text: $message)
                        .textFieldStyle(.roundedBorder)
                    
                    Button("Submit") {
                        if !message.isEmpty {
                            multipeerManager.sendWord(message)
                            message = ""
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(message.isEmpty)
                } else if !multipeerManager.allWordsSubmitted {
                    Text("Waiting for other players to send their words...")
                } else if multipeerManager.isHosting {
                    Button("Next") {
                        multipeerManager.advanceToNextPhase()
                        //multipeerManager.advanceToNextScreen()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!multipeerManager.allWordsSubmitted)
                }
                
                Spacer()
                
                /*List {
                    ForEach(multipeerManager.messages, id: \.self) { msg in
                        Text(msg)
                            .padding(4)
                    }
                }
                
                HStack {
                    TextField("Type a message", text: $message)
                        .textFieldStyle(.roundedBorder)
                        .disabled(multipeerManager.connectedPeers.isEmpty)
                    
                    Button("Send") {
                        if !message.isEmpty {
                            multipeerManager.sendMessage(message)
                            message = ""
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(message.isEmpty || multipeerManager.connectedPeers.isEmpty)
                }
                .padding()
                 
                */
                
                Button("Leave Game") {
                    multipeerManager.disconnect()
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(.bordered)
                .padding(.bottom)
            }
            .navigationBarBackButtonHidden(true)
            /*.navigationDestination(isPresented: $multipeerManager.shouldNavigateToWordReveal) {
                    WordRevealView(multipeerManager: multipeerManager)
                }*/
            /*.navigationDestination(isPresented: Binding(
                get: { multipeerManager.gamePhase == .wordReveal },
                set: { _ in })) {
                    WordRevealView(multipeerManager: multipeerManager)
                }*/
        }
        
    }
}


#Preview {
    WordSubmissionView(multipeerManager: MultipeerManager(displayName: "Placeholder")
    )
}
