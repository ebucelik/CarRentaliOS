//
//  RentalView.swift
//  CarRentaliOS
//
//  Created by Ing. Ebu Celik, BSc on 21.04.23.
//

import SwiftUI
import ComposableArchitecture

struct RentalView: View {
    let store: StoreOf<RentalCore>

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                rentalBody(viewStore)
                    .onAppear {
                        if case .none = viewStore.rentalState {
                            viewStore.send(.onViewAppear)
                        }

                        if case .error = viewStore.rentalState {
                            viewStore.send(.onViewAppear)
                        }
                    }
                    .navigationTitle("Rentals")
            }
        }
    }

    @ViewBuilder
    private func rentalBody(_ viewStore: ViewStoreOf<RentalCore>) -> some View {
        VStack {
            switch viewStore.rentalState {
            case let .loaded(rentals):
                List {
                    ForEach(rentals, id: \.id) { rental in
                        HStack {
                            Text(rental.startDay)
                            Text(rental.endDay)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .listStyle(.plain)
                .background(Color.white)
                .refreshable {
                    DispatchQueue.main.async {
                        viewStore.send(.onViewAppear)
                    }
                }

            case .none, .loading:
                ProgressView()
                    .progressViewStyle(.circular)

            case .error:
                Text("Error while loading rentals.")
            }
        }
    }
}
