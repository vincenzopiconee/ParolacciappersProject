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

            Text(multipeerManager.chosenWord ?? "Waiting for word...")
                .font(.title)
                .padding()
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)

            if multipeerManager.isHosting {
                Button("Next Round") {
                    multipeerManager.advanceToNextPhase()
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
        }
    }
}

/*
struct WordRevealView: View {
    @ObservedObject var multipeerManager: MultipeerManager
    @State private var selectedWord: String = "Waiting for words..."
    
    var body: some View {
        VStack {
            Text("Selected Word")
                .font(.largeTitle)
                .padding()
            
            Text(selectedWord)
                .font(.title)
                .padding()
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            if multipeerManager.isHosting {
                Button("Next Round") {
                    multipeerManager.advanceToNextScreen()
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
        }
        .onAppear {
            selectRandomWord()
        }
    }
    
    private func selectRandomWord() {
        let words = Array(multipeerManager.submittedWords.values)
        if let randomWord = words.randomElement() {
            selectedWord = randomWord
        }
    }
}
*/
