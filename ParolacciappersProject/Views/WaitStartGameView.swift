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
            VStack {
                
                HStack {
                    Button(action: {
                        multipeerManager.disconnect()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        CancelButton()
                    }
                    Spacer()
                }
                
                Spacer()
                
                Text("Wait for the host to start the game...")
                    .font(.headline)
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding()
            
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
