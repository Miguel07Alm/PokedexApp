import SwiftUI

struct ListaPokedexView: View {
    @StateObject var pokemonViewModel = PokemonViewModel()
    @Binding var showSortFilterView: Bool
    @Binding var showFilterView: Bool
    @State private var pokemones: [Pokemon] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var currentPage = 1
    @State private var hasMorePokemon = true
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(pokemones.sorted(by: { $0.id < $1.id }), id: \.id) { pokemon in
                            EntradaPokedexView(
                                name: pokemon.name.capitalizedFirstLetter(),
                                number: String(format: "%04d", pokemon.id),
                                image: pokemon.sprites.other?.officialArtwork?.frontDefault ?? "",
                                backgroundColor: Color.forType(pokemon.types[0].type.name)
                            )
                            .onAppear {
                                if self.pokemones.last?.id == pokemon.id && hasMorePokemon {
                                    loadMorePokemon()
                                }
                            }
                        }
                    }
                    .padding()
                }
                .edgesIgnoringSafeArea(.bottom)
                .background(Color(red: 0.7529411764705882, green: 0.8588235294117647, blue: 0.8588235294117647))
            }
            
            if isLoading {
                ProgressView()
            }
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

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
        .onAppear(perform: loadInitialPokemon)
    }
    
    private func loadInitialPokemon() {
        loadPokemon(startId: 1, count: 100)
    }
    
    private func loadMorePokemon() {
        let nextStartId = pokemones.count + 1
        loadPokemon(startId: nextStartId, count: 100)
    }
    
    private func loadPokemon(startId: Int, count: Int) {
        guard !isLoading && hasMorePokemon else { return }
        
        isLoading = true
        errorMessage = nil
        
        let group = DispatchGroup()
        var newPokemon: [Pokemon] = []
        
        for i in startId...(startId + count - 1) {
            group.enter()
            pokemonViewModel.fetchPokemonDetails(id: i) { result in
                defer { group.leave() }
                switch result {
                case .success(let details):
                    newPokemon.append(details)
                case .failure(let error):
                    print("Error al obtener detalles del Pokémon \(i): \(error)")
                    if error.localizedDescription.contains("The operation couldn't be completed") {
                        hasMorePokemon = false
                    }
                }
            }
        }
        
        group.notify(queue: .main) {
            self.pokemones.append(contentsOf: newPokemon)
            self.isLoading = false
            if newPokemon.isEmpty {
                self.hasMorePokemon = false
                self.errorMessage = "No hay más Pokémon para cargar"
            }
        }
    }
}

extension String {
    func capitalizedFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
}

extension Color {
    static func forType(_ type: String) -> Color {
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
        default: return .black
        }
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


