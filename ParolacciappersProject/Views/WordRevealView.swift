//
//  WordRevealView.swift
//  ParolacciappersProject
//
//  Created by Martha Mendoza Alfaro on 07/03/25.
//
import SwiftUI

struct WordRevealView: View {
    @ObservedObject var multipeerManager: MultipeerManager

    var body: some View {
        VStack {
            Text("Selected Word")
                .font(.largeTitle)
                .padding()
            
            Spacer()
            
            Text(multipeerManager.chosenWord ?? "Waiting for word...")
                .font(.title)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding()

            if multipeerManager.isHosting {
                Button("Continue") {
                    //print("🟢 Host clicked Next in Word Reveal")
                    multipeerManager.advanceToNextPhase()
                    
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            
            Spacer()
        }
    }
}

#Preview {
    WordRevealView(multipeerManager: MultipeerManager(displayName: "Placeholder"))
}

