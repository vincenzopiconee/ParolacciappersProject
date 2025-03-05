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
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.black)
                .frame(width: 50, height: 50)
                .offset(x: 5, y: 5)
            
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.black, lineWidth: 4)
                .background(Color.white)
                .frame(width: 50, height: 50)
                .cornerRadius(5)
                .overlay(
                    Image(systemName: "chevron.left")
                        .font(.headline)
                        .foregroundColor(.black)
                )
        }
    }
}
#Preview {
    BackButton()
}
