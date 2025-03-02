//
//  CreateUserView.swift
//  ParolacciappersProject
//
//  Created by Martha Mendoza Alfaro on 03/03/25.
//


import SwiftUI

struct CreateUserView: View {
    var isHost: Bool //determines if it's going to host or browse view
    @State private var name: String = ""
    @State private var nationality: String = ""
    @State private var language: String = ""
    
    @State private var navigateToNextScreen = false
    
    @ObservedObject var multipeerManager: MultipeerManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            VStack {
                //Back Button
                HStack {
                    BackButton()
                    Spacer()
                }
                
                Text("Who the %@#! are you?")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 15)
                
                Spacer()
                
                //User Profile Section
                VStack(spacing: 10) {
                    // Photo Placeholder
                    Button(action: {
                        //Photo selection
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.black, lineWidth: 3)
                                .frame(height: 180)
                            Text("PHOTO")
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                    }
                    
                    //Input Fields
                    VStack(alignment: .leading, spacing: 10) {
                        CustomTextField(title: "Name", text: $name)
                        CustomTextField(title: "Nationality", text: $nationality)
                        CustomTextField(title: "Language", text: $language)
                    }
                    .padding(.horizontal)
                }
                .frame(width: 330)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black, lineWidth: 3)
                )
                
                Spacer()
                
                //Continue Button
                Button(action: {
                    multipeerManager.updateDisplayName(name)  // ✅ Fix: Use function instead of direct assignment

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        if isHost {
                            multipeerManager.startHosting()
                        } else {
                            multipeerManager.startBrowsing()
                        }
                        navigateToNextScreen = true
                    }
                    
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.black)
                            .frame(width: 250, height: 50)
                            .offset(x: 5, y: 7)
                        
                        Text("Continue")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(width: 250, height: 50)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                    }
                }
                .padding(.bottom)
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $navigateToNextScreen) {
                if isHost {
                    HostLobbyView(multipeerManager: multipeerManager)  // ✅ Pass same instance
                } else {
                    JoinLobbyView(multipeerManager: multipeerManager)
                }
            }
        }
    }
}


struct BackButton: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        Button(action: {
            //back action
            presentationMode.wrappedValue.dismiss()
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.black)
                    .frame(width: 50, height: 50)
                    .offset(x: 5, y: 5)
                
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.black, lineWidth: 4)
                    .background(Color.white)
                    .frame(width: 50, height: 50)
                    .cornerRadius(5)
                    .overlay(
                        Image(systemName: "arrowshape.backward")
                            .font(.headline)
                            .foregroundColor(.black)
                    )
            }
        }
    }
}


struct CustomTextField: View {
    var title: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
            
            TextField("", text: $text)
                .padding()
                .background(Color.white)
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.black, lineWidth: 2)
                )
        }
    }
}

#Preview {
    CreateUserView(isHost: true, multipeerManager: MultipeerManager(displayName: "Preview User"))
}

