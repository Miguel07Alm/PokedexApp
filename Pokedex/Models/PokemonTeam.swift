import Foundation

struct Team: Identifiable {
    let id: UUID
    var name: String
    var pokemons: [Pokemon]
}

class PokemonTeam {
    static let shared = PokemonTeam() // Singleton instance
    
    private var teams: [Team] = []
    
    private init() {} // Private initializer for Singleton
    
    func createTeam(name: String) -> UUID {
        let newTeam = Team(id: UUID(), name: name, pokemons: [])
        teams.append(newTeam)
        return newTeam.id
    }
    
    func addPokemon(_ pokemon: Pokemon, to teamId: UUID) {
        if let index = teams.firstIndex(where: { $0.id == teamId }) {
            teams[index].pokemons.append(pokemon)
        }
    }
    
    func getTeam(with id: UUID) -> Team? {
        return teams.first(where: { $0.id == id })
    }
    
    func getAllTeams() -> [Team] {
        return teams
    }
    
    func removeTeam(with id: UUID) {
        teams.removeAll(where: { $0.id == id })
    }
    
    func updateTeamName(_ newName: String, for teamId: UUID) {
        if let index = teams.firstIndex(where: { $0.id == teamId }) {
            teams[index].name = newName
        }
    }
}

