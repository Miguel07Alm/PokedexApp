import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @EnvironmentObject var viewModel: ViewModel

    @State private var isAuthenticated: Bool = false
    @State private var errorMessage: String? = nil

    var body: some View {
        NavigationView {
            ZStack {
                // Fondo de color
                Color(red: 0.9, green: 0.95, blue: 0.95)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    // Imagen del logo "Pokedex"
                    Image("pokedex_logo")  // Asegúrate de añadir la imagen al proyecto y nombrarla "pokedex_logo"
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 150)  // Ajusta el tamaño según sea necesario

                    // Imagen de Pikachu
                    Image("pikachu_logo")  // Asegúrate de añadir esta imagen al proyecto
                        .resizable()
                        .scaledToFit()
                        .frame(width: 390, height: 270)
                        .clipShape(Circle())
                        .shadow(radius: 5)

                    // Subtítulo "Sign Up"
                    Text("Sign Up")
                        .font(.system(size: 50))
                        .foregroundColor(.pink)
                        .fontWeight(.semibold)

                    // Campos de texto
                    VStack(spacing: 15) {
                        // Campo de Username
                        TextField("Username", text: $username)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.pink, lineWidth: 1)
                            )

                        // Campo de Password
                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.pink, lineWidth: 1)
                            )
                    }
                    .padding(.horizontal, 40)

                    // Botón de Login
                    Button(action: {
                        // Intentar autenticar al usuario
                        if let authenticatedUser = viewModel.authenticateUser(
                            username: username, password: password)
                        {
                            // Si la autenticación es exitosa
                            isAuthenticated = true
                            errorMessage = nil
                            // Aquí puedes navegar a otra vista o hacer algo más (como mostrar detalles del usuario)
                            print(
                                "Usuario autenticado: \(authenticatedUser.name ?? "Desconocido")"
                            )
                        } else {
                            // Si no se encuentra el usuario
                            errorMessage =
                                "Nombre de usuario o contraseña incorrectos."
                            isAuthenticated = false
                        }
                    }) {
                        Text("Iniciar sesión")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.pink)
                            .cornerRadius(25)
                    }
                    .padding(.horizontal, 40)

                    // Mensaje de error si la autenticación falla
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .padding(.top, 10)
                    }

                    // Enlace de "Registrarme"
                    HStack {
                        Text("¿No tienes cuenta?")
                            .font(.footnote)

                        NavigationLink(
                            destination: RegisterView().environmentObject(
                                viewModel)
                        ) {

                            Text("Registrarme")
                                .font(.footnote)
                                .foregroundColor(.pink)

                        }
                    }

                    Spacer()
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(ViewModel())
    }
}
