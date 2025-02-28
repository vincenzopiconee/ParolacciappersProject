import SwiftUI

struct GameView: View {
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
                
                List {
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
                
                Button("Leave Game") {
                    multipeerManager.disconnect()
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(.bordered)
                .padding(.bottom)
            }
            .navigationBarBackButtonHidden(true)
            .onDisappear {
                if !multipeerManager.shouldNavigateToGame {
                    multipeerManager.disconnect()
                }
            }
        }
        
    }
}

#Preview {
    GameView(multipeerManager: MultipeerManager())
}
