import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: ViewModel

    @State private var isEditingUsername: Bool = false
    @State private var isEditingPassword: Bool = false
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker: Bool = false

    var body: some View {
        ZStack {
            // Fondo de color
            Color(red: 0.84, green: 0.93, blue: 0.93)
                .ignoresSafeArea()

            VStack(spacing: 40) {
                ZStack {
                    // Imagen de perfil
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 140, height: 140)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.pink, lineWidth: 3))
                            .shadow(radius: 5)
                    } else {
                        Image("defaultprofileimage")  // Imagen predeterminada
                            .resizable()
                            .scaledToFill()
                            .frame(width: 140, height: 140)
                            .foregroundColor(.gray)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.pink, lineWidth: 3))
                            .shadow(radius: 5)
                    }

                    // Ícono de cámara para cambiar la imagen
                    Button(action: {
                        showImagePicker.toggle()
                    }) {
                        Image(systemName: "camera.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .padding(5)
                            .foregroundColor(.white)
                            .background(Circle().fill(Color.pink))
                            .overlay(
                                Circle().stroke(Color.pink, lineWidth: 0.1)
                            )
                            .shadow(radius: 5)

                    }
                    .offset(x: 50, y: 50)  // Posición del ícono
                }

                // Campos de Username y Password
                VStack(spacing: 15) {
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Username")
                                .foregroundColor(.gray)
                                .font(.caption)
                            if isEditingUsername {
                                TextField("Username", text: $username)
                                    .textFieldStyle(
                                        RoundedBorderTextFieldStyle()
                                    )
                                    .padding(5)
                                    .background(Color.white)
                                    .cornerRadius(8)
                            } else {
                                Text(username)
                                    .foregroundColor(.black)
                            }
                        }
                        Spacer()
                        Button(action: {
                            if isEditingUsername {
                                // Guardar cambios en ViewModel
                                viewModel.updateUsername(newUsername: username)
                            }
                            isEditingUsername.toggle()
                        }) {
                            Image(
                                systemName: isEditingUsername
                                    ? "checkmark" : "pencil"
                            )
                            .foregroundColor(.pink)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 3)
                    .padding(.horizontal, 40)

                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.gray)
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Password")
                                .foregroundColor(.gray)
                                .font(.caption)
                            if isEditingPassword {
                                SecureField("Password", text: $password)
                                    .textFieldStyle(
                                        RoundedBorderTextFieldStyle()
                                    )
                                    .padding(5)
                                    .background(Color.white)
                                    .cornerRadius(8)
                            } else {
                                Text(password)
                                    .foregroundColor(.black)
                            }
                        }
                        Spacer()
                        Button(action: {
                            if isEditingPassword {
                                // Guardar cambios en ViewModel
                                viewModel.updatePassword(newPassword: password)
                            }
                            isEditingPassword.toggle()
                        }) {
                            Image(
                                systemName: isEditingPassword
                                    ? "checkmark" : "pencil"
                            )
                            .foregroundColor(.pink)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 3)
                    .padding(.horizontal, 40)
                }
                #if v2

                #endif

            }
        }
        .onAppear {
            if let user = viewModel.authenticatedUser {
                username = user.name ?? ""
                password = user.password ?? ""
                if let imageData = user.profileImage {
                    selectedImage = UIImage(data: imageData)
                } else {
                    selectedImage = nil
                }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: .photoLibrary) {
                imageSeleccionada in
                selectedImage = imageSeleccionada  // Asigna la imagen seleccionada al state

            }.onDisappear {
                if let image = selectedImage {
                    viewModel.updateProfileImage(newImage: image)
                }
            }
        }
    }
}
