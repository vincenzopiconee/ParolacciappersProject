//
//  ActionButton.swift
//  ParolacciappersProject
//
//  Created by Vincenzo Picone on 06/03/25.
//

import SwiftUI

struct ActionButton: View {
    var title: String
    var isDisabled: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(isDisabled ? Color.gray.opacity(0.2) : Color.black)
                .frame(width: 250, height: 50)
                .offset(x: 5, y: 7)
            
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.accentColor)
                .frame(width: 250, height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black, lineWidth: 3)
                )
            
            Text(title)
                .font(.title2)
                .bold()
                .fontDesign(.rounded)
                .foregroundColor(.black)
        }
    }
}

#Preview {
    ActionButton(title: "Join Lobby", isDisabled: true)
}
