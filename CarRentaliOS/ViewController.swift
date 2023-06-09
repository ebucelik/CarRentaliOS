//
//  ViewController.swift
//  CarRentaliOS
//
//  Created by Ing. Ebu Celik, BSc on 03.04.23.
//

import UIKit
import SwiftUI
import ComposableArchitecture

class ViewController: UIViewController {

    let appView = UIHostingController(
        rootView: AppView(
            store: Store(
                initialState: AppCore.State(
                    homeState: HomeCore.State(),
                    entryState: EntryCore.State(
                        loginState: LoginCore.State(
                            customer: .emptyLoginCustomer
                        )
                    )
                ),
                reducer: AppCore()
            )
        )
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear

        setupSubViews()
        setupConstraints()
    }

    private func setupSubViews() {
        appView.view.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(appView.view)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                appView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                appView.view.topAnchor.constraint(equalTo: view.topAnchor),
                appView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                appView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]
        )
    }
}

