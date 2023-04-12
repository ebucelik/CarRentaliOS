//
//  LoginView.swift
//  CarRental
//
//  Created by Ing. Ebu Celik, BSc on 18.03.23.
//

import SwiftUI
import ComposableArchitecture

struct LoginView: View {

    let store: StoreOf<LoginCore>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: 15) {
                SharedTextView(
                    systemSymbol: .personFill,
                    placeholder: "e-mail",
                    text: viewStore.binding(\.$customer.email)
                )

                SharedTextView(
                    secure: true,
                    systemSymbol: .lockFill,
                    placeholder: "password",
                    text: viewStore.binding(\.$customer.password)
                )

                Text("You don't have an account? Sign up now.")
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onTapGesture {
                        viewStore.send(.showRegister)
                    }

                Spacer()

                switch viewStore.tokenState {
                case .loaded:
                    SharedButton(title: "Sign In")

                case .loading:
                    SharedButton(
                        title: "Sign In",
                        isLoading: true
                    )

                case .none, .error:
                    SharedButton(
                        title: "Sign In",
                        isError: viewStore.isError
                    ) {
                        viewStore.send(.login)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Sign In")
    }
}
