//
//  PokeballAnimationView.swift
//  PokédexApp
//
//  Created by Aula03 on 19/11/24.
//

import SwiftUI

struct PokeballAnimationView: View {
    @State private var rotationAngle: Double = 0
    @State private var isOpening = false
    @Binding var isAnimating: Bool // Vincula la animación con la vista principal
    var onAnimationEnd: () -> Void // Acción al finalizar la animación

    var body: some View {
        ZStack {
            // Parte superior de la Pokéball
            RoundedRectangle(cornerRadius: 20)
                .fill(isOpening ? Color.white : Color.red)
                .frame(height: 200)
                .offset(y: isOpening ? -150 : 0)
                .animation(isOpening ? .easeInOut(duration: 0.8) : .none, value: isOpening)

            // Parte inferior de la Pokéball
            RoundedRectangle(cornerRadius: 20)
                .fill(isOpening ? Color.red : Color.white)
                .frame(height: 200)
                .offset(y: isOpening ? 150 : 0)
                .animation(isOpening ? .easeInOut(duration: 0.8) : .none, value: isOpening)

            // Círculo central
            Circle()
                .fill(Color.black)
                .frame(width: 50, height: 50)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 5)
                        .frame(width: 40, height: 40)
                )
                .rotationEffect(.degrees(rotationAngle))
                .animation(.easeInOut(duration: 0.8), value: rotationAngle)
        }
        .rotationEffect(.degrees(rotationAngle))
        .onAppear {
            startAnimationSequence()
        }
    }

    private func startAnimationSequence() {
        // Paso 1: Rotar 180 grados (intercambia colores)
        withAnimation {
            rotationAngle = 180
        }

        // Paso 2: Rotar nuevamente para volver al estado original
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation {
                rotationAngle = 360
            }
        }

        // Paso 3: Abrir la Pokéball
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            withAnimation {
                isOpening = true
            }
        }

        // Paso 4: Finalizar la animación
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
            isAnimating = false
            onAnimationEnd()
        }
    }
}

#Preview {
    PokeballAnimationView(
        isAnimating: .constant(true),
        onAnimationEnd: { print("Animation ended!") }
    )
}

