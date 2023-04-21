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

                    viewStore.send(.resetCarDetailState)
                }
                .navigationTitle("Available Cars")
                .navigationBarTitleDisplayMode(.inline)
                .onChange(of: viewStore.currentCurrency) { _ in
                    viewStore.send(.loadCars)
                }
                .onChange(of: viewStore.chosenCurrency) { _ in
                    viewStore.send(.loadCars)
                    viewStore.send(.currencyCodeChosen)
                }
                .onChange(of: viewStore.startDate) { _ in
                    viewStore.send(.loadCars)
                }
                .onChange(of: viewStore.endDate) { _ in
                    viewStore.send(.loadCars)
                }
                .onChange(of: viewStore.needsRefresh) { needsRefresh in
                    if needsRefresh {
                        viewStore.send(.onViewAppear)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func carsHeader(_ viewStore: ViewStoreOf<CarsCore>) -> some View {
        HStack {
            VStack(alignment: .leading) {
                DatePicker(
                    "Start:",
                    selection: viewStore.binding(\.$startDate),
                    displayedComponents: .date
                )
                .frame(maxWidth: 150)
                .clipped()

                DatePicker(
                    "End:",
                    selection: viewStore.binding(\.$endDate),
                    displayedComponents: .date
                )
                .frame(maxWidth: 150)
                .clipped()
            }

            Spacer()

            switch viewStore.currencyCodeState {
            case let .loaded(currencyCode):
                VStack(alignment: .trailing) {
                    HStack {
                        Text("From:")

                        Picker(
                            "Currency",
                            selection: viewStore.binding(\.$currentCurrency)
                        ) {
                            ForEach(currencyCode.currencyCodes, id: \.self) { code in
                                Text(code)
                            }
                        }
                        .pickerStyle(.menu)
                    }

                    HStack {
                        Text("To:")

                        Picker(
                            "Currency",
                            selection: viewStore.binding(\.$chosenCurrency)
                        ) {
                            ForEach(currencyCode.currencyCodes, id: \.self) { code in
                                Text(code)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }

            case .none, .loading:
                ProgressView()
                    .progressViewStyle(.circular)

            case .error:
                Image(systemSymbol: .xmarkCircleFill)
            }
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private func carsBody(_ viewStore: ViewStoreOf<CarsCore>, cars: [Car]) -> some View {
        List {
            ForEach(cars, id: \.id) { car in
                NavigationLink(
                    destination: IfLetStore(
                        store.scope(
                            state: \.carDetailState,
                            action: CarsCore.Action.carDetail
                        )
                    ) { store in
                        CarDetailView(
                            store: store
                        )
                    },
                    tag: car,
                    selection: viewStore.binding(
                        get: \.carDetailState?.car,
                        send: CarsCore.Action.navigateToCarDetails(car)
                    )
                ) {
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
                                    Text("\(car.dailyCost.toString)")
                                        .font(.largeTitle)
                                        .bold()

                                    Text("\(viewStore.chosenCurrency) per day")
                                        .font(.caption)
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .listStyle(.plain)
        .background(Color.white)
        .refreshable {
            DispatchQueue.main.async {
                viewStore.send(.loadCars)
            }
        }
    }
}
