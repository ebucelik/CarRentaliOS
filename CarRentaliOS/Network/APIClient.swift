//
//  APIClient.swift
//  CarRental
//
//  Created by Ing. Ebu Celik, BSc on 22.03.23.
//

import Foundation

public class APIClient {
    func start<C: Call>(call: C) async throws -> C.Response {
        let urlRequest = try composeUrlRequest(with: call)

        let response = try await URLSession.shared.data(for: urlRequest)

        if let httpResponse = response.1 as? HTTPURLResponse {

            print("STATUS: \(httpResponse.statusCode)")

            if isSuccessStatusCode(httpResponse.statusCode) {
                print("DATA: \(String(decoding: response.0, as: UTF8.self))")

                return try JSONDecoder().decode(C.Response.self, from: response.0)
            } else if httpResponse.statusCode == 401 {
                throw HTTPError.unauthorized
            }
        }

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

        if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
            urlRequest.setValue(accessToken, forHTTPHeaderField: "Auth")
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
