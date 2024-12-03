import SwiftUI

struct RegisterView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var reenterPassword: String = ""
    @EnvironmentObject var viewModel: ViewModel

    @State private var errorMessage: String? = nil

    @State var mostrarImagePicker: Bool = false
    @State private var imageGeneral: UIImage? = nil

    @Environment(\.presentationMode) var presentationMode  // Agregar el Environment para acceder a la presentación de la vista.

    @State var selectedTab = 0

    var body: some View {
        GeometryReader { geometry in
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
                    VStack {
                        // Imagen que actúa como un botón con onTapGesture
                        if let imageGeneral = imageGeneral {
                            // Mostrar la imagen seleccionada
                            Image(uiImage: imageGeneral)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 90, height: 90)
                                .shadow(color: .gray, radius: 9)
                                .padding(.vertical)
                                .onTapGesture {
                                    mostrarImagePicker.toggle()  // Abre el picker al tocar la imagen
                                }
                        } else {
                            // Mostrar el icono de la cámara como imagen si no hay imagen seleccionada
                            Image(systemName: "camera.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 90, height: 90)
                                .foregroundColor(.gray)
                                .shadow(color: .gray, radius: 9)
                                .padding(.vertical)
                                .onTapGesture {
                                    mostrarImagePicker.toggle()  // Abre el picker al tocar el icono de la cámara
                                }
                        }
                    }
                    .sheet(isPresented: $mostrarImagePicker) {
                        ImagePicker(sourceType: .photoLibrary) {
                            imageSeleccionada in
                            imageGeneral = imageSeleccionada  // Asigna la imagen seleccionada al state
                        }
                    }

                    // Campos de texto
                    TextField("Username", text: $username)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.pink, lineWidth: 1)
                        )
                        .frame(width: geometry.size.width * 0.8)

                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.pink, lineWidth: 1)
                        )
                        .frame(width: geometry.size.width * 0.8)

                    SecureField("Re-enter Password", text: $reenterPassword)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.pink, lineWidth: 1)
                        )
                        .frame(width: geometry.size.width * 0.8)

                    if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }

                }.padding(.top, -300)

                VStack {
                    Spacer()
                    // Empuja el FooterView al fondo de la pantalla
                    FooterView(
                        selectedTab: $selectedTab,
                        onRegisterTapped: {
                            // Verificar si las contraseñas coinciden
                            if password != reenterPassword {
                                errorMessage = "Las contraseñas no coinciden"
                                return
                            }

                            switch viewModel.createUser(
                                username: username, password: password, profileImage: imageGeneral)
                            {
                            case -1:
                                errorMessage =
                                    "Los campos de nombre de usuario y contraseña no pueden estar vacíos."
                                return

                            case -2:
                                errorMessage =
                                    "El usuario \(username) ya existe."
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
                        }
                    )
                    .padding(.bottom, 0)  // Ajustar el padding según el tamaño de la pantallas
                }
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
