import SwiftUI
import MultipeerConnectivity

enum GamePhase: String {
    case wordSubmission
    case wordReveal
    case scenarioReveal
    case sentenceSubmission
    case sentenceReveal
    case definitionReveal
    case voting
    case roundResults
    case gameOver
}

class MultipeerManager: NSObject, ObservableObject {
    private let serviceType = "game-lobby2"
    private var peerID: MCPeerID
    private var session: MCSession
    private var advertiser: MCNearbyServiceAdvertiser
    private var browser: MCNearbyServiceBrowser
    
    @Published var connectedPeers: [MCPeerID] = []
    @Published var availableLobbies: [MCPeerID: String] = [:] // Lobby peerID -> Lobby code
    @Published var messages: [String] = []
    @Published var isHosting = false
    @Published var isBrowsing = false
    @Published var shouldNavigateToGame = false
    @Published var lobbyCode: String = ""
    @Published var displayName: String
    @Published var shuldNavitgateToWaitScreen = false
    @Published var isGameStarted = false
    
    //For the sending of words part 1
    @Published var submittedWords: [MCPeerID: (word: String, definition: String)] = [:]
    //@Published var submittedWords: [MCPeerID: String] = [:]
    @Published var allWordsSubmitted = false
   // @Published var shouldNavigateToWordReveal = false
    
    // For the showing of the chosen word part 1
    @Published var chosenWord: String? // The word selected for the round
    @Published var chosenDefinition: String?
    
    // For the rounds of the game
    @Published var gamePhase: GamePhase = .wordSubmission
    
    //For the chosen scenario
    @Published var chosenScenario: String? // Scenario selected for the round
    
    //For the sending of sentences part 1
    @Published var submittedSentences: [MCPeerID: String] = [:]
    @Published var allSentencesSubmitted = false
    @Published var currentIndex: Int = 0
    
    //for voting and winning
    @Published var votes: [MCPeerID: Int] = [:]  // Tracks votes received per player
    @Published var hasVoted = false  // Prevents multiple votes
    @Published var totalVotes: Int = 0  // Counts Votes
    @Published var winner: [MCPeerID] = []  // Stores the player(s) with the most votes
    @Published var allVotesSubmitted = false
    
    //for final winner
    @Published var totalWins: [MCPeerID: Int] = [:] // Tracks total wins per player

    let scenarios: [String] = [
        "At a doctor's appointment",
        "During a breakup",
        "Eating at a restaurant with your in-laws",
        "Giving a birthday gift to your grandma",
        "Asking a mentor for help with your app"
    ]

    init(displayName: String) {
        self.displayName = displayName
        self.peerID = MCPeerID(displayName: displayName)
        self.session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        self.advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
        self.browser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)

        super.init()
        session.delegate = self
        advertiser.delegate = self
        browser.delegate = self
    }
    
    
    func updateDisplayName(_ name: String) {
        DispatchQueue.main.async {
            self.displayName = name

            //new PeerID with the correct name
            self.peerID = MCPeerID(displayName: name)

            //reset the session with the new peerID
            self.session = MCSession(peer: self.peerID, securityIdentity: nil, encryptionPreference: .required)
            self.advertiser = MCNearbyServiceAdvertiser(peer: self.peerID, discoveryInfo: nil, serviceType: self.serviceType)
            self.browser = MCNearbyServiceBrowser(peer: self.peerID, serviceType: self.serviceType)

            self.session.delegate = self
            self.advertiser.delegate = self
            self.browser.delegate = self

        }
    }
    
    func generateLobbyCode() -> String {
        let letters = "0123456789"
        return String((0..<4).map { _ in letters.randomElement()! })
    }
    
    func startHosting() {
        lobbyCode = generateLobbyCode()
        let discoveryInfo = ["code": lobbyCode]
        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: discoveryInfo, serviceType: serviceType)
        advertiser.delegate = self
        advertiser.startAdvertisingPeer()
        isHosting = true
        print("Hosting started with code: \(lobbyCode)")
    }
    
    func stopHosting() {
        advertiser.stopAdvertisingPeer()
        isHosting = false
        print("Stop host for lobbies...")
    }
    
    func startBrowsing() {
        browser.startBrowsingForPeers()
        isBrowsing = true
        print("Browsing for lobbies...")
    }
    
    func stopBrowsing() {
        browser.stopBrowsingForPeers()
        availableLobbies = [:]
        isBrowsing = false
        print("Stop browse for lobbies...")
    }
    
    func joinLobbyWithCode(_ peerID: MCPeerID, code: String) {
        if let lobbyCode = availableLobbies[peerID], lobbyCode == code {
            invitePeer(peerID)
            DispatchQueue.main.async {
                self.shuldNavitgateToWaitScreen = true
            }
        } else {
            print("Invalid lobby code")
        }
    }
    
    func invitePeer(_ peerID: MCPeerID) {
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
    }
    
    func sendMessage(_ message: String) {
        guard !session.connectedPeers.isEmpty else { return }
        if let data = message.data(using: .utf8) {
            do {
                try session.send(data, toPeers: session.connectedPeers, with: .reliable)
                self.messages.append("Me: \(message)")
            } catch {
                print("Error sending message: \(error.localizedDescription)")
                self.messages.append("System: Failed to send message")
            }
        }
    }
    
    // Send word part 2
    /*func sendWord(_ word: String) {
        guard !session.connectedPeers.isEmpty else { return }
        
        let message = "word:\(word)"
        if let data = message.data(using: .utf8) {
            do {
                try session.send(data, toPeers: session.connectedPeers, with: .reliable)
                submittedWords[peerID] = word  // Store locally
                checkAllWordsSubmitted()
            } catch {
                print("Error sending word: \(error.localizedDescription)")
            }
        }
    }*/
    
    func sendWord(_ word: String, definition: String) {
        guard !session.connectedPeers.isEmpty else { return }
        
        let message = "word:\(word)|\(definition)" // Send both word and definition
        if let data = message.data(using: .utf8) {
            do {
                try session.send(data, toPeers: session.connectedPeers, with: .reliable)
                submittedWords[peerID] = (word, definition) // Store locally
                checkAllWordsSubmitted()
            } catch {
                print("⚠️ Error sending word: \(error.localizedDescription)")
            }
        }
    }


    //Send word part 2 2
    func checkAllWordsSubmitted() {
        DispatchQueue.main.async {
            self.allWordsSubmitted = self.submittedWords.count == self.connectedPeers.count + 1
        }
    }
    
    private func selectRandomWord() {
        if let randomEntry = submittedWords.randomElement() {
            let (peer, (randomWord, definition)) = randomEntry // Get the peer and their word + definition
            chosenWord = randomWord
            chosenDefinition = definition // Store definition

            // Remove the word from the dictionary
            submittedWords.removeValue(forKey: peer)

            // Broadcast the new word and definition
            let message = "chosenWord:\(randomWord)|\(definition)"
            if let data = message.data(using: .utf8) {
                try? session.send(data, toPeers: session.connectedPeers, with: .reliable)
            }

            print("New Word Selected: \(randomWord) with definition: \(definition) (Removed from list)")
        } else {
            print("No words left to select.")
        }
    }

    /*private func selectRandomWord() {
        if let randomEntry = submittedWords.randomElement() {
            let (peer, randomWord) = randomEntry // Get the peer and their word
            chosenWord = randomWord
            
            // Remove the word from the dictionary
            submittedWords.removeValue(forKey: peer)

            // Broadcast the new word
            let message = "chosenWord:\(randomWord)"
            if let data = message.data(using: .utf8) {
                try? session.send(data, toPeers: session.connectedPeers, with: .reliable)
            }

            print("New Word Selected: \(randomWord) (Removed from list)")
        } else {
            print("No words left to select.")
        }
    }*/
    
    
    // Send sentences part 2
    func sendSentence(_ sentence: String) {
        guard !session.connectedPeers.isEmpty else { return }

        let message = "sentence:\(sentence)"
        if let data = message.data(using: .utf8) {
            do {
                try session.send(data, toPeers: session.connectedPeers, with: .reliable)
                submittedSentences[peerID] = sentence // Store locally
                checkAllSentencesSubmitted()
                print(" Sent sentence: \(sentence)")
            } catch {
                print(" Error sending sentence: \(error.localizedDescription)")
            }
        }
    }

    
    func checkAllSentencesSubmitted() {
        DispatchQueue.main.async {
            self.allSentencesSubmitted = self.submittedSentences.count == self.connectedPeers.count + 1
            print("All sentences submitted: \(self.allSentencesSubmitted)")
        }
    }
    
    func broadcastPhraseIndex(_ index: Int) {
        let message = "phraseIndex:\(index)"
        if let data = message.data(using: .utf8) {
            try? session.send(data, toPeers: session.connectedPeers, with: .reliable)
        }
    }

    
    // Vote submission form players
    func submitVote(for peer: MCPeerID) {
        guard !hasVoted else { return } // Prevent multiple votes

        let message = "vote:\(peer.displayName)"
        if let data = message.data(using: .utf8) {
            do {
                try session.send(data, toPeers: session.connectedPeers, with: .reliable)
                
                // Update votes locally, making sure the host is included
                votes[peer, default: 0] += 1
                hasVoted = true
                
                totalVotes += 1
                
                checkAllVotesSubmitted()
                
                print("✅ Voted for: \(peer.displayName), Total votes now: \(votes[peer]!)")
            } catch {
                print("⚠️ Error sending vote: \(error.localizedDescription)")
            }
        }
    }

    
    /*func submitVote(for peer: MCPeerID) {
        guard !hasVoted else { return } // Prevent multiple votes
        
        let message = "vote:\(peer.displayName)"
        if let data = message.data(using: .utf8) {
            do {
                try session.send(data, toPeers: session.connectedPeers, with: .reliable)
                
                // Update votes locally
                votes[peer, default: 0] += 1
                hasVoted = true
                checkAllVotesSubmitted()
                
                print("Voted for: \(peer.displayName), Total votes: \(votes[peer]!)")
            } catch {
                print("Error sending vote: \(error.localizedDescription)")
            }
        }
    }*/
    
    /*func checkAllVotesSubmitted() {
        DispatchQueue.main.async {
            let totalPlayers = self.connectedPeers.count + 1 // Including the host
            let uniqueVoters = Set(self.votes.keys).count // Count of unique people who have voted
            
            print("🔍 Checking votes: \(uniqueVoters) out of \(totalPlayers) players have voted.")
            
            self.allVotesSubmitted = uniqueVoters == totalPlayers
        }
    }*/
    
    func checkAllVotesSubmitted() {
        DispatchQueue.main.async {
            let totalPlayers = self.connectedPeers.count + 1 // Including the host
            let voters = self.totalVotes //self.votes.values.reduce(0) { $0 + $1 } // Count total number of votes cast
            
            self.allVotesSubmitted = voters == totalPlayers
            
            print("🔍 Checking votes: \(voters) out of \(totalPlayers) players have voted. ✅ All Votes Submitted: \(self.allVotesSubmitted)")
        }
    }


    func determineOverallWinner() -> [MCPeerID] {
        let maxWins = totalWins.values.max() ?? 0
        return totalWins.filter { $0.value == maxWins }.map { $0.key }
        
    }
    
    func calculateWinner() {
        let maxVotes = votes.values.max() ?? 0
        winner = votes.filter { $0.value == maxVotes }.map { $0.key } // Handle ties

        // Update total wins for each round winner
        for winPeer in winner {
            totalWins[winPeer, default: 0] += 1
        }

        print("Round Winner(s): \(winner.map { $0.displayName }.joined(separator: ", "))")
        print("Total Wins: \(totalWins.map { "\($0.key.displayName): \($0.value)" }.joined(separator: ", "))")

        // Broadcast winner list to all players
        let winnerNames = winner.map { $0.displayName }.joined(separator: ",")
        let message = "roundWinner:\(winnerNames)"
        if let data = message.data(using: .utf8) {
            try? session.send(data, toPeers: session.connectedPeers, with: .reliable)
        }
        
        // Send total wins to all players
        broadcastTotalWins()

        
    }
    
    func broadcastTotalWins() {
        let winsData = totalWins.map { "\($0.key.displayName):\($0.value)" }.joined(separator: ",")
        let message = "totalWins:\(winsData)"
        
        if let data = message.data(using: .utf8) {
            try? session.send(data, toPeers: session.connectedPeers, with: .reliable)
        }
    }

    // computed property to have the peerID in the dictionary without safety risks
    var myPeerID: MCPeerID {
        return peerID
    }
    
    private func resetRoundData() {
        DispatchQueue.main.async {
            print("🔄 Resetting round data...")
            self.votes = [:]
            self.hasVoted = false
            self.submittedSentences = [:]
            self.allSentencesSubmitted = false
            self.allVotesSubmitted = false
            self.totalVotes = 0
            self.currentIndex = 0
        }
    }
    
    // next phase controller
    func advanceToNextPhase() {
        DispatchQueue.main.async {
            print("🔄 Current phase: \(self.gamePhase.rawValue)")
            
            switch self.gamePhase {
            case .wordSubmission:
                if self.isHosting, self.allWordsSubmitted {
                    self.selectRandomWord()
                    self.gamePhase = .wordReveal
                    self.broadcastPhaseChange()
                }
            case .wordReveal:
                self.selectRandomScenario()
                self.gamePhase = .scenarioReveal
                self.broadcastPhaseChange()
            case .scenarioReveal:
                self.gamePhase = .sentenceSubmission
                self.broadcastPhaseChange()
            case .sentenceSubmission:
                if self.allSentencesSubmitted {
                    //self.gamePhase = .sentenceReveal
                    self.gamePhase = .sentenceReveal
                    self.broadcastPhaseChange()
                }
            case .sentenceReveal: //THE ONE VINCENZO IS WORKING ON
                self.gamePhase = .definitionReveal
                self.broadcastPhaseChange()
            case .definitionReveal:
                self.gamePhase = .voting
                self.broadcastPhaseChange()
            case .voting:
                self.calculateWinner()
                //self.votes = [:]
                //self.hasVoted = false
                self.gamePhase = .roundResults
                self.broadcastPhaseChange()
            case .roundResults:
                if self.submittedWords.isEmpty {
                    print("🏁 No words left. Ending game.")
                    self.gamePhase = .gameOver
                } else {
                    print("🔄 Starting New Round!")
                    self.resetRoundData()
                    self.broadcastRoundReset()
                    self.selectRandomWord()
                    self.selectRandomScenario()
                    self.gamePhase = .wordReveal
                }
                self.broadcastPhaseChange()
            case .gameOver:
                print("Game Over.")
                break // Game is finished
            }
            
            print("➡️ Moving to phase: \(self.gamePhase.rawValue)")
        }
    }

    private func broadcastPhaseChange() {
        let message = "phase:\(gamePhase.rawValue)"
        if let data = message.data(using: .utf8) {
            try? session.send(data, toPeers: session.connectedPeers, with: .reliable)
        }
    }
    
    private func broadcastRoundReset() {
        let message = "resetRound"
        if let data = message.data(using: .utf8) {
            try? session.send(data, toPeers: session.connectedPeers, with: .reliable)
        }
    }

    // random scenario for the round
    private func selectRandomScenario() {
        if let randomScenario = scenarios.randomElement() {
            chosenScenario = randomScenario
            
            let message = "chosenScenario:\(randomScenario)"
            if let data = message.data(using: .utf8) {
                try? session.send(data, toPeers: session.connectedPeers, with: .reliable)
            }
        }
    }

    func startGame() {
        DispatchQueue.main.async {
            self.isGameStarted = true
            self.shouldNavigateToGame = true  // Aggiorniamo la variabile in modo che la UI si aggiorni
            self.gamePhase = .wordSubmission  // Set the initial game phase
            self.broadcastPhaseChange()       // Notify all players
        }
        
        let message = "startGame"
        if let data = message.data(using: .utf8) {
            try? session.send(data, toPeers: session.connectedPeers, with: .reliable)
            
        }
    }
    
    // reset game if you want to start again
    func resetGame() {
        DispatchQueue.main.async {
            self.shuldNavitgateToWaitScreen = false
            self.shouldNavigateToGame = false
            self.submittedWords = [:]
            self.submittedSentences = [:]
            self.allWordsSubmitted = false
            self.allSentencesSubmitted = false
            self.allVotesSubmitted = false
            self.totalVotes = 0
            self.votes = [:]
            self.hasVoted = false
            self.winner = []
            self.totalWins = [:] // Reset total wins
            self.chosenWord = nil
            self.chosenDefinition = nil
            self.chosenScenario = nil
            self.currentIndex = 0
            //self.gamePhase = .wordSubmission // Reset to first phase
            //self.broadcastPhaseChange()
            print("🔄 Game reset!")
        }
    }

    func disconnect() {
        stopHosting()
        stopBrowsing()
        session.disconnect()
        connectedPeers = []
        shouldNavigateToGame = false
        isHosting = false
        isBrowsing = false
        isGameStarted = false
    }
}

extension MultipeerManager: MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async {
            print("Peer \(peerID.displayName) changed state: \(state.rawValue)")

            switch state {
            case .connected:
                if !self.connectedPeers.contains(peerID) {
                    self.connectedPeers.append(peerID) //Adds correct name to the list
                }
                self.availableLobbies.removeValue(forKey: peerID)
                self.messages.append("\(peerID.displayName) joined the game")
            case .notConnected:
                self.connectedPeers.removeAll { $0 == peerID }
                self.messages.append("System: \(peerID.displayName) left the game")
                
            default:
                break
            }
        }
    }
    
    // Sending words part 3
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let message = String(data: data, encoding: .utf8) {
            DispatchQueue.main.async {
                if message == "startGame" {
                    self.shouldNavigateToGame = true
                }
                else if message.starts(with: "word:") {
                    let receivedData = String(message.dropFirst(5)).components(separatedBy: "|")
                    if receivedData.count == 2 {
                        let receivedWord = receivedData[0]
                        let receivedDefinition = receivedData[1]
                        self.submittedWords[peerID] = (receivedWord, receivedDefinition) // Store both word and definition
                        self.checkAllWordsSubmitted()
                        print("📩 Received word: \(receivedWord) with definition: \(receivedDefinition)")
                    }
                }
                else if message.starts(with: "chosenWord:") {
                    let receivedData = String(message.dropFirst(11)).components(separatedBy: "|")
                    if receivedData.count == 2 {
                        self.chosenWord = receivedData[0]
                        self.chosenDefinition = receivedData[1]
                        print("📩 Received chosen word: \(self.chosenWord ?? "") with definition: \(self.chosenDefinition ?? "")")
                    }
                }
                /*else if message.starts(with: "word:") {
                    let word = String(message.dropFirst(5))
                    self.submittedWords[peerID] = word
                    self.checkAllWordsSubmitted()
                } else if message.starts(with: "chosenWord:") {
                    let receivedWord = String(message.dropFirst(11))
                    self.chosenWord = receivedWord
                }*/
                else if message.starts(with: "chosenScenario:") {
                    let receivedScenario = String(message.dropFirst(15))
                    self.chosenScenario = receivedScenario
                }
                else if message.starts(with: "phase:") {
                    let newPhase = String(message.dropFirst(6))
                    if let phase = GamePhase(rawValue: newPhase) {
                        print("🔄 Changing phase to: \(phase.rawValue)") 
                        self.gamePhase = phase
                    }
                }
                else if message.starts(with: "sentence:") {
                    let sentence = String(message.dropFirst(9))
                    DispatchQueue.main.async {
                        self.submittedSentences[peerID] = sentence
                        print("📝 Received new sentence from \(peerID.displayName): \(sentence)")
                        self.checkAllSentencesSubmitted()
                    }
                }
                
                else if message.starts(with: "phraseIndex:") {
                    let indexString = String(message.dropFirst(12))
                    if let newIndex = Int(indexString) {
                        DispatchQueue.main.async {
                            self.currentIndex = newIndex
                            print("🔄 Updated phrase index: \(self.currentIndex)")
                        }
                    }
                }

                else if message.starts(with: "vote:") {
                    print("✅ Vote message detected")
                    let votedPlayerName = String(message.dropFirst(5))
                    DispatchQueue.main.async {
                        if votedPlayerName == self.myPeerID.displayName {
                            self.votes[self.myPeerID, default: 0] += 1  // ✅ Count votes for the host properly
                            self.totalVotes += 1
                            self.checkAllVotesSubmitted()
                            print("🗳️ Vote received for \(votedPlayerName) (HOST), Total votes: \(self.votes[self.myPeerID]!)")
                            return
                        }
                        
                        //search in connectedPeers if its not the host
                        if let votedPeer = self.connectedPeers.first(where: { $0.displayName == votedPlayerName }) {
                            self.votes[votedPeer, default: 0] += 1
                            self.totalVotes += 1
                            self.checkAllVotesSubmitted()
                            print("🗳️ Vote received for \(votedPlayerName), Total votes: \(self.votes[votedPeer]!)")
                        } else {
                            print("❌ Could not find peer with name \(votedPlayerName) in connectedPeers OR as the host.")
                        }                    }
                }
                else if message.starts(with: "winner:") {
                    let winnerNames = String(message.dropFirst(7)).components(separatedBy: ",")
                    DispatchQueue.main.async {
                        self.winner = self.connectedPeers.filter { winnerNames.contains($0.displayName) }
                        print("🎉 Winners updated: \(self.winner.map { $0.displayName }.joined(separator: ", "))")
                    }
                }
                else if message.starts(with: "roundWinner:") {
                    let winnerNames = String(message.dropFirst(12)).components(separatedBy: ",")
                    DispatchQueue.main.async {
                        var winnersFromPeers = self.connectedPeers.filter { winnerNames.contains($0.displayName) }

                        // ✅ Include the player themselves if they are in the winner list
                        if winnerNames.contains(self.myPeerID.displayName) {
                            winnersFromPeers.append(self.myPeerID)
                        }

                        self.winner = winnersFromPeers
                        print("🎉 Round Winners Updated: \(self.winner.map { $0.displayName }.joined(separator: ", "))")
                    }
                }
                else if message.starts(with: "totalWins:") {
                    let receivedData = String(message.dropFirst(10)).components(separatedBy: ",")
                    
                    DispatchQueue.main.async {
                        for entry in receivedData {
                            let parts = entry.components(separatedBy: ":")
                            if parts.count == 2, let wins = Int(parts[1]) {
                                if let peer = self.connectedPeers.first(where: { $0.displayName == parts[0] }) {
                                    self.totalWins[peer] = wins
                                } else if parts[0] == self.myPeerID.displayName {
                                    self.totalWins[self.myPeerID] = wins
                                }
                            }
                        }
                        print("🔄 Updated totalWins: \(self.totalWins.map { "\($0.key.displayName): \($0.value)" }.joined(separator: ", "))")
                    }
                }
                else if message == "resetRound" {
                    DispatchQueue.main.async {
                        print("🔄 Received resetRound message, resetting round data!")
                        self.resetRoundData() // All players reset round data now
                    }
                } else if message == "resetGame" {
                    DispatchQueue.main.async {
                        print("🔄 Resetting game data!")
                        self.resetGame() // All players reset round data now
                    }
                }

            }
        }
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        DispatchQueue.main.async {
            print("Received invitation from \(peerID.displayName), accepting...")
            invitationHandler(true, self.session)
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        DispatchQueue.main.async {
            if let code = info?["code"] {
                self.availableLobbies[peerID] = code
                print("Found lobby: \(peerID.displayName) with code: \(code)")
            } else {
                print("Found peer without code: \(peerID.displayName)")
            }
        }
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            self.availableLobbies.removeValue(forKey: peerID)
            print("Lost lobby: \(peerID.displayName)")
        }
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
}

