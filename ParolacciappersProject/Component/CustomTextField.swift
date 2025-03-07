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
                .accessibilityHidden(true)
            
            
            TextField("", text: $text, prompt: Text("Required"))
                .padding()
                .background(Color.white)
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.black, lineWidth: 2)
                )
             
                .accessibilityLabel(title)
            
        }
    }
}

#Preview {
    @Previewable @State var text = "Vincenzo"
    CustomTextField(title: "Name", text: $text)
}
