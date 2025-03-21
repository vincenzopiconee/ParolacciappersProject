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
    @State private var showAlert: Bool = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                ZStack {
                    Image("Background")
                        .resizable()
                        .ignoresSafeArea()
                    
                    VStack {
                        
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                showAlert = true
                                
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
                                if !message.isEmpty && !definition.isEmpty {
                                    //multipeerManager.sendWord(message)
                                    multipeerManager.sendWord(message, definition: definition)

                                    message = ""
                                    definition = ""

                                }
                            }, label: {
                                ActionButton(title: "Submit", isDisabled: message.isEmpty || definition.isEmpty)
                            })
                            .disabled(message.isEmpty || definition.isEmpty)

                        } else if !multipeerManager.allWordsSubmitted {
                            Text("Waiting for other players to send their words...")
                                .font(.title3)
                                .bold()
                                .fontDesign(.rounded)
                            Spacer()
                        } else if multipeerManager.isHosting {
                            
                            Text("All players have submitted their words! Press continue...")
                                .font( .title3)
                                .bold()
                                .fontDesign(.rounded)
                            
                            Spacer()
                            
                            Button(action: {
                                multipeerManager.advanceToNextPhase()
                                
                            }, label: {
                                ActionButton(title: "Continue", isDisabled: !multipeerManager.allWordsSubmitted)
                                    
                            })
                            .disabled(!multipeerManager.allWordsSubmitted)
                        } else {
                            Text("Waiting for the host continue the game...")
                                .font(.title3)
                                .bold()
                                .fontDesign(.rounded)
                            Spacer()
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
                }
                
                .navigationBarBackButtonHidden(true)

            }
            if showAlert {
                Color.black.opacity(0.5) // Sfondo scuro semi-trasparente
                    .edgesIgnoringSafeArea(.all)
                
                CustomExitAlert(multipeerManager: multipeerManager, title: "Why the #@%! are you leaving?", message: "You won’t be able to join this game anymore. Are you sure?", isPresented: $showAlert
               )
                .transition(.scale)
                .accessibilityAddTraits(.isModal)
            }
        }
        
    }
}


#Preview {
    WordSubmissionView(multipeerManager: MultipeerManager(displayName: "Placeholder"))

}
