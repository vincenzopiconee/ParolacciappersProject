//
//  CancelButton.swift
//  ParolacciappersProject
//
//  Created by Vincenzo Picone on 06/03/25.
//

import SwiftUI

struct CancelButton: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.black)
                .frame(width: 50, height: 50)
                .offset(x: 5, y: 5)
            
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.black, lineWidth: 4)
                .background(Color(hex: "#BAE575"))
                .frame(width: 50, height: 50)
                .cornerRadius(5)
                .overlay(
                    Image(systemName: "xmark")
                        .font(.headline)
                        .foregroundColor(.black)
                )
        }
    }
}

#Preview {
    CancelButton()
}
