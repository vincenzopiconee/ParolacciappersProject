import SwiftUI
import MultipeerConnectivity

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
    
    func startGame() {
        DispatchQueue.main.async {
            self.isGameStarted = true
            self.shouldNavigateToGame = true  // Aggiorniamo la variabile in modo che la UI si aggiorni
        }
        
        let message = "startGame"
        if let data = message.data(using: .utf8) {
            try? session.send(data, toPeers: session.connectedPeers, with: .reliable)
            
        }
    }
    
    func disconnect() {
        stopHosting()
        stopBrowsing()
        session.disconnect()
        connectedPeers = []
        shouldNavigateToGame = false
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
                /*
                if !self.isHosting {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.shouldNavigateToGame = true
                    }
                }
                 */
                

            case .notConnected:
                self.connectedPeers.removeAll { $0 == peerID }
                self.messages.append("System: \(peerID.displayName) left the game")
                
            default:
                break
            }
        }
    }


    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let message = String(data: data, encoding: .utf8) {
            DispatchQueue.main.async {
                self.messages.append("\(peerID.displayName): \(message)")
            }
        }
        if let message = String(data: data, encoding: .utf8) {
            DispatchQueue.main.async {
                if message == "startGame" {
                    self.shouldNavigateToGame = true
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
    
    /*func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        DispatchQueue.main.async {
            if let code = info?["code"] {
                self.availableLobbies[peerID] = code
                print("Found lobby: \(peerID.displayName) with code: \(code)")
            } else {
                print("Found peer without code: \(peerID.displayName)")
            }
        }
    }*/
    
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
