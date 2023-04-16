//
//  Token.swift
//  CarRentaliOS
//
//  Created by Ing. Ebu Celik, BSc on 13.04.23.
//

import Foundation

struct Token: Codable, Equatable {
    var accessToken: String
    let refreshToken: String
}

extension Token {
    static func saveTokenInUserDefaults(_ token: Self) {
        do {
            let jsonDataToken = try JSONEncoder().encode(token)

            UserDefaults.standard.set(jsonDataToken, forKey: "token")
            UserDefaults.standard.synchronize()
        } catch {
            print("Could not save token in User Defaults.")
        }
    }

    static func removeTokenFromUserDefaults() {
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.synchronize()
    }

    static func getTokenFromUserDefaults() -> Self? {
        guard let jsonDataToken = UserDefaults.standard.object(forKey: "token") as? Data else {
            return nil
        }

        do {
            return try JSONDecoder().decode(Self.self, from: jsonDataToken)
        } catch {
            print("Could not fetch token from User Defaults.")
        }

        return nil
    }
}
