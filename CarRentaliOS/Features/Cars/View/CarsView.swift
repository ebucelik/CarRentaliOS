//
//  CarsView.swift
//  CarRentaliOS
//
//  Created by Ing. Ebu Celik, BSc on 14.04.23.
//

import SwiftUI
import ComposableArchitecture

struct CarsView: View {

    let store: StoreOf<CarsCore>

    init(store: StoreOf<CarsCore>) {
        self.store = store
    }

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                VStack {
                    switch viewStore.carsState {
                    case let .loaded(cars):
                        VStack {
                            carsHeader(viewStore)

                            Divider()

                            carsBody(viewStore, cars: cars)
                        }

                    case .none, .loading:
                        ProgressView()
                            .progressViewStyle(.circular)

                    case .error:
                        Text("Error while loading cars.")
                    }
                }
                .onAppear {
                    if case .none = viewStore.carsState {
                        viewStore.send(.onViewAppear)
                    }

                    if case .error = viewStore.carsState {
                        viewStore.send(.onViewAppear)
                    }
                }
                .navigationTitle("Cars")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Picker(
                            "Currency",
                            selection: viewStore.binding(\.$selectedCurrency)
                        ) {
                            ForEach(viewStore.mockedCurrencies, id: \.self) { currencyCode in
                                Text(currencyCode)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
                .onChange(of: viewStore.selectedCurrency) { _ in
                    viewStore.send(.onViewAppear)
                }
                .onChange(of: viewStore.startDate) { _ in
                    viewStore.send(.onViewAppear)
                }
                .onChange(of: viewStore.endDate) { _ in
                    viewStore.send(.onViewAppear)
                }
            }
        }
    }

    @ViewBuilder
    private func carsHeader(_ viewStore: ViewStoreOf<CarsCore>) -> some View {
        HStack {
            Spacer()

            DatePicker(
                "From:",
                selection: viewStore.binding(\.$startDate),
                displayedComponents: .date
            )

            DatePicker(
                "To:",
                selection: viewStore.binding(\.$endDate),
                displayedComponents: .date
            )

            Spacer()
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private func carsBody(_ viewStore: ViewStoreOf<CarsCore>, cars: [Car]) -> some View {
        List {
            ForEach(cars, id: \.id) { car in
                HStack {
                    AsyncImage(url: URL(string: car.imageLink)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 125, maxHeight: 125)
                    } placeholder: {
                        Color
                            .gray
                            .frame(maxWidth: 125, maxHeight: 125)
                    }

                    VStack(alignment: .leading) {
                        Text(car.model)
                            .font(.title2)
                            .bold()

                        Text(car.brand)
                            .font(.headline)

                        Spacer()

                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(car.fuelType)")
                                    .font(.caption)

                                Text("\(car.hp) hp")
                                    .font(.caption)

                                Text("\(car.buildDate)")
                                    .font(.caption)
                            }

                            Spacer()

                            VStack(alignment: .trailing, spacing: 1) {
                                Text("\(car.dailyCostString)")
                                    .font(.largeTitle)
                                    .bold()

                                Text("per day")
                                    .font(.caption)
                            }
                        }
                    }
                }
                .padding(.vertical)
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
    }
}
