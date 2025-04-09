//
//  WelcomeScreenViewModel.swift
//  DemoApp
//
//  Created by Ricardo Santos on 18/12/2024.
//

import Foundation
import MobileIdWalletSDK
import MobileIdWalletUISDK
import WalletSDKCore
import WalletSDKCommon
import SwiftUI

struct WelcomeScreenModel {}

extension WelcomeScreenViewModel {
    enum Actions {
        case loaded
        case didAppear
        case pretendsNavigateToWallet(authenticated: Bool)
        case pretendsNavigateToManageTrips(authenticated: Bool, shouldCreateNewOnScreenLoad: Bool)
        case pretendsCreateNewManageTrip(authenticated: Bool, viewController: UIViewController)
    }

    struct Dependencies {
        let model: WelcomeScreenModel?
        let router: MobileIdWalletUIRouterProtocol?
        public init(model: WelcomeScreenModel? = nil, router: MobileIdWalletUIRouterProtocol?) {
            self.model = model
            self.router = router
        }
    }
}

class WelcomeScreenViewModel {
    private var cancelBag = CancelBag()
    private let router: MobileIdWalletUIRouterProtocol?
    public init(dependencies: Dependencies?) {
        self.router = dependencies?.router
    }

    func send(_ action: Actions) {
        switch action {
        case .loaded:
            ()
        case .didAppear:
            ()
        case .pretendsNavigateToWallet(authenticated: let authenticated):
            if authenticated {
                router?.navigateToVerifiableCredentials(model: nil)
            } else {
                Task {
                    do {
                        let authenticateUser = try await AuthenticationManager.shared.authenticateUser()
                        if authenticateUser {
                            send(.pretendsNavigateToWallet(authenticated: true))
                        }
                    } catch {
                        LogsManager.error("Error authenticating user: \(error)", "\(Self.self)")
                    }
                }
            }
        case .pretendsNavigateToManageTrips(
            authenticated: let authenticated,
            shouldCreateNewOnScreenLoad: let shouldCreateNewOnScreenLoad
        ):
            if authenticated {
                router?.navigateToFlights(model: .init(shouldCreateNewOnScreenLoad: shouldCreateNewOnScreenLoad))
            } else {
                Task {
                    do {
                        let authenticateUser = try await AuthenticationManager.shared.authenticateUser()
                        if authenticateUser {
                            send(.pretendsNavigateToManageTrips(
                                authenticated: true,
                                shouldCreateNewOnScreenLoad: shouldCreateNewOnScreenLoad
                            ))
                        }
                    } catch {
                        LogsManager.error("Error authenticating user: \(error)", "\(Self.self)")
                    }
                }
            }
        case .pretendsCreateNewManageTrip(authenticated: let authenticated, viewController: _):
            send(.pretendsNavigateToManageTrips(
                authenticated: authenticated,
                shouldCreateNewOnScreenLoad: true
            ))
        }
    }
}
