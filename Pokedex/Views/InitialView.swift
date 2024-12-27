import SwiftUI

struct InitialView: View {
    @State private var rotationAngle: Double = 0
    @State private var verticalOffset: CGFloat = -300
    
    var body: some View {
        NavigationStack {
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
                    //bastante temporal esto
                    NavigationLink(destination: TeamsCombateView()) {
                        Text("Ir a Equipos de Combate")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.top, 50)
                    
                }
            }
            .onAppear {
                rotationAngle = 360
                verticalOffset = 300
            }
            .navigationBarHidden(true)
        }
    }
}


#Preview {
    InitialView()
}

