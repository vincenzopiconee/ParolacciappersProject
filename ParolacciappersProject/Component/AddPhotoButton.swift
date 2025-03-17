//
//  AddPhotoButton.swift
//  ParolacciappersProject
//
//  Created by Vincenzo Picone on 13/03/25.
//

import SwiftUI

struct AddPhotoButton: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black)
                .frame(width: 200, height: 200)
                .offset(x: 5, y: 7)
            
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .frame(width: 200, height: 200)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black, lineWidth: 3)
                )
            
            Text("\"Add photo\"")
                .font(.title2)
                .bold()
                .fontDesign(.rounded)
                .foregroundStyle(.black)
                .cornerRadius(12)
                .padding()
             
            
        }
    }
}

#Preview {
    AddPhotoButton()
}
