
//
//  InitialView.swift
//  PokédexApp
//
//  Created by Aula03 on 12/11/24.
//

import SwiftUI

struct InitialView: View {
    @State private var rotationAngle = 0.0
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 1.0, green: 0.8, blue: 0.6),
                    Color(red: 1.0, green: 0.85, blue: 0.7)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            Image("rotom")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 270, height: 250)
                .rotation3DEffect(
                    Angle(degrees: rotationAngle),
                    axis: (x: 0.0, y: 1.0, z: 0.0)//,
                    //perspective: 0.005
                )
                .scaleEffect(1.0 - abs(sin(rotationAngle * .pi / 180)) * 0.1)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                .animation(
                    Animation.easeInOut(duration: 2.7)
                        .repeatForever(autoreverses: false),
                    value: rotationAngle
                )
                .onAppear {
                    rotationAngle = 360
                }
        }
    }
}

#Preview {
    InitialView()
}
