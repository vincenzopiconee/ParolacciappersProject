//
//  WordSubmissionView.swift
//  ParolacciappersProject
//
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
                

                Spacer()

  
                if multipeerManager.submittedWords[multipeerManager.myPeerID] == nil {
                    TextField("Enter your word", text: $message)
                        .textFieldStyle(.roundedBorder)

                        .padding(.horizontal)
                    
                    Button("Submit") {
                        if !message.isEmpty {
                            multipeerManager.sendWord(message)
                            message = ""
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(message.isEmpty)

                    .padding()
                } else if !multipeerManager.allWordsSubmitted {
                    Text("Waiting for other players to send their words...")
                } else if multipeerManager.isHosting {
                    Button("Continue") {
                        multipeerManager.advanceToNextPhase()
                        //multipeerManager.advanceToNextScreen()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!multipeerManager.allWordsSubmitted)
                }
                
                Spacer()
                
                
                Button("Leave Game") {
                    multipeerManager.disconnect()
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(.bordered)
                .padding(.bottom)
            }
            .navigationBarBackButtonHidden(true)

        }
        
    }
}


#Preview {
    WordSubmissionView(multipeerManager: MultipeerManager(displayName: "Placeholder"))

}
