import SwiftUI
import Combine

struct ListaPokedexView: View {
    @StateObject private var pokemonTeam = PokemonTeam.shared
    @StateObject var pokemonViewModel = PokemonViewModel()
    @Binding var showSortFilterView: Bool
    @Binding var showFilterView: Bool
    @State var teamId: Int
    @State private var pokemones: [Pokemon] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var hasMorePokemon = true
    @StateObject var filterState: PokemonFilterState;
    @State private var filteredAndSortedPokemon: [Pokemon] = []
    
    // Add a cancellable for async tasks
    @State private var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(filteredAndSortedPokemon, id: \.id) { pokemon in
                            EntradaPokedexView(pokemon: pokemon, teamId: teamId)
                                .onAppear {
                                    if self.filteredAndSortedPokemon.last?.id == pokemon.id && hasMorePokemon {
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
                    pokemons: .constant(pokemones),
                    filterState: filterState
                )
                .transition(.move(edge: .bottom))
            }
        }
        .onAppear(perform: loadInitialPokemon)
        .onChange(of: filterState.selectedSort) { _ in
                   applyFiltersAndSort()
        }
       .onChange(of: filterState.isAscending) { _ in
                   applyFiltersAndSort()
        }
        .onChange(of: filterState.selectedTypes) { _ in
                   applyFiltersAndSort()
        }
        .onChange(of: filterState.showFavorites) { _ in
                   applyFiltersAndSort()
        }
        .onChange(of: filterState.showLegendaries) { _ in
                   applyFiltersAndSort()
        }
        .onChange(of: filterState.showSingulares) { _ in
                   applyFiltersAndSort()
        }
       .onChange(of: pokemones) { _ in
            applyFiltersAndSort()
        }

    }
    private func applyFiltersAndSort() {
        // Cancel any existing loading tasks
        cancellables.forEach { $0.cancel() }
            cancellables.removeAll()
        
        
        
        func loadMoreIfNeeded(){
            let filteredPokemons = pokemonViewModel.applyFiltersAndSort(pokemons: pokemones, filterState: filterState)
            if filteredPokemons.count < 10 && hasMorePokemon {
                
                loadMorePokemon()
                    .sink {  completion in
                        
                        switch completion {
                        case .finished:
                            
                           break
                        case .failure(let error):
                            print("Error loading more pokemons: \(error)")
                            self.hasMorePokemon = false
                            self.errorMessage = "Error cargando pokemons"
                            
                        }
                        
                    } receiveValue: { _ in
                        
                        
                        
                        
                        loadMoreIfNeeded()
                        
                    }
                    .store(in: &cancellables)
            } else {
                self.filteredAndSortedPokemon = filteredPokemons
            }
        }
        
        
        loadMoreIfNeeded()

    }
    
    private func loadInitialPokemon() {
        loadPokemon(startId: 1, count: 100)
    }
    
    private func loadMorePokemon() -> Future<[Pokemon], Error> {
        let nextStartId = pokemones.count + 1
        return loadPokemon(startId: nextStartId, count: 100)
    }
    
    private func loadPokemon(startId: Int, count: Int) -> Future<[Pokemon], Error> {
            
        return Future { promise in
                guard !isLoading && hasMorePokemon else {
                    promise(.success([]))
                    return
                }
            
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
                 promise(.success(newPokemon))
                }
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
    @State var teamId: Int = 0
    @StateObject var filterState = PokemonFilterState()
    ListaPokedexView(
        showSortFilterView: $showSortFilterView,
        showFilterView: $showFilterView, teamId: teamId,
        filterState: filterState
    )
}
