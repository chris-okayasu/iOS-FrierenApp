//
//  mainPageAnimations.swift
//  FrierenApp
//
//  Created by chris on 2024/10/05.
//

import Foundation

import SwiftUI

struct AnimatedVStack<Content: View>: View {
    let animateViewsIn: Bool
    let animationDuration: Double
    let animationDelay: Double
    let content: () -> Content

    var body: some View {
        VStack {
            if animateViewsIn {
                content()
            }
        }
        .animation(.easeOut(duration: animationDuration).delay(animationDelay), value: animateViewsIn)
    }
}
