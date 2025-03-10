//
//  SentenceSubmissionView.swift
//  ParolacciappersProject
//
//  Created by Martha Mendoza Alfaro on 07/03/25.
//


import SwiftUI

struct SentenceSubmissionView: View {
    @ObservedObject var multipeerManager: MultipeerManager
    @State private var message = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack {
                Text("Write a Sentence Using:")
                    .font(.title)
                    .padding()

                Spacer()
            }

            // Display the word and scenario
            VStack(spacing: 15) {
                Text("Word: \(multipeerManager.chosenWord ?? "No Word Selected")")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)

                Text("Scenario: \(multipeerManager.chosenScenario ?? "No Scenario Selected")")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange.opacity(0.2))
                    .cornerRadius(10)
            }
            .padding(.horizontal)

            // Input field for submitting the sentence
            if multipeerManager.submittedSentences[multipeerManager.myPeerID] == nil {
                TextField("Type your sentence...", text: $message)
                    .textFieldStyle(.roundedBorder)
                    .padding()

                Button("Submit") {
                    if !message.isEmpty {
                        multipeerManager.sendSentence(message)
                        message = ""
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(message.isEmpty)
            } else if !multipeerManager.allSentencesSubmitted {
                Text("Waiting for other players to submit their sentences...")
            } else if multipeerManager.isHosting {
                Button("Next") {
                    print("🎭 Moving to Sentence Reveal phase")
                    multipeerManager.advanceToNextPhase()
                }
                .buttonStyle(.borderedProminent)
                .disabled(!multipeerManager.allSentencesSubmitted)
            }

            Spacer()

            Button("Leave Game") {
                multipeerManager.disconnect()
                presentationMode.wrappedValue.dismiss()
            }
            .buttonStyle(.bordered)
            .padding(.bottom)
        }
        .navigationBarBackButtonHidden(true)
    }
}


#Preview {
    SentenceSubmissionView(multipeerManager: MultipeerManager(displayName: "Placeholder")
    )
}
