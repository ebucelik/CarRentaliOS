//
//  RegisterView.swift
//  CarRental
//
//  Created by Ing. Ebu Celik, BSc on 18.03.23.
//

import SwiftUI
import ComposableArchitecture

struct RegisterView: View {

    let store: StoreOf<RegisterCore>

    var body: some View {
        WithViewStore(store) { viewStore in
            registerBody(viewStore)
        }
        .navigationTitle("Sign Up")
    }

    @ViewBuilder
    private func registerBody(_ viewStore: ViewStoreOf<RegisterCore>) -> some View {
        VStack(spacing: 15) {
            SharedTextView(
                systemSymbol: .personFill,
                placeholder: "firstname",
                text: viewStore.binding(\.$customer.firstName)
            )

            SharedTextView(
                systemSymbol: .personFill,
                placeholder: "lastname",
                text: viewStore.binding(\.$customer.lastName)
            )

            SharedTextView(
                systemSymbol: .personFill,
                placeholder: "e-mail",
                text: viewStore.binding(\.$customer.eMail)
            )

            SharedTextView(
                secure: true,
                systemSymbol: .lockFill,
                placeholder: "password",
                text: viewStore.binding(\.$customer.password)
            )

            SharedTextView(
                systemSymbol: .phoneFill,
                placeholder: "phone number",
                text: viewStore.binding(\.$customer.phoneNumber)
            )

            SharedTextView(
                systemSymbol: .calendar,
                placeholder: "date of birth",
                text: viewStore.binding(\.$customer.dateOfBirth)
            )

            Text("You have an account? Sign in.")
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
                .onTapGesture {
                    viewStore.send(.showLogin)
                }

            Spacer()

            switch viewStore.registrationCustomerState {
            case .loaded:
                SharedButton(title: "Sign Up")

            case .loading:
                SharedButton(
                    title: "Sign Up",
                    isLoading: true
                )

            case .none, .error:
                SharedButton(
                    title: "Sign Up",
                    isError: viewStore.isError
                ) {
                    viewStore.send(.register)
                }
            }
        }
        .padding()
    }
}
