import SwiftUI

struct RegisterView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var reenterPassword: String = ""

    var body: some View {
        ZStack {
            // Fondo de color
            Color(red: 0.9, green: 0.95, blue: 0.95)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // Título "Pokedex"
                Image("pokedex_logo")  // Asegúrate de añadir la imagen al proyecto y nombrarla "pokedex_logo"
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 150)
                    .padding(.top, 65)

                // Ícono de cámara
                Image(systemName: "camera.circle")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                    .onTapGesture {
                        // Acción para añadir una imagen
                        print("Añadir imagen")
                    }

                // Campos de texto
                TextField("Username", text: $username)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10).stroke(
                            Color.red, lineWidth: 1)
                    )
                    .padding(.horizontal, 40)

                SecureField("Password", text: $password)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10).stroke(
                            Color.red, lineWidth: 1)
                    )
                    .padding(.horizontal, 40)

                SecureField("Re-enter Password", text: $reenterPassword)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10).stroke(
                            Color.red, lineWidth: 1)
                    )
                    .padding(.horizontal, 40)

                Spacer()
            }
            .background(Color(red: 0.84, green: 0.93, blue: 0.93))
            .edgesIgnoringSafeArea(.all)
        }
    }
}
struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
