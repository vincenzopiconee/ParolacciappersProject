//
//  ScenarioRevealView.swift
//  ParolacciappersProject
//
//  Created by Martha Mendoza Alfaro on 07/03/25.
//


import SwiftUI

struct ScenarioRevealView: View {
    @ObservedObject var multipeerManager: MultipeerManager

    var body: some View {
        VStack {
            
            HStack {
                Text("Write a sentence using the word \"\(multipeerManager.chosenWord ?? "no word selected")\" in this scenario:")
                    .font(.title)
                    .bold()
                    .padding()

                Spacer()
            }
            
            Spacer()

            Text(multipeerManager.chosenScenario ?? "Selecting a scenario...")
                .font(.title)
                .padding()
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding()
            
            Spacer()
            
            if multipeerManager.isHosting {
                Button("Start Writing!") {
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
    ScenarioRevealView(multipeerManager: MultipeerManager(displayName: "Placeholder"))
}
