import SwiftUI

struct ListaPokedexView: View {
    @ObservedObject var pokemonViewModel = PokemonViewModel()

    @Binding var showSortFilterView: Bool
    @Binding var showFilterView: Bool

    @State private var selectedPokemon: Pokemon? // Estado para almacenar el Pokémon seleccionado

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Contenido principal
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        if let pokemon = selectedPokemon {
                            EntradaPokedexView(
                                name: pokemon.name.capitalizedFirstLetter(),
                                number: String(format: "%04d", pokemon.id),
                                image: pokemon.sprites.other?.officialArtwork.frontDefault ?? "",
                                backgroundColor: getColorForType(pokemon.types[0].type.name) // Usa el método para determinar el color
                            )
                        } else {
                            Text("Cargando datos del Pokémon...")
                                .foregroundColor(.gray)
                                .padding()
                        }
                    }
                    .padding()
                }
                .edgesIgnoringSafeArea(.bottom)
                .background(Color(red: 0.7529411764705882, green: 0.8588235294117647, blue: 0.8588235294117647))
            }

            // Mostrar la vista de filtros si está activa
            if showSortFilterView || showFilterView {
                PokemonSortFilterView(
                    isPresented: true,
                    isFilterShow: $showFilterView,
                    isSortFilterShow: $showSortFilterView,
                    pokemons: .constant([])
                )
                .transition(.move(edge: .bottom))
            }
        }
        .onAppear {
            // Realiza la consulta al aparecer la vista
            pokemonViewModel.fetchPokemonDetails(id: 25) { result in
                switch result {
                case .success(let details):
                    DispatchQueue.main.async {
                        self.selectedPokemon = details // Actualiza el estado
                    }
                case .failure(let error):
                    print("Error fetching details: \(error)")
                }
            }
        }
    }

    /// Método para obtener un color basado en el tipo de Pokémon
    func getColorForType(_ type: String) -> Color {
        switch type {
        case "fire": return Color(hex: "#FF9741")
        case "water": return Color(hex: "#3692DC")
        case "grass": return Color(hex: "#38BF4B")
        case "electric": return Color(hex: "#FBD100")
        case "bug": return Color(hex: "#83C300")
        case "dark": return Color(hex: "#5B5466")
        case "ghost": return Color(hex: "#4C6AB2")
        case "dragon": return Color(hex: "#006FC9")
        case "fairy": return Color(hex: "#FB89EB")
        case "fighting": return Color(hex: "#E0306A")
        case "flying": return Color(hex: "#89AAE3")
        case "ground": return Color(hex: "#E87236")
        case "rock": return Color(hex: "#C8B686")
        case "ice": return Color(hex: "#4CD1C0")
        case "normal": return Color(hex: "#919AA2")
        case "poison": return Color(hex: "#B567CE")
        case "psychic": return Color(hex: "#FF6675")
        case "steel": return Color(hex: "#5A8EA2")
        default: return Color.black
        }
    }
}

extension String {
    func capitalizedFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
}

#Preview {
    @State var showSortFilterView: Bool = false
    @State var showFilterView: Bool = false
    ListaPokedexView(
        showSortFilterView: $showSortFilterView,
        showFilterView: $showFilterView
    )
}
