//
//  ManualCodeEntryView.swift
//  ParolacciappersProject
//
//  Created by Vincenzo Picone on 06/03/25.
//

import SwiftUI

struct ManualCodeEntryView: View {
    @Binding var enteredCode: String
    @FocusState private var isTextFieldFocused: Bool // Focus control

    var body: some View {
        VStack {
            // Hidden text field for input
            TextField("", text: $enteredCode)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode) // Helps with auto-fill
                .focused($isTextFieldFocused) // Focus binding
                .onChange(of: enteredCode) { oldValue, newValue in
                    enteredCode = String(newValue.prefix(4)) // Limit to 4 digits
                }
                .frame(width: 1, height: 1)
                .opacity(0.01) // Nearly invisible but still interactive
                .padding(.bottom, -20) // Prevents UI interference
                .accessibilityHidden(true) // Hide from VoiceOver
                .foregroundColor(.black)

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
                        .accessibilityHidden(true) // Prevents VoiceOver from reading each digit separately
                        .foregroundColor(.black)
                }
            }
            .contentShape(Rectangle()) // Expands tap area
            .onTapGesture {
                isTextFieldFocused = true // Open keyboard when tapped
                UIAccessibility.post(notification: .announcement, argument: "Keyboard is open")
            }
            .accessibilityElement(children: .ignore) // Ignore individual elements for accessibility
            .accessibilityLabel("4-digit Code. Tap to open keyboard.")
            .accessibilityValue(enteredCode.isEmpty ? "No code entered" : enteredCode)
            .accessibilityAddTraits(.isKeyboardKey) // Indicates an interactive text field
            
            /*
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isTextFieldFocused = true // Ensure focus when view appears
                    UIAccessibility.post(notification: .announcement, argument: "Keyboard is open")
                }
            }
             */
        }
    }

    // Helper function to get digit at index or placeholder
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


