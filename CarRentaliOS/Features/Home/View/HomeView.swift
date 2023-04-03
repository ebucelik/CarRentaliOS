//
//  HomeView.swift
//  CarRental
//
//  Created by Ing. Ebu Celik, BSc on 20.03.23.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {

    let store: StoreOf<HomeCore>

    var body: some View {
        WithViewStore(store) { viewStore in
            TabView {
                Text("Cars")
                    .tabItem {
                        Label("Cars", systemImage: "car.fill")
                    }

                Text("Rentals")
                    .tabItem {
                        Label("Rentals", systemImage: "square.and.arrow.down.fill")
                    }

                Text("Account")
                    .tabItem {
                        Label("Account", systemImage: "person.fill")
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Image(systemName: "rectangle.portrait.and.arrow.forward.fill")
                                .onTapGesture {
                                    viewStore.send(.logout)
                                }
                        }
                    }
            }
        }
    }
}
