//
//  HomeView.swift
//  CarRental
//
//  Created by Ing. Ebu Celik, BSc on 20.03.23.
//

import SwiftUI
import ComposableArchitecture
import SFSafeSymbols

struct HomeView: View {

    let store: StoreOf<HomeCore>

    var body: some View {
        WithViewStore(store) { viewStore in
            TabView {
                Text("Cars")
                    .tabItem {
                        Label("Cars", systemSymbol: .carFill)
                    }

                Text("Rentals")
                    .tabItem {
                        Label("Rentals", systemSymbol: .squareAndArrowDownFill)
                    }

                ViewControllerRepresentable(
                    viewController: GoogleMapsViewController()
                )
                .tabItem {
                    Label("Map", systemSymbol: .mapFill)
                }
                .edgesIgnoringSafeArea(.all)

                Text("Account")
                    .tabItem {
                        Label("Account", systemSymbol: .personFill)
                    }
                    .onAppear {
                        viewStore.send(.showToolbar)
                    }
                    .onDisappear {
                        viewStore.send(.showToolbar)
                    }
            }
            .toolbar {
                if viewStore.showToolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Image(systemSymbol: .rectanglePortraitAndArrowForwardFill)
                            .onTapGesture {
                                viewStore.send(.logout)
                            }
                    }
                }
            }
            .onAppear {
                UITabBar.appearance().backgroundColor = .white
            }
        }
    }
}
