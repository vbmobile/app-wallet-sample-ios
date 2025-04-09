//
//  WelcomeScreenViewController.swift
//  Demo
//
//  Created by Ricardo Santos on 29/11/2024.
//
import UIKit
import SwiftUI
import WalletSDKCommon
import MobileIdWalletUISDK

open class WelcomeScreenViewController: WUIBaseViewController {
    fileprivate lazy var imageViewLogo: UIImageView = { UIImageView() }()
    fileprivate lazy var btnAccessWallet: UIButton = { UIButton(type: .custom) }()
    fileprivate lazy var btnManagerTrips: UIButton = { UIButton(type: .custom) }()
    fileprivate lazy var btnCreateTrip: UIButton = { UIButton(type: .custom) }()

    let viewModel: WelcomeScreenViewModel?
    var router: MobileIdWalletUIRouterProtocol?
    init(dependencies: WelcomeScreenViewModel.Dependencies?) {
        self.viewModel = .init(dependencies: dependencies)
        self.router = dependencies?.router
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    @MainActor public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func loadView() {
        super.loadView()
        viewModel?.send(.loaded)
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.send(.didAppear)
    }

    override public func prepareLayoutCreateHierarchy() {
        view.addSubview(imageViewLogo)
        view.addSubview(btnAccessWallet)
        view.addSubview(btnManagerTrips)
        view.addSubview(btnCreateTrip)
    }

    override public func prepareLayoutBySettingAutoLayoutsRules() {
        imageViewLogo.layouts.topToSuperview(offset: screenHeight / 5)
        imageViewLogo.layouts.centerXToSuperview()
        imageViewLogo.layouts.height(SizeNames.defaultMargin * 4)

        [btnAccessWallet, btnManagerTrips, btnCreateTrip].forEach { btn in
            btn.layouts.trailingToSuperview(offset: SizeNames.defaultMargin)
            btn.layouts.leadingToSuperview(offset: SizeNames.defaultMargin)
            btn.layouts.height(SizeNames.defaultButtonPrimaryHeight)
        }
        btnAccessWallet.layouts.centerYToSuperview()
        btnManagerTrips.layouts.topToBottom(
            of: btnAccessWallet,
            offset: SizeNames.defaultMargin
        )
        btnCreateTrip.layouts.topToBottom(
            of: btnManagerTrips,
            offset: SizeNames.defaultMargin
        )
    }

    override public func prepareLayoutByFinishingPrepareLayout() {
        btnAccessWallet.setTitle("Access \(WUIStrings.credentialNameSingular.value) Wallet".localizedMissing, for: .normal)
        btnAccessWallet.addTarget(
            self,
            action: #selector(btnAccessWalletTapped),
            for: .touchUpInside
        )
        btnManagerTrips.setTitle("Manage existing \(WUIStrings.tripsNamePlural.value)".localizedMissing, for: .normal)
        btnManagerTrips.addTarget(
            self,
            action: #selector(btnManagerTripsTapped),
            for: .touchUpInside
        )
        btnCreateTrip.setTitle("Create new \(WUIStrings.tripsNameSingular.value)".localizedMissing, for: .normal)
        btnCreateTrip.addTarget(
            self,
            action: #selector(btnCreateTripTapped),
            for: .touchUpInside
        )
        imageViewLogo.contentMode = .scaleAspectFit
        imageViewLogo.image = AppImages.vbLogo.uiImage
    }

    override public func setupColorsAndStyles() {
        view.backgroundColor = ColorSemantic.colorPrimary.uiColor
        [btnAccessWallet, btnManagerTrips].forEach { btn in
            btn.applyStyle(.secondary1)
        }
        [btnCreateTrip].forEach { btn in
            btn.applyStyle(.primary2)
        }
    }

    override public func startObservers() {}

    override public func setupNavigationUIRx() {}
}

// }

//
// MARK: - Actions
//
extension WelcomeScreenViewController {
    // Action to handle button tap
    @objc func btnDeveloperScreenTapped() {
        present(WUIDeveloperScreenViewController(), animated: true)
    }

    // Action to handle button tap
    @objc func btnAccessWalletTapped() {
        viewModel?.send(.pretendsNavigateToWallet(authenticated: !requiresAuthenticationToAccessWallet))
    }

    // Action to handle button tap
    @objc func btnManagerTripsTapped() {
        viewModel?.send(.pretendsNavigateToManageTrips(authenticated: !requiresAuthenticationToAccessWallet,
                                                       shouldCreateNewOnScreenLoad: false))
    }

    // Action to handle button tap
    @objc func btnCreateTripTapped() {
        viewModel?.send(.pretendsCreateNewManageTrip(
            authenticated: !requiresAuthenticationToAccessWallet,
            viewController: self
        ))
    }
}

//
// MARK: - Preview
//

#if canImport(SwiftUI) && DEBUG
struct WUIWelcomeScreenViewControllerPreview: PreviewProvider {
    static var previews: some View {
        ViewControllerRepresentable {
            DependenciesResolver.shared.resolve()
            let dependencies: WelcomeScreenViewModel.Dependencies = .init(
                model: .init(),
                router: nil
            )
            let vc = WelcomeScreenViewController(dependencies: dependencies)
            return vc
        }
    }
}
#endif
