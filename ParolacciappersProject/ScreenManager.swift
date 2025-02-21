//
//  ScreenManager.swift
//  ParolacciappersProject
//
//  Created by Vincenzo Picone on 21/02/25.
//

import SwiftUI
import UIKit

class ScreenManager: ObservableObject {
    @Published var isExternalDisplayConnected: Bool = false
    private var externalWindow: UIWindow?

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateScreenStatus), name: UIApplication.didBecomeActiveNotification, object: nil)
        checkForExternalScreen()
    }

    @objc private func updateScreenStatus() {
        checkForExternalScreen()
    }

    func checkForExternalScreen() {
        let externalScenes = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .filter { $0.activationState == .foregroundActive }
            .filter { $0.screen != UIScreen.main }

        if let externalScene = externalScenes.first {
            setupExternalScreen(for: externalScene)
        } else {
            closeExternalScreen()
        }
    }

    private func setupExternalScreen(for scene: UIWindowScene) {
        if externalWindow == nil {
            let newWindow = UIWindow(windowScene: scene)
            newWindow.rootViewController = UIHostingController(rootView: ExternalScreenView())
            newWindow.isHidden = false
            externalWindow = newWindow
        }
        isExternalDisplayConnected = true
    }

    private func closeExternalScreen() {
        externalWindow?.isHidden = true
        externalWindow = nil
        isExternalDisplayConnected = false
    }
}

