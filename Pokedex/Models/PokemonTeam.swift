import Foundation
import SwiftUI

struct Team: Identifiable {
    let id = UUID()
    let name: String
    var pokemons: [Pokemon]
}

class PokemonTeam: ObservableObject {
    static let shared = PokemonTeam() // Singleton instance
    
    @Published private var teams: [Team] = []
    
    private init() {} // Private initializer for Singleton
    
    func createTeam(name: String) {
        let newTeam = Team(name: name, pokemons: [])
        teams.append(newTeam)
    }
    
    func addPokemon(_ pokemon: Pokemon, to teamName: String) {
        if let index = teams.firstIndex(where: { $0.name == teamName }) {
            if (teams[index].pokemons.count < 3){
                teams[index].pokemons.append(pokemon)
            }
        }
    }
    
    func getTeam(named teamName: String) -> Team? {
        return teams.first(where: { $0.name == teamName })
    }
    
    func getAllTeams() -> [Team] {
        return teams
    }
    
    func removeTeam(named teamName: String) {
        teams.removeAll(where: { $0.name == teamName })
    }
    
    func updateTeamName(_ oldName: String, to newName: String) {
        if let index = teams.firstIndex(where: { $0.name == oldName }) {
            teams[index] = Team(name: newName, pokemons: teams[index].pokemons)
        }
    }
    
    func removeAllTeams() {
        teams.removeAll()
    }
}


