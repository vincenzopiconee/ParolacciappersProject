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
