import SwiftUI

struct RottomPushingAnimationView: View {
    @State private var rotationAngle: Double = 0
    @State private var verticalOffset: CGFloat = 0
    @State private var horizontalOffset: CGFloat = (-UIScreen.main.bounds.width / 3) + 1
    @State private var animationStep: Int = 0
    @State private var showAnimation = true // Controla la visibilidad de la animación
    
    var onAnimationComplete: () -> Void // Propiedad para la acción al finalizar la animación

    init(onAnimationComplete: @escaping () -> Void = {}) {
        self.onAnimationComplete = onAnimationComplete
    }

    var body: some View {
        ZStack {
            if showAnimation {
                ZStack {
                    Color(red: 1.0, green: 0.8, blue: 0.6)
                        .edgesIgnoringSafeArea(.all)

                    VStack {
                        Image("rotomv3")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 110)
                            .offset(x: horizontalOffset, y: verticalOffset)
                            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                            .rotation3DEffect(
                                Angle(degrees: rotationAngle),
                                axis: (x: 0.0, y: 1.0, z: 0.0)
                            )
                    }
                }
                .transition(.opacity)
            }
        }
        .onAppear {
            animateStep1()
        }
    }

    func animateStep1() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(.easeInOut(duration: 1)) {
                horizontalOffset = 0
            }
            animateStep2()
        }
    }

    func animateStep2() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(Animation.linear(duration: 2).repeatCount(1, autoreverses: false)) {
                rotationAngle = 720
            }
            animateStep3()
        }
    }

    func animateStep3() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeInOut(duration: 1)) {
                verticalOffset = -UIScreen.main.bounds.height
            }
            animateStep4()
        }
    }

    func animateStep4() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(.easeOut(duration: 1)) {
                showAnimation = false
            }
            onAnimationComplete() // Llamamos a la acción al finalizar
        }
    }
}
