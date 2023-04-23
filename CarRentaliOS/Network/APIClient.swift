//
//  APIClient.swift
//  CarRental
//
//  Created by Ing. Ebu Celik, BSc on 22.03.23.
//

import Foundation

public class APIClient {

    private var token: Token? {
        Token.getTokenFromUserDefaults()
    }

    private var repeatRequest = false

    func start<C: Call>(call: C) async throws -> C.Response {
        repeat {
            repeatRequest = false

            let urlRequest = try composeUrlRequest(with: call)

            let response = try await URLSession.shared.data(for: urlRequest)

            if let httpResponse = response.1 as? HTTPURLResponse {

                print("STATUS: \(httpResponse.statusCode)")

                if isSuccessStatusCode(httpResponse.statusCode) {
                    print("DATA: \(String(decoding: response.0, as: UTF8.self))")

                    if httpResponse.statusCode == 204,
                       let empty = Empty() as? C.Response {
                        return empty
                    }

                    return try JSONDecoder().decode(C.Response.self, from: response.0)
                } else if httpResponse.statusCode == 401 {
                    guard var token = self.token else {
                        throw HTTPError.unauthorized
                    }

                    if call.body is RefreshToken {
                        throw HTTPError.unauthorized
                    }

                    let refreshToken = RefreshToken(refreshToken: token.refreshToken)
                    let refreshTokenCall = RefreshTokenCall(body: refreshToken)
                    let accessToken = try await start(call: refreshTokenCall)

                    token.accessToken = accessToken.accessToken
                    Token.saveTokenInUserDefaults(token)

                    repeatRequest = true
                }
            }
        } while repeatRequest

        throw HTTPError.unexpectedError
    }
}

extension APIClient {
    private func composeUrlRequest<C: Call>(with call: C) throws -> URLRequest {

        guard var url = URL(string: call.httpScheme + call.httpQuery) else { throw HTTPError.notFound }

        if let parameters = call.parameters {
            let urlQueryItems = parameters.map { parameter in
                URLQueryItem(
                    name: parameter.key,
                    value: "\(parameter.value)"
                )
            }

            url.append(queryItems: urlQueryItems)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = call.httpMethod.rawValue
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")

        if let token = self.token {
            urlRequest.setValue(token.accessToken, forHTTPHeaderField: "Auth")
        }

        if let body = call.body,
           let encodedBody = try? JSONEncoder().encode(body) {
            urlRequest.httpBody = encodedBody

            return urlRequest
        }

        print("\nREQUEST: \(url)")

        return urlRequest
    }

    private func isSuccessStatusCode(_ code: Int) -> Bool {
        return (200...299).contains(code)
    }
}
