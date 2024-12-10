//
//  InitialView.swift
//  PokédexApp
//
//  Created by Aula03 on 12/11/24.
//

import SwiftUI

struct InitialView: View {
    @State private var rotationAngle: Double = 0
    @State private var verticalOffset: CGFloat = -300
    var body: some View {
        ZStack {
            Color(red: 1.0, green: 0.8, blue: 0.6)
                .edgesIgnoringSafeArea(.all)
            Image("rotomv3")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 110)
                .offset(y: verticalOffset)
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                .rotation3DEffect(
                    Angle(degrees: rotationAngle),
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                )
                .animation(
                    Animation.easeInOut(duration: 4)
                        .speed(2)
                        .repeatForever(autoreverses: true),
                    value: rotationAngle
                )
                .animation(
                    Animation.easeInOut(duration: 3)
                        .speed(5)
                        .repeatForever(autoreverses: true),
                    value: verticalOffset
                )
                .onAppear {
                    rotationAngle = 360
                    verticalOffset = 3000
                }
        }
    }
}

#Preview {
    InitialView()
}
