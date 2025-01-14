import Combine
import Foundation
import SwiftUI

struct ListaPokedexView: View {
    #if v2
        @StateObject private var pokemonTeam = PokemonTeam.shared
    #endif
    @EnvironmentObject var viewModel: ViewModel
    @StateObject var pokemonViewModel = PokemonViewModel()
    @Binding var showSortFilterView: Bool
    @Binding var showFilterView: Bool
    @State var teamId: Int
    @State private var pokemones: [Pokemon] = []
    @State private var isLoading = false
    @State private var isFetchingMore = false
    @State private var errorMessage: String?
    @State private var hasMorePokemon = true
    @StateObject var filterState: PokemonFilterState
    @State private var filteredAndSortedPokemon: [Pokemon] = []

    @State private var cancellables = Set<AnyCancellable>()

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ScrollView {
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()), GridItem(.flexible()),
                        ], spacing: 16
                    ) {
                        ForEach(filteredAndSortedPokemon, id: \.id) { pokemon in
                            EntradaPokedexView(pokemon: pokemon, teamId: teamId)
                                .onAppear {
                                    if let lastPokemon =
                                        filteredAndSortedPokemon.last,
                                        lastPokemon.id == pokemon.id
                                            && hasMorePokemon
                                            && !filteredAndSortedPokemon.isEmpty
                                    {
                                        loadMorePokemon()
                                    }
                                }
                        }
                    }
                    .padding()
                }
                .edgesIgnoringSafeArea(.bottom)
                .background(
                    Color(
                        red: 0.7529411764705882, green: 0.8588235294117647,
                        blue: 0.8588235294117647))
            }

            if isLoading {
                ProgressView()
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
        .onAppear {
//            print(
//                "ListaPokedexView.onAppear - Iniciando carga inicial de Pokémon"
//            )
            loadInitialPokemon()
        }
        .onChange(of: filterState.isAscending) { _ in
            //            print("ListaPokedexView.onChange - Ordenación ascendente/descendente cambiada")
            applyFiltersAndSort()
        }
        .onChange(of: filterState.selectedTypes) { _ in
            //            print("ListaPokedexView.onChange - Tipos seleccionados cambiados")
            applyFiltersAndSort()
        }
        .onChange(of: filterState.showFavorites) { _ in
            //            print("ListaPokedexView.onChange - Mostrar favoritos cambiado")
            applyFiltersAndSort()
        }
        .onChange(of: filterState.showLegendaries) { _ in
            //            print("ListaPokedexView.onChange - Mostrar legendarios cambiado")
            applyFiltersAndSort()
        }
        .onChange(of: filterState.showSingulares) { _ in
            //            print("ListaPokedexView.onChange - Mostrar singulares cambiado")
            applyFiltersAndSort()
        }
        .onChange(of: filterState.search) { _ in
            //            print("ListaPokedexView.onChange - Búsqueda cambiada")
            applyFiltersAndSort()
        }
        .onChange(of: filterState.selectedFilters) { _ in
            //            print("ListaPokedexView.onChange - Filtros seleccionados cambiados")
            applyFiltersAndSort()
        }
        .onChange(of: filterState.selectedRegions) { _ in
            //            print("ListaPokedexView.onChange - Regiones seleccionadas cambiadas")
            isLoading = false  // Restablece isLoading aquí para permitir una nueva carga
            applyFiltersAndSort()
        }
        .onChange(of: pokemones) { _ in
            //             print("ListaPokedexView.onChange - Lista de pokemons generales actualizada. Pokemons: \(pokemones.count)")
            applyFiltersAndSort()
        }
    }

    private func applyFiltersAndSort() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        let filteredPokemons = pokemonViewModel.applyFiltersAndSort(
            pokemons: pokemones, filterState: filterState, viewModel: viewModel)
        self.filteredAndSortedPokemon = filteredPokemons
//        print("LENGTH FILTERED POKEMON: \(filteredAndSortedPokemon.count)")

        if filteredAndSortedPokemon.count < 10 && hasMorePokemon && !isLoading
        {  // Mantén la lógica de carga si la lista es pequeña
            loadMorePokemon()
            applyFiltersAndSort()
        }
    }

    private func loadInitialPokemon() {
        loadPokemon(startId: 1, count: 100)
    }

    private func loadMorePokemon() -> Future<[Pokemon], Error> {
        let nextStartId = pokemones.count + 1
        return loadPokemon(startId: nextStartId, count: 100)
    }

    private func loadPokemon(startId: Int, count: Int) -> Future<
        [Pokemon], Error
    > {
        //           print("ListaPokedexView.loadPokemon - Iniciando carga de Pokémon desde \(startId) hasta \(startId + count - 1)")
        return Future { promise in
            guard !isLoading && hasMorePokemon else {
                //                   print("ListaPokedexView.loadPokemon - No se cumplen las condiciones (isLoading: \(isLoading), hasMorePokemon: \(hasMorePokemon)) para cargar Pokémon.")
                promise(.success([]))
                return
            }

            //                print("ListaPokedexView.loadPokemon - Estableciendo isLoading = true. Cargando pokemons")
            isLoading = true
            errorMessage = nil

            let group = DispatchGroup()
            var newPokemon: [Pokemon] = []

            for i in startId...(startId + count - 1) {
                group.enter()
                //                   print("ListaPokedexView.loadPokemon - Solicitando detalles del Pokémon \(i)")
                pokemonViewModel.fetchPokemonDetails(id: "\(i)") { result in
                    defer { group.leave() }

                    switch result {
                    case .success(let details):
                        newPokemon.append(details)
                    case .failure(let error):
                        //                           print("ListaPokedexView.loadPokemon - Error al obtener detalles del Pokémon \(i): \(error)")
                        if error.localizedDescription.contains(
                            "The operation couldn't be completed")
                        {
                            hasMorePokemon = false
                        }
                    }
                }
            }

            group.notify(queue: .main) {
                //                   print("ListaPokedexView.loadPokemon - Finalizada la carga de pokemons. Añadiendo nuevos pokemons y estableciendo isLoading = false")
                self.pokemones.append(contentsOf: newPokemon)
                self.isLoading = false

                if newPokemon.isEmpty {
                    self.hasMorePokemon = false
//                    print("ListaPokedexView.loadPokemon - La carga devolvio vacía. No hay mas pokemons por cargar.")
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
