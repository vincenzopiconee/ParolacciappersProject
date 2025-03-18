//
//  SentenceSubmissionView.swift
//  ParolacciappersProject
//
//  Created by Martha Mendoza Alfaro on 07/03/25.
//


import SwiftUI

struct SentenceSubmissionView: View {
    @ObservedObject var multipeerManager: MultipeerManager
    @State private var message = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var messageSent = "Sentence already submitted"
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("Background")
                    .resizable()
                    .ignoresSafeArea()
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
                        Text("Write your sentence")
                            .font(.title)
                            .bold()
                            .fontDesign(.rounded)
                        
                        Spacer()
                    }
                    Spacer()
                    
                    // Display the word and scenario
                    VStack(alignment: .leading) {
                        
                        Text("Current curse word\n")
                            .fontDesign(.rounded)
                            .padding(.bottom, -30)
                        Text("\(multipeerManager.chosenWord ?? "No Word Selected")")
                            .font(.title)
                            .bold()
                            .fontDesign(.rounded)
                            .padding(.bottom, 10)
                        
                        Text("Scenario\n")
                            .fontDesign(.rounded)
                            .padding(.bottom, -30)
                        Text("\(multipeerManager.chosenScenario ?? "No Scenario Selected")")
                            .font(.title)
                            .bold()
                            .fontDesign(.rounded)
                        
                        CustomTextField(title: "Your sentence", text: $message)
                            .padding(.top, 10)
                        
                        /*else {
                         Text("Wait for other players to submit their sentences...")
                         .font(.title)
                         .bold()
                         .fontDesign(.rounded)
                         }*/
                    }
                    .padding(30)
                    .background(Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black, lineWidth: 3)
                    )
                    
                    Spacer()
                    
                    
                    // Input field for submitting the sentence
                    if multipeerManager.submittedSentences[multipeerManager.myPeerID] == nil {
                        
                        Button(action: {
                            
                            if !message.isEmpty {
                                multipeerManager.sendSentence(message)
                            }
                            
                        }, label: {
                            
                            ActionButton(title: "Submit", isDisabled: message.isEmpty)
                            
                        })
                        .disabled(message.isEmpty)
                        
                        
                    } else if multipeerManager.isHosting {
                        
                        Button(action: {
                            multipeerManager.advanceToNextPhase()
                        }, label: {
                            ActionButton(title: "Continue", isDisabled: !multipeerManager.allSentencesSubmitted)
                        })
                        .disabled(!multipeerManager.allSentencesSubmitted)
                        
                        
                    } else {
                        
                        Button(action: {
                            
                            
                        }, label: {
                            
                            ActionButton(title: "Wait for the host", isDisabled: true)
                            
                        })
                        
                    }
                }
                .padding()
            }
            .navigationBarBackButtonHidden(true)
        }
        
    }
}


#Preview {
    SentenceSubmissionView(multipeerManager: MultipeerManager(displayName: "Placeholder"))
}
