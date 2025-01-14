import Foundation
import SwiftUI

enum PokemonSortOption {
    case id
    case name
    case type
    case height
    case weight
}

class PokemonFilterState: ObservableObject, Equatable {
    static func == (lhs: PokemonFilterState, rhs: PokemonFilterState) -> Bool {
        return lhs.selectedSort == rhs.selectedSort &&
        lhs.isAscending == rhs.isAscending &&
        lhs.selectedTypes == rhs.selectedTypes &&
        lhs.showFavorites == rhs.showFavorites &&
        lhs.showLegendaries == rhs.showLegendaries &&
        lhs.showSingulares == rhs.showSingulares
    }
    func addShowFilters(filter: String) {
        if (selectedFilters.contains(filter)) {
            selectedFilters.remove(filter)
        }
        else {
            selectedFilters.insert(filter)
        }
    }

    @Published var selectedSort: String = "n° pokedex"
    @Published var isAscending: Bool = true
    @Published var selectedTypes: Set<String> = []
    @Published var showFavorites: Bool = false
    @Published var showLegendaries: Bool = false
    @Published var showSingulares: Bool = false
    @Published var selectedFilters: Set<String> = []
    @Published var selectedRegions: Set<String> = []
    @Published var search: String = "";

}
class PokemonViewModel: ObservableObject {
    
    let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func applyFiltersAndSort(pokemons: [Pokemon], filterState: PokemonFilterState, viewModel: ViewModel) -> [Pokemon] {
            var filteredPokemons = pokemons

            // Apply filters
            filteredPokemons = filterPokemon(
                filteredPokemons,
                search: filterState.search,
                selectedTypes: filterState.selectedTypes,
                showFavorites: filterState.showFavorites,
                showLegendaries: filterState.showLegendaries,
                showSingulares: filterState.showSingulares,
                selectedFilters: filterState.selectedFilters,
                selectedRegions: filterState.selectedRegions,
                viewModel: viewModel
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
    func filterPokemon(_ pokemons: [Pokemon], search: String, selectedTypes: Set<String>, showFavorites: Bool = false, showLegendaries: Bool = false, showSingulares: Bool = false, selectedFilters: Set<String>, selectedRegions: Set<String>, viewModel: ViewModel) -> [Pokemon] {
            var filteredPokemon = pokemons

            if !selectedTypes.isEmpty {
                filteredPokemon = filteredPokemon.filter { pokemon in
                    let pokemonTypes = pokemon.types.map { $0.type.name.lowercased() }
                    // Verifica que el Pokémon tenga los mismos o menos tipos que los seleccionados
                    let matchingTypes = selectedTypes.filter { pokemonTypes.contains($0) }
                    return matchingTypes.count == selectedTypes.count && pokemonTypes.count <= 2
                }
            }
        if !selectedRegions.isEmpty {
                  filteredPokemon = filteredPokemon.filter { pokemon in
                      let pokemonRegion = getPokemonRegion(id: pokemon.id)
                      return selectedRegions.contains(pokemonRegion)
                  }
              }

            if showFavorites {
                let pokemonsFavoriteIDs: [Int] = viewModel.getAllFavoritePokemons().map { Int($0.pokedexNumber) }
                filteredPokemon = filteredPokemon.filter { pokemonsFavoriteIDs.contains($0.id) }
            }

            if showLegendaries {
                let legendaryIds: Set<Int> = Set([
                    // Generación I (Kanto)
                    144, 145, 146, 150, 151,
                    // Generación II (Johto)
                    243, 244, 245, 249, 250, 251,
                    // Generación III (Hoenn)
                    377, 378, 379, 380, 381, 382, 383, 384, 385, 386,
                    // Generación IV (Sinnoh)
                    480, 481, 482, 483, 484, 485, 486, 487, 488, 489, 490, 491, 492, 493,
                    // Generación V (Unova)
                    638, 639, 640, 641, 642, 643, 644, 645, 646, 647, 648, 649,
                    // Generación VI (Kalos)
                    716, 717, 718, 719, 720, 721,
                    // Generación VII (Alola)
                    785, 786, 787, 788, 789, 790, 791, 792, 800, 801, 802, 807, 808, 809,
                    //Generacion VIII (Galar)
                    888, 889, 890, 891, 892, 893, 894, 895, 896, 897, 898,
                     // Generación IX (Paldea)
                    905, 956, 957, 958, 959, 960, 1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010, 1011, 1012, 1013, 1014, 1015, 1016, 1017, 1018, 1019, 1020, 1021, 1022, 1023, 1024, 1025
                ])
                filteredPokemon = filteredPokemon.filter { legendaryIds.contains($0.id) }
            }

            if showSingulares {
                let singularIds: Set<Int> = Set([
                          //Singulares y formas alternativas Gen III
                           386,
                            // Singulares y formas alternativas Gen IV
                           487, 492,
                            // Singulares y formas alternativas Gen V
                           641, 642, 645, 647, 648,
                            // Singulares y formas alternativas Gen VI
                           718,
                             // Singulares y formas alternativas Gen VII
                            800, 801, 802, 807, 808, 809,
                            //Singulares y formas alternativas Gen VIII
                           891, 892, 893,
                              //Singulares y formas alternativas Gen IX
                             905, 1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010, 1011, 1012, 1013, 1014, 1015, 1016,
                            1017, 1018, 1019, 1020, 1021, 1022, 1023, 1024, 1025
                       ])
                        filteredPokemon = filteredPokemon.filter { singularIds.contains($0.id) }
            }
            if search.count > 0 {
                let searchLowercased = search.lowercased()
                filteredPokemon = filteredPokemon.filter { pokemon in
                    let pokemonName = pokemon.name.lowercased()
                    return pokemonName.contains(searchLowercased) || searchLowercased.contains(pokemonName)
                }
            }
        //print("LENGTH FILTERED POKEMON: \(filteredPokemon.count)")

            return filteredPokemon
        }
    func getPokemonRegion(id: Int) -> String {
            switch id {
            case 1...151:
                return "Kanto"
            case 152...251:
                return "Johto"
            case 252...386:
                return "Hoenn"
            case 387...493:
                return "Sinnoh"
            case 494...649:
                return "Teselia"
            case 650...721:
                return "Kalos"
            case 722...809:
                return "Alola"
            case 810...898:
                return "Galar"
            case 899...1025:
               return "Paldea"
            default:
                return "Unknown"
            }
        }
    func fetchPokemonDetails(id: String, completion: @escaping (Result<Pokemon, Error>) -> Void) {
        let urlStr = "https://pokeapi.co/api/v2/pokemon/\(id)"

        guard let url = URL(string: urlStr) else {
            completion(.failure(NetworkError.badURL))
            return
        }

        let request = URLRequest(url: url)

        self.session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(NetworkError.other(error)))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.badData))
                return
            }

            // Attempt to decode, handling invalid JSON
            do {
                let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)
                completion(.success(pokemon))
            } catch {
                // Log or handle the decoding error here
                print("Decoding error for Pokemon ID \(id): \(error)")
                completion(.failure(NetworkError.other(error)))
            }
        }.resume()
    }
    func fetchPokemonSpecies(id: Int, completion: @escaping (Result<PokemonSpecies, Error>) -> Void) {
        let urlStr = "https://pokeapi.co/api/v2/pokemon-species/\(id)"

        guard let url = URL(string: urlStr) else {
            completion(.failure(NetworkError.badURL))
            return
        }
        let request = URLRequest(url: url)

        self.session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(NetworkError.other(error)))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.badData))
                return
            }

            do {
               let pokemon = try JSONDecoder().decode(PokemonSpecies.self, from: data)
               completion(.success(pokemon))
            } catch {
                // Log or handle the decoding error here
                print("Decoding error for PokemonSpecies ID \(id): \(error)")
                completion(.failure(NetworkError.other(error)))

            }
        }.resume()
    }

    func fetchPokemonEvolutionChain(id: String, completion: @escaping (Result<PokemonEvolutionChain, Error>) -> Void) {
        print("Hace la petición de la cadena de evoluciones para el ID \(id)")
        let urlStr = "https://pokeapi.co/api/v2/evolution-chain/\(id)"

        guard let url = URL(string: urlStr) else {
            completion(.failure(NetworkError.badURL))
            return
        }
        let request = URLRequest(url: url)

        self.session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(NetworkError.other(error)))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.badData))
                return
            }

            do {
                let pokemon = try JSONDecoder().decode(PokemonEvolutionChain.self, from: data)
                completion(.success(pokemon))
            } catch {
                // Log or handle the decoding error here
                print("Decoding error for Evolution Chain ID \(id): \(error)")
                 completion(.failure(NetworkError.other(error)))
            }
        }.resume()
    }

    func fetchAbilityInfo(name: String, completion: @escaping (Result<AbilityData, Error>) -> Void) {
          let urlStr = "https://pokeapi.co/api/v2/ability/\(name)"

          guard let url = URL(string: urlStr) else {
              completion(.failure(NetworkError.badURL))
              return
          }
        let request = URLRequest(url: url)

          self.session.dataTask(with: request) { data, response, error in
              if let error = error {
                  completion(.failure(NetworkError.other(error)))
                  return
              }

              guard let data = data else {
                  completion(.failure(NetworkError.badData))
                  return
              }

              do {
                  let speciesDetails = try JSONDecoder().decode(AbilityData.self, from: data)
                  completion(.success(speciesDetails))
              } catch {
                  // Log or handle the decoding error here
                    print("Decoding error for ability name \(name): \(error)")
                    completion(.failure(NetworkError.other(error)))
              }
          }.resume()
      }

    func fetchMoveInfoById(id: Int, completion: @escaping (Result<MoveData, Error>) -> Void) {
          let urlStr = "https://pokeapi.co/api/v2/move/\(id)"

          guard let url = URL(string: urlStr) else {
              completion(.failure(NetworkError.badURL))
              return
          }
        let request = URLRequest(url: url)

          self.session.dataTask(with: request) { data, response, error in
              if let error = error {
                  completion(.failure(NetworkError.other(error)))
                  return
              }

              guard let data = data else {
                  completion(.failure(NetworkError.badData))
                  return
              }

              do {
                  let speciesDetails = try JSONDecoder().decode(MoveData.self, from: data)
                  completion(.success(speciesDetails))
              } catch {
                  // Log or handle the decoding error here
                    print("Decoding error for move id \(id): \(error)")
                    completion(.failure(NetworkError.other(error)))
              }
          }.resume()
      }
    func fetchMoveInfoByName(name: String, completion: @escaping (Result<MoveData, Error>) -> Void) {
          let urlStr = "https://pokeapi.co/api/v2/move/\(name)"

          guard let url = URL(string: urlStr) else {
              completion(.failure(NetworkError.badURL))
              return
          }
        let request = URLRequest(url: url)

          self.session.dataTask(with: request) { data, response, error in
              if let error = error {
                  completion(.failure(NetworkError.other(error)))
                  return
              }

              guard let data = data else {
                  completion(.failure(NetworkError.badData))
                  return
              }

              do {
                  let speciesDetails = try JSONDecoder().decode(MoveData.self, from: data)
                  completion(.success(speciesDetails))
              } catch {
                  // Log or handle the decoding error here
                    print("Decoding error for move name \(name): \(error)")
                    completion(.failure(NetworkError.other(error)))
              }
          }.resume()
      }
}

enum NetworkError: Error {
    case badData
    case badURL
    case other(Error)
}
