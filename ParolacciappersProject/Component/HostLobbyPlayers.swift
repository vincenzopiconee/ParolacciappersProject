//
//  HostLobbyPlayers.swift
//  ParolacciappersProject
//
//  Created by Vincenzo Picone on 13/03/25.
//

import SwiftUI
import MultipeerConnectivity

struct HostLobbyPlayers: View {
    
    var peer: MCPeerID
    
    var body: some View {
        HStack {
            
            //PHOTO
            
            Text("\(peer.displayName)")
                .font(.title3)
                .bold()
                .fontDesign(.rounded)
                .foregroundColor(.black)
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 3))
    }
}

#Preview {
    HostLobbyPlayers(peer: MCPeerID(displayName: "Placeholder"))
}
