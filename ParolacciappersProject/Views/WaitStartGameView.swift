//
//  WaitStartGameView.swift
//  ParolacciappersProject
//
//  Created by Vincenzo Picone on 04/03/25.
//

import SwiftUI

struct WaitStartGameView: View {
    
    @ObservedObject var multipeerManager: MultipeerManager
    
    
    var body: some View {
        NavigationStack {
            Text("Wait for the host to start the game...")
                .font(.headline)
                .foregroundColor(.black)
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
