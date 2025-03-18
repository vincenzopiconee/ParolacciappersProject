//
//  GameOverView.swift
//  ParolacciappersProject
//
//  Created by Martha Mendoza Alfaro on 07/03/25.
//
import SwiftUI
import MultipeerConnectivity

struct GameOverView: View {
    @ObservedObject var multipeerManager: MultipeerManager
    @Environment(\.presentationMode) var presentationMode

    /*var overallWinners: [MCPeerID] {
        multipeerManager.determineOverallWinner()
    }*/
    
     var overallWinners: [(MCPeerID, Int)] {
         multipeerManager.totalWins
             .filter { $0.value > 0 } // Exclude players with 0 wins
             .sorted { $0.value > $1.value } // Sort descending by wins
     }

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Final Results")
                        .font(.title)
                        .bold()
                        .fontDesign(.rounded)
                    
                    Spacer()
                }
                
                if overallWinners.isEmpty {
                    Spacer()
                    Text("No winners")
                        .font(.title)
                        .bold()
                        .fontDesign(.rounded)
                } else {
                    ForEach(overallWinners, id: \.0) { (peer,wins) in
                        
                        HStack {
                            
                            //PHOTO
                            
                            Text("\(peer.displayName)")
                                .font(.title3)
                                .bold()
                                .fontDesign(.rounded)
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            Text("\(wins) pts")
                                .font(.title3)
                                .bold()
                                .fontDesign(.rounded)
                                .foregroundColor(.black)
                        }
                        .padding()
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 3))
                    }
                }

                Spacer()
                
                Button(action: {
                    multipeerManager.resetGame()
                    multipeerManager.disconnect()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    ActionButton(title: "Go back home", isDisabled: false)
                }


            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .background(Image("Background"))
        }
        
    }
}

#Preview {
    GameOverView(multipeerManager: MultipeerManager(displayName: "Placeholder"))
}

