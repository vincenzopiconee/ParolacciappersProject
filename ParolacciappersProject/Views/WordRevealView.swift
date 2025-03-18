//
//  WordRevealView.swift
//  ParolacciappersProject
//
//  Created by Martha Mendoza Alfaro on 07/03/25.
//
import SwiftUI

struct WordRevealView: View {
    @ObservedObject var multipeerManager: MultipeerManager
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
                            
                            Text("Chosen course word")
                                .font(.title)
                                .bold()
                                .fontDesign(.rounded)
                            
                            Spacer()
                            
                        }
                        
                        
                        Spacer()
                        
                        Text(multipeerManager.chosenWord ?? "Waiting for word...")
                            .font(.title)
                            .padding()
                            .bold()
                            .fontDesign(.rounded)
                            .frame(maxWidth: .infinity)
                            .background(Color.accentColor)
                            .cornerRadius(12)
                            .padding()
                        
                        Spacer()

                        if multipeerManager.isHosting {
                            
                            Button(action: {
                                multipeerManager.advanceToNextPhase()
                            }, label: {
                                ActionButton(title: "Continue", isDisabled: false)
                            })
                        }
                        
                    }
                    .padding()
                    
                }
                .navigationBarBackButtonHidden(true)
                
            }
            if showAlert {
                Color.black.opacity(0.5) // Sfondo scuro semi-trasparente
                    .edgesIgnoringSafeArea(.all)
                
                CustomExitAlert(multipeerManager: multipeerManager, title: "Why the #@%! are you leaving?", message: "You won’t partecipate to the game anymore. Are you sure?", isPresented: $showAlert
               )
                .transition(.scale)
                .accessibilityAddTraits(.isModal)
            }

            
        }
        
        
        
    }
}

struct WordRevealView_Preview: View {
    @StateObject private var multipeerManager = MultipeerManager(displayName: "Placeholder")

    var body: some View {
        WordRevealView(multipeerManager: multipeerManager)
            .onAppear {
                // Simulating available lobbies
                multipeerManager.isHosting = true
            }
    }
}


#Preview {
    WordRevealView_Preview()
}

