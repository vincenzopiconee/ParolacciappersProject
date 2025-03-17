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

    var body: some View {
        NavigationStack {
            VStack {
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        multipeerManager.disconnect()
                        presentationMode.wrappedValue.dismiss()
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
            .background(Image("background"))
            .navigationBarBackButtonHidden(true)
            
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

