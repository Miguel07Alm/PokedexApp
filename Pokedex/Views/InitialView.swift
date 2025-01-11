import SwiftUI

struct InitialView: View {
    @State private var rotationAngle: Double = 0
    @State private var verticalOffset: CGFloat = -300
    @State private var showAnimation = true // Controla la visibilidad de la animación
    
    // ViewModel
    @EnvironmentObject var viewModel: ViewModel

    var body: some View {
        ZStack {
            NavigationStack {
                LoginView().environmentObject(viewModel)
            }
            .opacity(showAnimation ? 0 : 1) // Muestra LoginView solo cuando termina la animación

            if showAnimation {
                ZStack {
                    Color(red: 1.0, green: 0.8, blue: 0.6)
                        .edgesIgnoringSafeArea(.all)

                    VStack {
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
                    }
                }
                .transition(.opacity) // Controla el fade
            }
        }
        .onAppear {
            rotationAngle = 360
            verticalOffset = 300
            // Oculta la animación después de un retraso
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeOut(duration: 1)) {
                    showAnimation = false
                }
            }
        }
    }
}


#Preview {
    InitialView()
}
