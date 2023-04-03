//
//  SharedTextView.swift
//  CarRental
//
//  Created by Ing. Ebu Celik, BSc on 23.03.23.
//

import SwiftUI
import SFSafeSymbols

struct SharedTextView: View {

    var secure: Bool = false
    var systemSymbol: SFSymbol
    var placeholder: String
    @Binding var text: String
    @State var showPassword: Bool = false

    var body: some View {
        HStack {
            Image(systemSymbol: systemSymbol)

            HStack {
                if secure {
                    if showPassword {
                        TextField(
                            placeholder,
                            text: $text
                        )
                    } else {
                        SecureField(
                            placeholder,
                            text: $text
                        )
                    }

                    ZStack {
                        showPassword ?
                        Image(systemSymbol: .eye) : Image(systemSymbol: .eyeSlash)
                    }
                    .onTapGesture {
                        showPassword.toggle()
                    }
                } else {
                    TextField(
                        placeholder,
                        text: $text
                    )
                }
            }
            .padding()
            .background(AppColor.blue)
            .cornerRadius(8)
        }
    }
}

struct SharedTextView_Previews: PreviewProvider {
    static var previews: some View {
        SharedTextView(
            secure: true,
            systemSymbol: .person,
            placeholder: "Write something cool",
            text: .constant("")
        )
    }
}
