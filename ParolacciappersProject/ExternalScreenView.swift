//
//  ExternalScreenView.swift
//  ParolacciappersProject
//
//  Created by Vincenzo Picone on 21/02/25.
//

import SwiftUI

struct ExternalScreenView: View {
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            Text("Gioco sulla TV!")
                .font(.largeTitle)
                .foregroundColor(.white)
        }
    }
}
#Preview {
    ExternalScreenView()
}
