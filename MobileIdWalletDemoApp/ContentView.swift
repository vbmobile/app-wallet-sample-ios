//
//  ContentView.swift
//  MobileIdWalletDemoApp
//
//  Created by Ricardo DOS SANTOS on 03/04/2025.
//

import SwiftUI
import MobileIdWalletUISDK

let apiKey = "apiKey"
let baseURL = "baseURL"
let databaseID = "databaseID"
let serverHost = "serverHost"
let requiresAuthenticationToAccessWallet = false

let walletUIRouter: MobileIdWalletUIRouterProtocol = MobileIdWalletUIRouter()
let initialViewController = WelcomeScreenViewController(
    dependencies: .init(
        model: .init(),
        router: walletUIRouter
    )
)

struct ContentView: View {

    init() {
        WUIDependenciesResolver.shared.resolve(
            apiKey: apiKey,
            baseURL: baseURL,
            databaseID: databaseID,
            serverHost: serverHost
        )
    }

    var body: some View {
        EmptyView()
        .onAppear {
            DispatchQueue.main.async {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let rootViewController = windowScene.windows.first?.rootViewController {
                        let navigationController = UINavigationController(rootViewController: initialViewController)
                        navigationController.modalPresentationStyle = .fullScreen
                        walletUIRouter.setup(rootViewController: navigationController)
                        rootViewController.present(navigationController, animated: true, completion: nil)
                }
            }
        }
    }
}

