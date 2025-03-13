//
//  CreateUserView.swift
//  ParolacciappersProject
//
//  Created by Martha Mendoza Alfaro on 03/03/25.
//

import SwiftUI
import PhotosUI

struct CreateUserView: View {
    var isHost: Bool //determines if it's going to host or browse view
    @State private var name: String = ""
    @State private var nationality: String = ""
    @State private var language: String = ""
    
    @State private var navigateToNextScreen = false

    @State private var selectedImage: UIImage? // Stores the selected image
    @State private var selectedItem: PhotosPickerItem? // For selecting an image
    @State private var isShowingCamera = false
    
    
    
    @ObservedObject var multipeerManager: MultipeerManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            VStack {
                //Back Button
                HStack {
                    Button(action: {
                        //back action
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        BackButton()
                    }
                    Spacer()
                }
                
                HStack {
                    Text("Who the %@#! are you?")
                        .font(.title)
                        .fontDesign(.rounded)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .padding(.top, 15)
                        .accessibilityLabel("Who the fuck are you?")
                    Spacer()
                }
                Spacer()
                
                //User Profile Section
                VStack(spacing: 10) {
                    if let image = selectedImage {
                        Button(action: {
                            isShowingCamera = true
                        }, label: {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 3))
                        })
                    } else {
                        Button(action: {
                            isShowingCamera = true
                        }, label: {
                            AddPhotoButton()
                        })
                        
                    }
                    
                    //Input Fields
                    VStack(alignment: .leading, spacing: 10) {
                        CustomTextField(title: "Name", text: $name)
                        // commented for TestFligth
                        //CustomTextField(title: "Nationality", text: $nationality)
                        //CustomTextField(title: "Language", text: $language)
                    }
                    .padding()
                }
                .padding()
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black, lineWidth: 3)
                )
                .padding()
                
                Spacer()
                
                //Continue Button
                Button(action: {
                    
        
                    
                    multipeerManager.updateDisplayName(name)

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        if isHost {
                            multipeerManager.startHosting()
                        } else {
                            multipeerManager.startBrowsing()
                        }
                        navigateToNextScreen = true
                    }
                }) {
                    ActionButton(title: "Continue", isDisabled: name.isEmpty)
                }
                .disabled(name.isEmpty) //disable when name is empty
                //.opacity(name.isEmpty ? 0.5 : 1.0) //looks bad but i'll change it eventually
                .padding(.bottom)
                
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $navigateToNextScreen) {
                if isHost {
                    HostLobbyView(multipeerManager: multipeerManager)
                } else {
                    JoinLobbyView(multipeerManager: multipeerManager)
                }
            }
            .onChange(of: selectedItem) {oldItem, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        selectedImage = UIImage(data: data)
                    }
                }
            }
            .fullScreenCover(isPresented: $isShowingCamera) {
                CameraView(image: $selectedImage, isPresented: $isShowingCamera)
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}



#Preview {
    CreateUserView(isHost: true, multipeerManager: MultipeerManager(displayName: "Preview User"))
}

