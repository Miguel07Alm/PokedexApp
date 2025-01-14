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

            ScrollView {
                VStack(spacing: 40) {
                    // Imagen de perfil
                    profileImageSection

                    // Sección de Username y Password
                    usernamePasswordSection

                    // Sección de batallas
                    battleSection
                }
                .padding(.bottom, 20)
            }
        }
        .onAppear(perform: loadUserData)
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: .photoLibrary) { imageSeleccionada in
                selectedImage = imageSeleccionada
            }
            .onDisappear {
                if let image = selectedImage {
                    viewModel.updateProfileImage(newImage: image)
                }
            }
        }
    }

    // MARK: - Subviews

    var profileImageSection: some View {
        ZStack {
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
                    .shadow(radius: 5)
            }
            .offset(x: 50, y: 50)
        }
    }

    var usernamePasswordSection: some View {
        VStack(spacing: 15) {
            editableField(
                icon: "person.fill",
                title: "Username",
                value: $username,
                isEditing: $isEditingUsername,
                action: { viewModel.updateUsername(newUsername: username) }
            )

            editableField(
                icon: "lock.fill",
                title: "Password",
                value: $password,
                isEditing: $isEditingPassword,
                isSecure: true,
                action: { viewModel.updatePassword(newPassword: password) }
            )
        }
    }

    var battleSection: some View {
        VStack(spacing: 20) {
            Text("Batalla")
                .font(.title2)
                .foregroundColor(.red)

            Image("Perfil")  // Reemplaza con tu imagen de Pokémon favorito
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)

            HStack {
                Text("Numero de batallas:")
                    .foregroundColor(.gray)
                Text("X")
                    .foregroundColor(.black)
                    .bold()
            }

            VStack(spacing: 10) {
                BattleResultView(team1: "Equipo 1", result: "W-D", team2: "Equipo 2")
                BattleResultView(team1: "Equipo 1", result: "D-W", team2: "Equipo 2")
                BattleResultView(team1: "Equipo 1", result: "D-W", team2: "Equipo 2")
                BattleResultView(team1: "Equipo 1", result: "D-W", team2: "Equipo 2")
            }
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Reusable Editable Field

    func editableField(icon: String, title: String, value: Binding<String>, isEditing: Binding<Bool>, isSecure: Bool = false, action: @escaping () -> Void) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .foregroundColor(.gray)
                    .font(.caption)
                if isEditing.wrappedValue {
                    if isSecure {
                        SecureField(title, text: value)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else {
                        TextField(title, text: value)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                } else {
                    Text(value.wrappedValue)
                        .foregroundColor(.black)
                }
            }
            Spacer()
            Button(action: {
                if isEditing.wrappedValue {
                    action()
                }
                isEditing.wrappedValue.toggle()
            }) {
                Image(systemName: isEditing.wrappedValue ? "checkmark" : "pencil")
                    .foregroundColor(.pink)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 3)
        .padding(.horizontal, 40)
    }

    // MARK: - Load User Data

    func loadUserData() {
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
}

struct BattleResultView: View {
    var team1: String
    var result: String
    var team2: String
    
    var body: some View {
        HStack {
            Text(team1)
                .font(.subheadline)
                .foregroundColor(.black)
            
            Spacer()
            
            Text(result)
                .font(.subheadline)
                .bold()
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.red)
                .cornerRadius(5)
            
            Spacer()
            
            Text(team2)
                .font(.subheadline)
                .foregroundColor(.black)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        .padding(.horizontal, 30)
    }
}

struct BattleHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().environmentObject(ViewModel())
    }
}

