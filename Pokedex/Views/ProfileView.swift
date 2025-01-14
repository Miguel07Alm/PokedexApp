import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: ViewModel

    @State private var isEditingUsername: Bool = false
    @State private var isEditingPassword: Bool = false
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker: Bool = false

    @StateObject private var pokemonViewModel = PokemonViewModel()
    @State private var pokemonMoreUsed: URL? = nil
    @State private var numBattle: Int = 0

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
                    #if v2
                        battleSection
                    #endif

                }
                .padding(.vertical, 150)
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

            AsyncImage(url: pokemonMoreUsed) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
            } placeholder: {
                ProgressView()
            }

            HStack {
                Text("Numero de batallas:")
                    .foregroundColor(.gray)
                Text(String(numBattle))
                    .foregroundColor(.black)
                    .bold()
            }

            VStack(spacing: 10) {
                let battleHistory = viewModel.getBattleHistory()

                if battleHistory.isEmpty {
                    Text("No hay batallas en el historial.")
                } else {
                    ForEach(0..<battleHistory.count, id: \.self) { index in
                        let battleData = battleHistory[index]

                        BattleResultView(
                            team1: battleData.team1Pokemons,
                            result: battleData.battle.winner,
                            team2: battleData.team2Pokemons
                        )
                    }
                }
            }

        }.onAppear {

            let pokemon =
                viewModel.getMostUsedPokemon()

            let pokemonName = pokemon?.name ?? "bulbasaur"
            numBattle = pokemon?.usageCount ?? 0

            Task {
                if let url = await urlFromPokemon(pokemonName) {
                    pokemonMoreUsed = url
                } else {
                    print("No se pudo obtener la URL del Pokémon")
                }
            }

        }
        .padding(.horizontal, 20)
    }

    // MARK: - Reusable Editable Field

    func editableField(
        icon: String, title: String, value: Binding<String>,
        isEditing: Binding<Bool>, isSecure: Bool = false,
        action: @escaping () -> Void
    ) -> some View {
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
                Image(
                    systemName: isEditing.wrappedValue ? "checkmark" : "pencil"
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
    var team1: [PokemonEntity]
    var result: Int16
    var team2: [PokemonEntity]

    // Propiedades de estado para almacenar las URLs de cada equipo
    @State private var team1URLs: [URL?] = []
    @State private var team2URLs: [URL?] = []

    var body: some View {
        HStack {
            HStack {
                ForEach(team1URLs.indices, id: \.self) { index in
                    if let url = team1URLs[index] {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                        } placeholder: {
                            ProgressView()
                        }
                    }

                }
            }

            Spacer()

            Text(result == 1 ? "W-D" : "D-W")
                .font(.subheadline)
                .bold()
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.red)
                .cornerRadius(5)

            Spacer()

            HStack {
                ForEach(team2URLs.indices, id: \.self) { index in
                    if let url = team2URLs[index] {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                        } placeholder: {
                            ProgressView()
                        }
                    }

                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        .padding(.horizontal, 30)
        .onAppear {
            for pokemon in team1 {
                Task {
                    if let url = await urlFromPokemon(pokemon.name ?? "ditto") {
                        team1URLs.append(url)
                    } else {
                        print("No se pudo obtener la URL del Pokémon")
                    }
                }
            }

            for pokemon in team2 {
                Task {
                    if let url = await urlFromPokemon(pokemon.name ?? "ditto") {
                        team2URLs.append(url)
                    } else {
                        print("No se pudo obtener la URL del Pokémon")
                    }
                }
            }
        }
    }

}

func urlFromPokemon(_ pokemonID: String) async -> URL? {
    return await withCheckedContinuation { continuation in
        PokemonViewModel().fetchPokemonDetails(id: pokemonID) { result in
            switch result {
            case .success(let details):
                let imageName =
                    details.sprites.other?.officialArtwork?.frontDefault
                    ?? ""
                let url = URL(string: imageName)
                //                print("URL: \(String(describing: url))")
                continuation.resume(returning: url)  // Retornamos la URL obtenida
            case .failure(let error):
                print(
                    "Error al obtener los detalles del Pokémon: \(error.localizedDescription)"
                )
                continuation.resume(returning: nil)  // Retornamos nil en caso de error
            }
        }
    }
}

struct BattleHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().environmentObject(ViewModel())
    }
}
