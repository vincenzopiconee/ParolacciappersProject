//
//  ContentView.swift
//  ParolacciappersProject
//
//  Created by Vincenzo Picone on 21/02/25.
//

import SwiftUI

struct MainView: View {
    @StateObject var screenManager = ScreenManager()

    var body: some View {
        VStack {
            Text("Controller su iPhone")
                .font(.largeTitle)
                .padding()

            if screenManager.isExternalDisplayConnected {
                Text("TV Connessa ✅")
                    .foregroundColor(.green)
            } else {
                Text("Nessun display esterno")
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            screenManager.checkForExternalScreen()
        }
    }
}

#Preview {
    MainView()
}
