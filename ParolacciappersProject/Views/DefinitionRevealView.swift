//
//  DefinitionRevealView.swift
//  ParolacciappersProject
//
//  Created by Martha Mendoza Alfaro on 17/03/25.
//



import SwiftUI

struct DefinitionRevealView: View {
    @ObservedObject var multipeerManager: MultipeerManager
    @Environment(\.presentationMode) var presentationMode

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
                        
                        Text("Definition")
                            .font(.title)
                            .bold()
                            .fontDesign(.rounded)
                        
                        Spacer()
                        
                    }
                    
                    
                    Spacer()
                    
                    Text(multipeerManager.chosenDefinition ?? "Waiting for definition...")
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
        
        
    }
}

struct DefinitionRevealView_Preview: View {
    @StateObject private var multipeerManager = MultipeerManager(displayName: "Placeholder")

    var body: some View {
        DefinitionRevealView(multipeerManager: multipeerManager)
            .onAppear {
                // Simulating available lobbies
                multipeerManager.isHosting = true
            }
    }
}


#Preview {
    DefinitionRevealView_Preview()
}
