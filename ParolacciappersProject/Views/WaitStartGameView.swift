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
            
        }
        
        .navigationDestination(isPresented: $multipeerManager.shouldNavigateToGame) {
            GameView(multipeerManager: multipeerManager)
        }
        .navigationBarBackButtonHidden(true)
        
    }
        
}

#Preview {
    WaitStartGameView(multipeerManager: MultipeerManager(displayName: "Placeholder")
    )
}
