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
            Text("Wait for host to start the game...")
            Text(multipeerManager.shouldNavigateToGame ? "Navigating..." : "Waiting...")
        }
        
        .navigationDestination(isPresented: $multipeerManager.shouldNavigateToGame) {
            GameView(multipeerManager: multipeerManager)
        }
        
    }
        
}

#Preview {
    WaitStartGameView(multipeerManager: MultipeerManager(displayName: "Placeholder")
    )
}
