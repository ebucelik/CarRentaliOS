//
//  HomeCoreTests.swift
//  CarRentaliOSTests
//
//  Created by Ing. Ebu Celik, BSc on 27.04.23.
//

import XCTest
import ComposableArchitecture
@testable import CarRentaliOS

@MainActor
class CarsCoreTests: XCTestCase {

    let clock = TestClock()

    func setupTestStore() -> TestStore<CarsCore.State, CarsCore.Action, CarsCore.State, CarsCore.Action, ()> {

        return TestStore(
            initialState: CarsCore.State(),
            reducer: CarsCore()
        ) {
            $0.carService = .testValue
            $0.currencyCodesService = .testValue
            $0.continuousClock = clock
        }
    }

    func testOnViewAppear() async {
        // Arrange
        let testStore = setupTestStore()
        let expectedCurrencyCodes: CurrencyCode = .mockWithEur
        let expectedCars: [Car] = [.mock1, .mock2, .mock3]

        await clock.advance(by: .seconds(1))

        // Act & Assert
        await testStore.send(.onViewAppear)

        await testStore.receive(.loadCurrencyCode)

        await testStore.receive(.loadCars)

        await testStore.receive(.currencyCodeStateChanged(.loading)) {
            $0.currencyCodeState = .loading
        }

        await testStore.receive(.carsStateChanged(.loading)) {
            $0.carsState = .loading
        }

        await clock.advance(by: .seconds(1))

        await testStore.receive(.currencyCodeStateChanged(.loaded(.mock))) {
            $0.currencyCodeState = .loaded(expectedCurrencyCodes)
        }

        await testStore.receive(.carsStateChanged(.loaded(expectedCars))) {
            $0.carsState = .loaded(expectedCars)
        }

        await testStore.finish()
    }
}
