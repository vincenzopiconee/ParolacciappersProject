//
//  WaitStartGameView.swift
//  ParolacciappersProject
//
//  Created by Vincenzo Picone on 04/03/25.
//

import SwiftUI

struct WaitStartGameView: View {
    
    @ObservedObject var multipeerManager: MultipeerManager
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert: Bool = false
    
    
    var body: some View {
        ZStack{
            NavigationStack {
                ZStack{
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
                        
                        Spacer()
                        
                        Text("Wait for the host to start the game...")
                            .font(.title3)
                            .bold()
                            .fontDesign(.rounded)
                            .foregroundColor(.black)
                        
                        Spacer()
                    }
                    .padding()
                    
                }
                .navigationBarBackButtonHidden(true)
                .navigationDestination(isPresented: $multipeerManager.shouldNavigateToGame) {
                    GameView(multipeerManager: multipeerManager)
                }
                
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

#Preview {
    WaitStartGameView(multipeerManager: MultipeerManager(displayName: "Placeholder")
    )
}
