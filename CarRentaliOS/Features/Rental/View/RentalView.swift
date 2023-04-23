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
                    if rentals.isEmpty {
                        Text("You don't have any rentals.")
                    } else {
                        ForEach(rentals, id: \.id) { rental in
                            HStack(alignment: .top) {
                                Text("CarId: \(rental.carId)")
                                    .font(.headline)
                                    .bold()

                                VStack {
                                    Text("From: \(rental.startDay)")
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                    Text("To: \(rental.endDay)")
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                            }
                            .alert("Cancel \(rental.id)",
                                   isPresented: viewStore.binding(\.$showAlert),
                                   presenting: rental) { rental in
                                Button("Cancel Rental") { viewStore.send(.deleteRental(rental.id)) }
                                Button("Cancel", role: .cancel) { }
                            } message: { rental in
                                Text("Do you really want to cancel your rental with id \(rental.id)?")
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

    private func delete(at offsets: IndexSet, _ viewStore: ViewStoreOf<RentalCore>) {
        viewStore.send(.showAlert)
    }
}
