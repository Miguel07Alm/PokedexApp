import Foundation
enum PokemonSortOption {
    case id
    case name
    case type
    case height
    case weight
}

// Create a struct for filter options
struct PokemonFilters {
    var searchText: String = ""
    var selectedTypes: Set<String> = []
    var minWeight: Double?
    var maxWeight: Double?
    var minHeight: Double?
    var maxHeight: Double?
    var sortOption: PokemonSortOption = .id
    var ascending: Bool = true
}
class PokemonFilterState: ObservableObject {
    @Published var selectedSort: String = "alfabeticamente"
    @Published var isAscending: Bool = true
    @Published var selectedTypes: Set<String> = []
    @Published var showFavorites: Bool = false
    @Published var showLegendaries: Bool = false
    @Published var showSingulares: Bool = false
}
class PokemonViewModel: ObservableObject {
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    func applyFiltersAndSort(pokemons: [Pokemon], filterState: PokemonFilterState) -> [Pokemon] {
            var filteredPokemons = pokemons
            
            // Apply filters
            filteredPokemons = filterPokemon(
                filteredPokemons,
                selectedTypes: filterState.selectedTypes,
                showFavorites: filterState.showFavorites,
                showLegendaries: filterState.showLegendaries,
                showSingulares: filterState.showSingulares
            )
            
            // Apply sorting
            return sortPokemon(
                filteredPokemons,
                by: filterState.selectedSort,
                ascending: filterState.isAscending
            )
        }
    func sortPokemon(_ pokemons: [Pokemon], by sortOption: String, ascending: Bool) -> [Pokemon] {
            switch sortOption.lowercased() {
            case "alfabeticamente":
                return pokemons.sorted { p1, p2 in
                    ascending ? p1.name < p2.name : p1.name > p2.name
                }
                
            case "n° pokedex":
                return pokemons.sorted { p1, p2 in
                    ascending ? p1.id < p2.id : p1.id > p2.id
                }
                
            case "ataque":
                return pokemons.sorted { p1, p2 in
                    let attack1 = p1.stats.first { $0.stat.name == "attack" }?.baseStat ?? 0
                    let attack2 = p2.stats.first { $0.stat.name == "attack" }?.baseStat ?? 0
                    return ascending ? attack1 < attack2 : attack1 > attack2
                }
                
            case "ataque especial":
                return pokemons.sorted { p1, p2 in
                    let spAtk1 = p1.stats.first { $0.stat.name == "special-attack" }?.baseStat ?? 0
                    let spAtk2 = p2.stats.first { $0.stat.name == "special-attack" }?.baseStat ?? 0
                    return ascending ? spAtk1 < spAtk2 : spAtk1 > spAtk2
                }
                
            case "vida":
                return pokemons.sorted { p1, p2 in
                    let hp1 = p1.stats.first { $0.stat.name == "hp" }?.baseStat ?? 0
                    let hp2 = p2.stats.first { $0.stat.name == "hp" }?.baseStat ?? 0
                    return ascending ? hp1 < hp2 : hp1 > hp2
                }
                
            case "defensa":
                return pokemons.sorted { p1, p2 in
                    let defense1 = p1.stats.first { $0.stat.name == "defense" }?.baseStat ?? 0
                    let defense2 = p2.stats.first { $0.stat.name == "defense" }?.baseStat ?? 0
                    return ascending ? defense1 < defense2 : defense1 > defense2
                }
                
            case "defensa especial":
                return pokemons.sorted { p1, p2 in
                    let spDef1 = p1.stats.first { $0.stat.name == "special-defense" }?.baseStat ?? 0
                    let spDef2 = p2.stats.first { $0.stat.name == "special-defense" }?.baseStat ?? 0
                    return ascending ? spDef1 < spDef2 : spDef1 > spDef2
                }
                
            case "velocidad":
                return pokemons.sorted { p1, p2 in
                    let speed1 = p1.stats.first { $0.stat.name == "speed" }?.baseStat ?? 0
                    let speed2 = p2.stats.first { $0.stat.name == "speed" }?.baseStat ?? 0
                    return ascending ? speed1 < speed2 : speed1 > speed2
                }
                
            default:
                return pokemons
            }
        }
        
        // Function to handle all filtering options
        func filterPokemon(_ pokemons: [Pokemon], selectedTypes: Set<String>, showFavorites: Bool = false, showLegendaries: Bool = false, showSingulares: Bool = false) -> [Pokemon] {
            var filteredPokemon = pokemons
            
            if !selectedTypes.isEmpty {
                filteredPokemon = filteredPokemon.filter { pokemon in
                    let pokemonTypes = pokemon.types.map { $0.type.name.lowercased() }
                    // Verifica que el Pokémon tenga los mismos o menos tipos que los seleccionados
                    let matchingTypes = selectedTypes.filter { pokemonTypes.contains($0) }
                    return matchingTypes.count == selectedTypes.count && pokemonTypes.count <= 2
                }
            }
            
            // Filter favorites (you'll need to implement a way to track favorites)
            // TODO: AQUI ANASS IMPLEMENTA LOS FAVORITOS
            if showFavorites {
                filteredPokemon = filteredPokemon.filter { pokemon in
                    // Implement your favorite checking logic here
                    // For example: UserDefaults.standard.bool(forKey: "favorite_\(pokemon.id)")
                    return true
                }
            }
            
            // Filter legendaries (you might want to have a list of legendary Pokémon IDs)
            if showLegendaries {
                let legendaryIds = Set([144, 145, 146, 150, 151, 243, 244, 245, 249, 250, 251]) // Add more as needed
                filteredPokemon = filteredPokemon.filter { legendaryIds.contains($0.id) }
            }
            
            // Filter singulares (implement your criteria for singular Pokémon)
            if showSingulares {
                // Implement your singular Pokémon filtering logic here
                filteredPokemon = filteredPokemon.filter { pokemon in
                    // Add your criteria for singular Pokémon
                    return true
                }
            }
            
            return filteredPokemon
        }
    func fetchPokemonDetails(id: Int, completion: @escaping (Result<Pokemon, Error>) -> Void) {
        let urlStr = "https://pokeapi.co/api/v2/pokemon/\(id)"
        
        guard let url = URL(string: urlStr) else {
            completion(.failure(NetworkError.badURL))
            return
        }
        
        self.session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(error ?? NetworkError.badData))
                return
            }
            
            do {
                let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)
                completion(.success(pokemon))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    func fetchPokemonSpecies(id: Int, completion: @escaping (Result<PokemonSpecies, Error>) -> Void) {
        let urlStr = "https://pokeapi.co/api/v2/pokemon-species/\(id)"
        
        guard let url = URL(string: urlStr) else {
            completion(.failure(NetworkError.badURL))
            return
        }
        
        self.session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(error ?? NetworkError.badData))
                return
            }
            
            do {
                let pokemon = try JSONDecoder().decode(PokemonSpecies.self, from: data)
                completion(.success(pokemon))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    func fetchPokemonEvolutionChain(id: Int, completion: @escaping (Result<PokemonEvolutionChain, Error>) -> Void) {
        let urlStr = "https://pokeapi.co/api/v2/evolution-chain/\(id)"
        
        guard let url = URL(string: urlStr) else {
            completion(.failure(NetworkError.badURL))
            return
        }
        
        self.session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(error ?? NetworkError.badData))
                return
            }
            
            do {
                let pokemon = try JSONDecoder().decode(PokemonEvolutionChain.self, from: data)
                completion(.success(pokemon))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchAbilityInfo(name: String, completion: @escaping (Result<AbilityData, Error>) -> Void) {
        let urlStr = "https://pokeapi.co/api/v2/ability/\(name)"
        
        guard let url = URL(string: urlStr) else {
            completion(.failure(NetworkError.badURL))
            return
        }
        
        self.session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(error ?? NetworkError.badData))
                return
            }
            
            do {
                let speciesDetails = try JSONDecoder().decode(AbilityData.self, from: data)
                completion(.success(speciesDetails))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
}

enum NetworkError: Error {
    case badData
    case badURL
    case other(Error)
}
