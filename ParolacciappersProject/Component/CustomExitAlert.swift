//
//  CustomExitAlert.swift
//  ParolacciappersProject
//
//  Created by Vincenzo Picone on 18/03/25.
//

import SwiftUI

struct CustomExitAlert: View {
    @ObservedObject var multipeerManager: MultipeerManager
    var title: LocalizedStringResource
    var message: LocalizedStringResource
    @Binding var isPresented: Bool
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            // Effetto ombra per profondità
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black)
                .frame(width: 280, height: 150)
                .offset(x: 5, y: 7)

            VStack(spacing: 12) {
                Text(title)
                    .font(.title3)
                    .bold()
                    .fontDesign(.rounded)
                    .foregroundColor(.black)
                    .padding(.top, 10)

                Text(message)
                    .bold()
                    .fontDesign(.rounded)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)

                Button(action: {
                    
                    
                    isPresented = false
                }) {
                    ActionButton(title: "Keep playing", isDisabled: false)
                }
                .padding(.top, 10)
                
                Button(action: {
                    multipeerManager.resetGame()
                    multipeerManager.disconnect()
                    presentationMode.wrappedValue.dismiss()
                },label: {
                    Text("Leave")
                        .foregroundStyle(.black)
                        .bold()
                        .fontDesign(.rounded)
                        .underline()
                })
                .padding(.bottom, 10)
                
            }
            .frame(width: 350, height: 220)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.black, lineWidth: 3)
            )
        }
    }
}


struct CustomAlertView_Preview: View {
    @State private var showAlert = true
    @StateObject var multipeerManager: MultipeerManager = MultipeerManager(displayName: "Placeholder")
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.2)
                .edgesIgnoringSafeArea(.all)
            
            if showAlert {
                CustomExitAlert(multipeerManager: multipeerManager, title: "Why the #@%! are you leaving?", message: "You won’t partecipate to the game anymore. Are you sure?", isPresented: $showAlert
                )
                
            }
        }
    }
}


#Preview {
    CustomAlertView_Preview()
}
