import SwiftUI



import SwiftUI

struct GameView: View {
    @ObservedObject var multipeerManager: MultipeerManager

    var body: some View {
        VStack {
            switch multipeerManager.gamePhase {
            case .wordSubmission:
                WordSubmissionView(multipeerManager: multipeerManager)
            case .wordReveal:
                WordRevealView(multipeerManager: multipeerManager)
            case .scenarioReveal:
                ScenarioRevealView(multipeerManager: multipeerManager)
            case .sentenceSubmission:
                SentenceSubmissionView(multipeerManager: multipeerManager)
                //ScenarioRevealView(multipeerManager: multipeerManager)
            case .sentenceReveal:
                //SentenceRevealView(multipeerManager: multipeerManager)
                ScenarioRevealView(multipeerManager: multipeerManager)
            case .voting:
                VotingView(multipeerManager: multipeerManager)
                //ScenarioRevealView(multipeerManager: multipeerManager)
            case .roundResults:
                RoundResultsView(multipeerManager: multipeerManager)
                //ScenarioRevealView(multipeerManager: multipeerManager)
            case .gameOver:
                GameOverView(multipeerManager: multipeerManager)
                //ScenarioRevealView(multipeerManager: multipeerManager)
            }
        }
        .animation(.easeInOut, value: multipeerManager.gamePhase) // Smooth transition between screens
    }
}




struct WordSubmissionView: View {
    @ObservedObject var multipeerManager: MultipeerManager
    @State private var message = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Game Session")
                        .font(.title)
                        .padding()
                    
                    Spacer()
                    
                    Text("Connected: \(multipeerManager.connectedPeers.count)")
                        .foregroundColor(multipeerManager.connectedPeers.isEmpty ? .red : .green)
                        .padding(.trailing)
                }
                
  
                if multipeerManager.submittedWords[multipeerManager.myPeerID] == nil {
                    TextField("Enter your word", text: $message)
                        .textFieldStyle(.roundedBorder)
                    
                    Button("Submit") {
                        if !message.isEmpty {
                            multipeerManager.sendWord(message)
                            message = ""
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(message.isEmpty)
                } else if !multipeerManager.allWordsSubmitted {
                    Text("Waiting for other players to send their words...")
                } else if multipeerManager.isHosting {
                    Button("Next") {
                        multipeerManager.advanceToNextPhase()
                        //multipeerManager.advanceToNextScreen()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!multipeerManager.allWordsSubmitted)
                }
                
                /*List {
                    ForEach(multipeerManager.messages, id: \.self) { msg in
                        Text(msg)
                            .padding(4)
                    }
                }
                
                HStack {
                    TextField("Type a message", text: $message)
                        .textFieldStyle(.roundedBorder)
                        .disabled(multipeerManager.connectedPeers.isEmpty)
                    
                    Button("Send") {
                        if !message.isEmpty {
                            multipeerManager.sendMessage(message)
                            message = ""
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(message.isEmpty || multipeerManager.connectedPeers.isEmpty)
                }
                .padding()
                 
                */
                
                Button("Leave Game") {
                    multipeerManager.disconnect()
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(.bordered)
                .padding(.bottom)
            }
            .navigationBarBackButtonHidden(true)
            /*.navigationDestination(isPresented: $multipeerManager.shouldNavigateToWordReveal) {
                    WordRevealView(multipeerManager: multipeerManager)
                }*/
            /*.navigationDestination(isPresented: Binding(
                get: { multipeerManager.gamePhase == .wordReveal },
                set: { _ in })) {
                    WordRevealView(multipeerManager: multipeerManager)
                }*/
        }
        
    }
}

#Preview {
    GameView(multipeerManager: MultipeerManager(displayName: "Placeholder"))
}
