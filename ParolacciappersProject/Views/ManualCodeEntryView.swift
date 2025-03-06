//
//  ManualCodeEntryView.swift
//  ParolacciappersProject
//
//  Created by Vincenzo Picone on 06/03/25.
//

import SwiftUI

struct ManualCodeEntryView: View {
    @Binding var enteredCode: String
    @FocusState private var isTextFieldFocused: Bool //Focus control*

    var body: some View {
        VStack {
            // Hidden text field for input
            TextField("", text: $enteredCode)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode) //Helps with auto-fill
                .focused($isTextFieldFocused) //Binds focus state
                .onChange(of: enteredCode) { oldValue, newValue in
                    enteredCode = String(newValue.prefix(4)) // Limit to 4 digits
                }
                .frame(width: 1, height: 1)
                .opacity(0.01) //Nearly invisible but still interactive
                .padding(.bottom, -20) // Ensures no UI interference
            
            // Tapable code entry UI
            HStack(spacing: 10) {
                ForEach(0..<4, id: \.self) { index in
                    Text(getDigit(at: index))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(width: 60, height: 80)
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.black, lineWidth: 3)
                        )
                }
            }
            .contentShape(Rectangle()) //Expands tap area
            .onTapGesture {
                isTextFieldFocused = true //Open keyboard when tapped
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isTextFieldFocused = true //Ensure it gets focus when view appears
                }
            }
        }
    }

    //Helper function to get digit at index or placeholder
    private func getDigit(at index: Int) -> String {
        if index < enteredCode.count {
            return String(enteredCode[enteredCode.index(enteredCode.startIndex, offsetBy: index)])
        }
        return "-"
    }
}

#Preview {
    @Previewable @State var text = ""
    ManualCodeEntryView(enteredCode: $text)
}
