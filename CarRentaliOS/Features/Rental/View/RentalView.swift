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
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }

    @ViewBuilder
    private func rentalBody(_ viewStore: ViewStoreOf<RentalCore>) -> some View {
        VStack {
            switch viewStore.rentalState {
            case let .loaded(rentals):
                List {
                    if rentals.isEmpty {
                        Text("You don't have any rentals.")
                    } else {
                        ForEach(rentals, id: \.id) { rental in
                            VStack(alignment: .leading) {
                                HStack(alignment: .top) {
                                    VStack {
                                        Text("\(rental.carUnwrapped().brand)")
                                            .font(.title2)
                                            .bold()
                                            .frame(maxWidth: .infinity, alignment: .leading)

                                        Text("\(rental.carUnwrapped().model)")
                                            .font(.headline)
                                            .frame(maxWidth: .infinity, alignment: .leading)

                                        Spacer()
                                            .frame(height: 10)

                                        VStack(spacing: 10) {
                                            Text("Startday: \(rental.startDay)")
                                                .font(.caption)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            Text("Endday: \(rental.startDay)")
                                                .font(.caption)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            Text("Total: \(rental.totalCost.toString) \(viewStore.currentCurrency)")
                                                .font(.caption)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        .padding()
                                        .background(AppColor.lightGray)
                                        .cornerRadius(8)
                                    }

                                    AsyncImage(url: URL(string: rental.carUnwrapped().imageLink)) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(maxWidth: 175, maxHeight: 175)
                                    } placeholder: {
                                        Color
                                            .gray
                                            .frame(maxWidth: 175, maxHeight: 175)
                                    }
                                }
                            }
                        }
                        .onDelete { indexSet in
                            delete(at: indexSet, viewStore)
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

    private func delete(at indexSet: IndexSet, _ viewStore: ViewStoreOf<RentalCore>) {
        for index in indexSet {
            viewStore.send(.deleteRental(index))
        }
    }
}
