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

    var overallWinners: [MCPeerID] {
        multipeerManager.determineOverallWinner()
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
                    Text("No overall winner")
                        .font(.title)
                        .bold()
                        .fontDesign(.rounded)
                } else {
                    ForEach(overallWinners, id: \.self) { peer in
                        
                        HStack {
                            
                            //PHOTO
                            
                            Text("\(peer.displayName)")
                                .font(.title3)
                                .bold()
                                .fontDesign(.rounded)
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            Text("\(multipeerManager.totalWins[peer] ?? 0)pt")
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
