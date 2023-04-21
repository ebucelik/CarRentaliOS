//
//  CarDetailView.swift
//  CarRentaliOS
//
//  Created by Ing. Ebu Celik, BSc on 17.04.23.
//

import SwiftUI
import ComposableArchitecture

struct CarDetailView: View {

    let store: StoreOf<CarDetailCore>
    @Environment(\.dismiss) var dismiss

    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                carDetailBody(viewStore)
                    .padding()
            }
            .onChange(of: viewStore.dismissView) { dismissView in
                if dismissView {
                    dismiss()
                }
            }
        }
    }

    @ViewBuilder
    private func carDetailBody(_ viewStore: ViewStoreOf<CarDetailCore>) -> some View {
        VStack {
            AsyncImage(
                url: URL(string: viewStore.car.imageLink)
            ) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
            } placeholder: {
                Color.gray
                    .frame(height: 300)
                    .frame(maxWidth: .infinity)
            }

            HStack {
                VStack(alignment: .leading) {
                    Text(viewStore.car.model)
                        .font(.title)
                        .bold()

                    Text(viewStore.car.brand)
                        .font(.title3)
                }

                Spacer()
            }

            Divider()

            rentInformationBody(viewStore)

            Divider()

            detailInformationBody(viewStore)

            switch viewStore.rentCarState {
            case .loaded:
                HStack {
                    SharedButton(title: "Rent \(viewStore.car.brand) for \(viewStore.car.totalCosts) \(viewStore.chosenCurrency)")

                    Image(systemSymbol: .checkmarkCircleFill)
                        .foregroundColor(AppColor.blue)
                }

            case .loading:
                SharedButton(
                    title: "Rent \(viewStore.car.brand)",
                    isLoading: true
                )

            case .none, .error:
                SharedButton(
                    title: "Rent \(viewStore.car.brand) for \(viewStore.car.totalCosts) \(viewStore.chosenCurrency)",
                    isError: viewStore.isError
                ) {
                    viewStore.send(.rentCar)
                }
            }
        }
    }

    @ViewBuilder
    private func rentInformationBody(_ viewStore: ViewStoreOf<CarDetailCore>) -> some View {
        Section("Rent Information") {
            VStack {
                HStack {
                    Text("Startdate")
                        .font(.headline)

                    Spacer()

                    Text(viewStore.startDate)
                }
                .padding()

                HStack {
                    Text("Enddate")
                        .font(.headline)

                    Spacer()

                    Text(viewStore.endDate)
                }
                .padding()

                HStack {
                    Text("Daily cost")
                        .font(.headline)

                    Spacer()

                    Text("\(viewStore.car.dailyCost.toString) \(viewStore.chosenCurrency)")
                }
                .padding()

                HStack {
                    Text("Total cost")
                        .font(.headline)

                    Spacer()

                    Text("\(viewStore.car.totalCosts.toString) \(viewStore.chosenCurrency)")
                }
                .padding()
            }
            .background(AppColor.lightGray)
            .cornerRadius(8)
            .padding()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private func detailInformationBody(_ viewStore: ViewStoreOf<CarDetailCore>) -> some View {
        Section("More Information") {
            VStack {
                HStack {
                    Text("Fuel type")
                        .font(.headline)

                    Spacer()

                    Text(viewStore.car.fuelType)
                }
                .padding()

                HStack {
                    Text("Horsepower")
                        .font(.headline)

                    Spacer()

                    Text(viewStore.car.hp)
                }
                .padding()

                HStack {
                    Text("Builddate")
                        .font(.headline)

                    Spacer()

                    Text(viewStore.car.buildDate)
                }
                .padding()
            }
            .background(AppColor.lightGray)
            .cornerRadius(8)
            .padding()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
