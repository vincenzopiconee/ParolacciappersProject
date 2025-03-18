//
//  WordSubmissionView.swift
//  ParolacciappersProject
//
//

import SwiftUI

struct WordSubmissionView: View {
    @ObservedObject var multipeerManager: MultipeerManager
    @State private var message = ""
    @State private var definition = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            VStack {
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        multipeerManager.resetGame()
                        multipeerManager.disconnect()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        CancelButton()
                    }
                    
                }
                
                HStack {
                    Text("Add your curse word!")
                        .font(.title)
                        .bold()
                        .fontDesign(.rounded)
                    
                    Spacer()
                    /*
                    Text("Connected: \(multipeerManager.connectedPeers.count)")
                        .foregroundColor(multipeerManager.connectedPeers.isEmpty ? .red : .green)
                        .padding(.trailing)
                     */
                }
                

                Spacer()

  
                if multipeerManager.submittedWords[multipeerManager.myPeerID] == nil {
                    
                    VStack(alignment: .leading, spacing: 10) {
                        CustomTextField(title: "Word", text: $message)
                        CustomTextField(title: "Definition", text: $definition)
                        // commented for TestFligth
                        //CustomTextField(title: "Nationality", text: $nationality)
                        //CustomTextField(title: "Language", text: $language)
                    }
                    .padding()
                    .background(Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black, lineWidth: 3)
                    )
                    
                    Spacer()
                    
                    
                    Button(action: {
                        if !message.isEmpty {
                            multipeerManager.sendWord(message)
                            message = ""
                        }
                    }, label: {
                        ActionButton(title: "Submit", isDisabled: message.isEmpty)
                    })
                    .disabled(message.isEmpty)

                    .padding()
                } else if !multipeerManager.allWordsSubmitted {
                    Text("Waiting for other players to send their words...")
                        .font(.title3)
                        .bold()
                        .fontDesign(.rounded)
                    Spacer()
                } else if multipeerManager.isHosting {
                    Button(action: {
                        multipeerManager.advanceToNextPhase()
                    }, label: {
                        ActionButton(title: "Continue", isDisabled: false)
                    })
                }
                
                /*
                
                Spacer()
                
                
                Button("Leave Game") {
                    multipeerManager.disconnect()
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(.bordered)
                .padding(.bottom)
                 
                 */
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .background(Image("background"))

        }
        
    }
}


#Preview {
    WordSubmissionView(multipeerManager: MultipeerManager(displayName: "Placeholder"))

}
