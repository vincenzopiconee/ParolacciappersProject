//
//  LobbySelectionView.swift
//  ParolacciappersProject
//
//  Created by Vincenzo Picone on 13/03/25.
//

import SwiftUI
import MultipeerConnectivity

struct LobbySelectionView: View {
    var peer: MCPeerID
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(peer.displayName)'s Lobby")
                    .font(.title3)
                    .bold()
                    .fontDesign(.rounded)
                    .foregroundColor(.black)
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 3))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Lobby of \(peer.displayName)")
        .accessibilityAddTraits(.isButton)
     
    }
}

#Preview {
    LobbySelectionView(peer: MCPeerID(displayName: "Placeholder"))
}
