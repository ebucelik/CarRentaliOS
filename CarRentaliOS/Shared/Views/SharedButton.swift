//
//  SharedButton.swift
//  CarRentaliOS
//
//  Created by Ing. Ebu Celik, BSc on 13.04.23.
//

import SwiftUI

struct SharedButton: View {

    let title: String
    let isLoading: Bool
    let isError: Bool
    let action: () -> Void

    init(title: String,
         isLoading: Bool = false,
         isError: Bool = false,
         action: @escaping () -> Void = {}) {
        self.title = title
        self.isLoading = isLoading
        self.isError = isError
        self.action = action
    }

    var body: some View {
        HStack {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                Text(title)
                    .font(.title3)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)

                Spacer()

                if isError {
                    Image(systemSymbol: .exclamationmarkTriangleFill)
                }
            }
        }
        .padding()
        .frame(height: 55)
        .frame(maxWidth: .infinity)
        .background(AppColor.blue)
        .cornerRadius(8)
        .onTapGesture {
            if !isLoading {
                action()
            }
        }
    }
}

struct SharedButton_Previews: PreviewProvider {
    static var previews: some View {
        SharedButton(
            title: "Sign In"
        )
    }
}
