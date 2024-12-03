import SwiftUI

struct RegisterView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var reenterPassword: String = ""
    @EnvironmentObject var viewModel: ViewModel

    @State private var errorMessage: String? = nil

    @Environment(\.presentationMode) var presentationMode  // Agregar el Environment para acceder a la presentación de la vista.

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

                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }

                // Botón de Registro
                Button(action: {
                    // Verificar si las contraseñas coinciden
                    if password != reenterPassword {
                        errorMessage = "Las contraseñas no coinciden"
                        return
                    }

                    switch viewModel.createUser(
                        username: username, password: password)
                    {
                    case -1:
                        errorMessage =
                            "Los campos de nombre de usuario y contraseña no pueden estar vacíos."
                        return

                    case -2:
                        errorMessage = "El usuario \(username) ya existe."
                        return
                    case 0:
                        // Limpia los campos después del registro
                        username = ""
                        password = ""
                        reenterPassword = ""

                        errorMessage = nil

                        // Regresar a LoginView
                        self.presentationMode.wrappedValue.dismiss()
                    default:
                        errorMessage = nil
                        return
                    }

                }) {
                    Text("Registrarse")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.pink)
                        .cornerRadius(25)
                }
                .padding(.horizontal, 40)
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
