//
//  ScenarioRevealView.swift
//  ParolacciappersProject
//
//  Created by Martha Mendoza Alfaro on 07/03/25.
//


import SwiftUI

struct ScenarioRevealView: View {
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
                            
                            Text("Write a sentence using the word \"\(multipeerManager.chosenWord ?? "no word selected")\" in this scenario:")
                                .font(.title)
                                .bold()
                                .fontDesign(.rounded)
                            
                            Spacer()
                            
                        }
                        
                        Spacer()


                        Text(multipeerManager.chosenScenario ?? "Selecting a scenario...")
                            .font(.title)
                            .padding()
                            .bold()
                            .fontDesign(.rounded)
                            .frame(maxWidth: .infinity)
                            .background(Color.accentColor)
                            .cornerRadius(12)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.black, lineWidth: 3)
                            )
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
                
                CustomExitAlert(multipeerManager: multipeerManager, title: "Why the #@%! are you leaving?", message: "You won’t be able to join this game anymore. Are you sure?", isPresented: $showAlert
               )
                .transition(.scale)
                .accessibilityAddTraits(.isModal)
            }
        }
        
        
    }
}

struct ScenarioRevealView_Preview: View {
    @StateObject private var multipeerManager = MultipeerManager(displayName: "Placeholder")

    var body: some View {
        ScenarioRevealView(multipeerManager: multipeerManager)
            .onAppear {
                // Simulating available lobbies
                multipeerManager.isHosting = true
            }
    }
}

#Preview {
    ScenarioRevealView_Preview()
}
