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
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.title3)
                .fontDesign(.rounded)
                .bold()
                .foregroundColor(.black)
                .accessibilityHidden(true)
            
            
            ZStack {
                // Bordo nero spostato per creare l'effetto brutalista
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black)
                    .offset(x: 6, y: 6) // Sposta il bordo nero verso il basso e destra
                    .frame(height: 57) // Altezza fissa, larghezza dinamica
                
                TextField("", text: $text, prompt: Text("Required"))
                    .bold()
                    .fontDesign(.rounded)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black, lineWidth: 1.5)
                    )
                
            }
            
        }
    }
}

#Preview {
    @Previewable @State var text = "Vincenzo"
    CustomTextField(title: "Name", text: $text)
}
