import Foundation

class PokemonViewModel: ObservableObject {
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
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
