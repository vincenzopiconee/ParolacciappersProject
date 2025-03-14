//
//  CreateUserView.swift
//  ParolacciappersProject
//
//  Created by Martha Mendoza Alfaro on 03/03/25.
//

import SwiftUI
import UIKit

extension Color {
    init(hex: String) {
        let hexString = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
        
        let scanner = Scanner(string: hexString)
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

struct CreateUserView: View {
    var isHost: Bool //determines if it's going to host or browse view
    @State private var name: String = ""
    @State private var nationality: String = ""
    @State private var language: String = ""
    
    @State private var navigateToNextScreen = false
    
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    @State private var imagesFromGallery: [UIImage] = []
    
    let countries: [String] = Locale.Region.isoRegions.compactMap { Locale.current.localizedString(forRegionCode: $0.identifier) }
    
    let languages: [String] = Locale.LanguageCode.isoLanguageCodes.compactMap { Locale.current.localizedString(forLanguageCode: $0.identifier) }
    
    @ObservedObject var multipeerManager: MultipeerManager
    @Environment(\.presentationMode) var presentationMode
    
    struct ImagePicker: UIViewControllerRepresentable {
        var sourceType: UIImagePickerController.SourceType
        @Binding var selectedImage: UIImage?
        @Binding var imagesFromGallery: [UIImage]
        @Binding var isImagePickerPresented: Bool
        var onImagePicked: (UIImage) -> Void
        
        class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
            var parent: ImagePicker
            
            init(parent: ImagePicker) {
                self.parent = parent
            }
            
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                if let image = info[.originalImage] as? UIImage {
                    if parent.sourceType == .camera {
                        parent.selectedImage = image
                        parent.onImagePicked(image)
                    } else if parent.sourceType == .photoLibrary {
                        parent.imagesFromGallery.append(image)
                    }
                }
                parent.isImagePickerPresented = false
            }
            
            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                parent.isImagePickerPresented = false
            }
        }
        
        func makeCoordinator() -> Coordinator {
            return Coordinator(parent: self)
        }
        
        func makeUIViewController(context: Context) -> UIImagePickerController {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = sourceType
            imagePicker.delegate = context.coordinator
            imagePicker.allowsEditing = false
            return imagePicker
        }
        
        func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background image
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
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
                    
                    Text("Who the %@#! are you?!")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .padding(.top, 30)
                        .accessibilityLabel("Who the fuck are you?!")
                    
                    Spacer()
                    
                    //User Profile Section
                    VStack {
                        Button(action: {
                            //Photo selection
                            sourceType = .camera
                            isImagePickerPresented = true
                        }){
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.black, lineWidth: 3)
                                    .fill(Color.white)
                                    .frame(width: 180, height: 170)
                                if let image = selectedImage {
                                    // Show the photo if it exists
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 180, height: 170)
                                        .clipped()
                                        .cornerRadius(12)
                                    //.background(Color.white)
                                    
                                } else {
                                    // Show the default text if no photo is taken
                                    Text("Add Photo")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                        .padding(.top, 15)
                        
                        //Name
                        VStack(alignment: .leading, spacing: 10) {
                            CustomTextField(title: "Name", text: $name)
                                .padding(.bottom, 10)

                            // Language
                            VStack(alignment: .leading) {
                                Text("Language")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                
                                Menu {
                                    ForEach(languages, id: \.self) { lang in
                                        Button(action: {
                                            language = lang
                                        }) {
                                            Text(lang)
                                        }
                                    }
                                } label: {
                                    Text(language.isEmpty ? "Select your language" : language)
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color.white)
                                        .foregroundColor(Color.black)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.black, lineWidth: 2))
                                }
                            }
                            .padding(.bottom, 15)
                        }
                    }
                    .padding()
                    .background(Color(hex: "#A3E636"))
                    .cornerRadius(12)
                    .frame(maxWidth: .infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black, lineWidth: 3)
                    )
                    
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
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.black)
                                .frame(width: 250, height: 50)
                                .offset(x: 5, y: 7)
                            
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(hex: "#BAE575"))
                                .frame(width: 250, height: 50)
                            
                            Text("Continue")
                                .font(.headline)
                                .foregroundColor(.black)
                                .frame(width: 250, height: 50)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.black, lineWidth: 3))
                        }
                    }
                    .disabled(name.isEmpty) //disable when name is empty
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
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePicker(sourceType: sourceType, selectedImage: $selectedImage, imagesFromGallery: $imagesFromGallery, isImagePickerPresented: $isImagePickerPresented) { image in
                        selectedImage = image
                    }
                }
            }
        }
    }
}

#Preview {
    CreateUserView(isHost: true, multipeerManager: MultipeerManager(displayName: "Preview User"))
}

