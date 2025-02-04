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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // Reducir el retraso inicial
            withAnimation(.easeInOut(duration: 0.3)) { // Reducir duración
                horizontalOffset = 0
            }
            animateStep2()
        }
    }

    func animateStep2() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // Reducir retraso
            withAnimation(Animation.linear(duration: 0.5).repeatCount(1, autoreverses: false)) { // Reducir duración
                rotationAngle = 180
            }
            animateStep3()
        }
    }

    func animateStep3() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Reducir retraso
            withAnimation(.easeInOut(duration: 0.5)) { // Reducir duración
                verticalOffset = -UIScreen.main.bounds.height
            }
            animateStep4()
        }
    }

    func animateStep4() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Reducir retraso
            withAnimation(.easeOut(duration: 0.3)) { // Reducir duración
                showAnimation = false
            }
            onAnimationComplete()
        }
    }
}
