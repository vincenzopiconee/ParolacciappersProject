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
            
            Text("Write a sentence using the Word: \(multipeerManager.chosenWord ?? "No Word Selected") in this scenario:")
                .font(.largeTitle)
                .padding()

            Text(multipeerManager.chosenScenario ?? "Selecting a scenario...")
                .font(.title)
                .padding()
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .background(Color.orange.opacity(0.2))
                .cornerRadius(10)

            if multipeerManager.isHosting {
                Button("Start Writing!") {
                    multipeerManager.advanceToNextPhase()
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
        }
    }
}
