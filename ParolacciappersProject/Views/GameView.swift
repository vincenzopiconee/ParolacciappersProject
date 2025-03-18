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
            case .definitionReveal:
                DefinitionRevealView(multipeerManager: multipeerManager)
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


#Preview {
    GameView(multipeerManager: MultipeerManager(displayName: "Placeholder"))
}
