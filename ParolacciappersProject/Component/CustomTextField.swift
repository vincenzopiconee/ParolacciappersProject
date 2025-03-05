//
//  CustomTextField.swift
//  ParolacciappersProject
//
//  Created by Vincenzo Picone on 05/03/25.
//

import SwiftUI

struct CustomTextField: View {
    var title: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
            
            TextField("", text: $text)
                .padding()
                .background(Color.white)
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.black, lineWidth: 2)
                )
        }
    }
}

#Preview {
    @Previewable @State var text = "Vincenzo"
    CustomTextField(title: "Name", text: $text)
}
