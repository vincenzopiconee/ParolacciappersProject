//
//  ActionButton.swift
//  ParolacciappersProject
//
//  Created by Vincenzo Picone on 06/03/25.
//

import SwiftUI

struct ActionButton: View {
    var title: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black)
                .frame(width: 250, height: 50)
                .offset(x: 5, y: 7)
            
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
                .frame(width: 250, height: 50)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black, lineWidth: 2)
                )
        }
    }
}

#Preview {
    ActionButton(title: "Join Lobby")
}
