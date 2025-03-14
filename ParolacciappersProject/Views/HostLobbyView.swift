//
//  CreateUserView.swift
//  ParolacciappersProject
//
//  Created by Frida Perez Perfecto on 13/03/25.
//

import SwiftUI
import MultipeerConnectivity

struct HostLobbyView: View {
    @ObservedObject var multipeerManager: MultipeerManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            ZStack {
                // background
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        Button(action: {
                            //back action
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            BackButton()
                        }
                        Spacer()
                    }
                    
                    Text("Hosting a %@#! Lobby")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .padding(.top, 15)
                        .padding(.bottom, 20)
                        .foregroundColor(.black)
                    
                    VStack(spacing: 20) {
                        infoBox(title: "Your Device:", content: multipeerManager.displayName)
                            .padding(.bottom, 10)

                        
                        infoBox(title: "Lobby Code:", content: multipeerManager.lobbyCode)
                            .padding(.bottom, 10)

                        VStack(alignment: .leading) {
                            Text("Connected players (\(multipeerManager.connectedPeers.count)):")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            List {
                                ForEach(multipeerManager.connectedPeers, id: \.self) { peer in
                                    Text(peer.displayName)
                                        .foregroundColor(.black)
                                }
                            }
                            .cornerRadius(12)
                            .frame(maxWidth: .infinity)

                        }
                        .padding()
                        .background(Color(hex: "#A3E636"))
                        .cornerRadius(12)
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.black, lineWidth: 3)
                        )
                    }

                    Spacer()
                    
                    HStack {
                        Button("Cancel") {
                            multipeerManager.stopHosting()
                            presentationMode.wrappedValue.dismiss()
                        }
                        .buttonStyle(.bordered)
                        .padding()
                        .foregroundColor(.black)
                        
                        Spacer()
                        
                        Button("Start Game") {
                            multipeerManager.startGame()
                        }
                        .bold()
                        .buttonStyle(.bordered)
                        .padding()
                        .disabled(multipeerManager.connectedPeers.isEmpty)
                        .foregroundColor(.black)
                    }
                }
                .padding()
                .navigationBarBackButtonHidden(true)
                .navigationDestination(isPresented: $multipeerManager.shouldNavigateToGame) {
                    GameView(multipeerManager: multipeerManager)
                }
            }
        }
    }
    
    private func infoBox(title: String, content: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            
            Text(content)
                .font(.subheadline)
                .foregroundColor(.black)
                .padding(.top, 5)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(hex: "#A3E636"))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.black, lineWidth: 3)
        )
    }
    
    private func customButton(title: String, action: @escaping () -> Void) -> some View {
            Button(action: action) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black)
                        .frame(width: 250, height: 50)
                        .offset(x: 5, y: 7) // Sombra desplazada
                    
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: "#BAE575"))
                        .frame(width: 250, height: 50)
                    
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(width: 250, height: 50)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.black, lineWidth: 3)
                        )
                }
            }
        }
    }

#Preview {
    HostLobbyView(multipeerManager: MultipeerManager(displayName: "Placeholder"))
}

