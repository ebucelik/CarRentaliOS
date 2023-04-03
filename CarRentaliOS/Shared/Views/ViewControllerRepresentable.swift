//
//  ViewControllerRepresentable.swift
//  CarRentaliOS
//
//  Created by Ing. Ebu Celik, BSc on 03.04.23.
//

import SwiftUI

struct ViewControllerRepresentable: UIViewControllerRepresentable {

    let viewController: UIViewController

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
