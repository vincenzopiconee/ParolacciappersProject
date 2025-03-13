//
//  BackButton.swift
//  ParolacciappersProject
//
//  Created by Vincenzo Picone on 05/03/25.
//

import SwiftUI

struct BackButton: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black)
                .frame(width: 45, height: 45)
                .offset(x: 5, y: 5)
            
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.black, lineWidth: 4)
                .background(Color.accentColor)
                .frame(width: 45, height: 45)
                .cornerRadius(12)
                .overlay(
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .fontDesign(.rounded)
                        .foregroundColor(.black)
                        .bold()
                )
        }
    }
}
#Preview {
    BackButton()
}
