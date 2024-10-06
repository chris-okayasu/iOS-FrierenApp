//
//  Constants.swift
//  FrierenApp
//
//  Created by chris on 2024/10/04.
//

import Foundation
import SwiftUI

enum Constants {
    static let titleFont = "PartyLetPlain"
}

struct InfoBackgroundImage: View {
    var body: some View {
        Image(.parchment)
            .resizable()
//            .scaledToFill()
            .background(.brown)
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
    }
}

extension Button {
    func doneButton () -> some View {
        self
            .font(.largeTitle)
            .padding()
            .buttonStyle(.borderedProminent)
            .tint(.brown)
            .foregroundStyle(.white)
        
    }
}
