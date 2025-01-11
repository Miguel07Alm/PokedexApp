import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @EnvironmentObject var viewModel: ViewModel

    @State private var isAuthenticated: Bool = false
    @State private var errorMessage: String? = nil

    @State var selectedTab = 0
    @State private var isNavigationActive = false

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    // Fondo de color
                    Color(red: 0.9, green: 0.95, blue: 0.95)
                        .ignoresSafeArea()

                    VStack(spacing: geometry.size.height * 0.02) {
                        // Imagen del logo "Pokedex"
                        Image("pokedex_logo")  // Asegúrate de añadir la imagen al proyecto y nombrarla "pokedex_logo"
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.6)  // 60% del ancho de la pantalla

                        // Imagen de Pikachu
                        Image("pikachu_logo")  // Asegúrate de añadir esta imagen al proyecto
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.9)  // 90% del ancho de la pantalla
                            .clipShape(Circle())
                            .shadow(radius: 5)

                        // Subtítulo "Sign Up"
                        Text("Sign Up")
                            .font(.system(size: geometry.size.width * 0.1))  // Fuente proporcional al ancho
                            .foregroundColor(.pink)
                            .fontWeight(.semibold)

                        // Campos de texto
                        VStack(spacing: geometry.size.height * 0.02) {
                            // Campo de Username
                            TextField("Username", text: $username)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.pink, lineWidth: 1)
                                )
                                .frame(width: geometry.size.width * 0.8)  // 80% del ancho de la pantalla

                            // Campo de Password
                            SecureField("Password", text: $password)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.pink, lineWidth: 1)
                                )
                                .frame(width: geometry.size.width * 0.8)  // 80% del ancho de la pantalla
                        }
                        .padding(.horizontal)

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

                        // Mensaje de error si la autenticación falla
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .font(.footnote)
                                .foregroundColor(.red)
                                .padding(.top, geometry.size.height * 0.02)
                        }

                        Spacer()  // Espacio para empujar el contenido hacia arriba
                    }
                    .padding(.top, geometry.size.height * 0.05)

                    VStack {
                        Spacer()
                        // Empuja el FooterView al fondo de la pantalla
                        FooterView(
                            selectedTab: selectedTab,
                            onRegisterTapped: {
                                print(
                                    "Usuario: \(username) y Contrasenia: \(password)"
                                )
                                if let authenticatedUser =
                                    viewModel.authenticateUser(
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
                            }
                        )
                        .padding(.bottom, geometry.size.height * -0.0435)
                        .navigationDestination(isPresented: $isAuthenticated) {
                            MainView(irA: "Pokedex")
                        }
                    }
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
