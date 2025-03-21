//
//  CustomAlert.swift
//  ParolacciappersProject
//
//  Created by Vincenzo Picone on 06/03/25.
//

import SwiftUI

struct CustomAlert: View {
    var title: LocalizedStringResource
    var message: LocalizedStringResource
    var onDismiss: () -> Void

    var body: some View {
        ZStack {
            // Effetto ombra per profondità
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black)
                .frame(width: 280, height: 150)
                .offset(x: 5, y: 7)

            VStack(spacing: 20) {
                Text(title)
                    .font(.title)
                    .bold()
                    .fontDesign(.rounded)
                    .foregroundColor(.black)
                    .padding(.top, 10)

                Text(message)
                    .bold()
                    .fontDesign(.rounded)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)

                Button(action: {
                    onDismiss()
                }) {
                    ActionButton(title: "Try Again", isDisabled: false)
                }
                .padding(.bottom, 20)
            }
            .frame(width: 300, height: 200)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.black, lineWidth: 3)
            )
        }
    }
}


#Preview {
    struct CustomAlertView_Preview: View {
        @State private var showAlert = true

        var body: some View {
            ZStack {
                Color.gray.opacity(0.2)
                    .edgesIgnoringSafeArea(.all)
                
                if showAlert {
                    CustomAlert(
                        title: "Wrong Code!",
                        message: "Ask the host for the code to make sure it is the correct one."
                    ) {
                        showAlert = false
                    }
                }
            }
        }
    }

    return CustomAlertView_Preview()
}
