import Foundation
import SwiftUI

struct Team: Identifiable {
    let id = UUID()
    let name: String
    var pos : Int
    var pokemons: [Pokemon?]
}

class PokemonTeam: ObservableObject {
    static let shared = PokemonTeam() // Singleton instance
    
    @Published private var teams: [Team] = []
    
    private init() {
        removeAllTeams()
        createTeam(name: "Equipo1")
        createTeam(name: "Equipo2")
    }
    
    func createTeam(name: String) {
        let newTeam = Team(name: name, pos: 0, pokemons: [nil, nil, nil])
        teams.append(newTeam)
        print("Team created: \(name)")
    }
    
    func addPokemon(_ pokemon: Pokemon, to teamName: String) {
        let pos = teams.first(where: { $0.name == teamName })?.pos ?? -1
        if let index = teams.firstIndex(where: { $0.name == teamName }){
            teams[index].pokemons[pos] = pokemon
            print("Pokemon added to \(teamName) at position \(pos): \(pokemon.name)")
            objectWillChange.send()
        } else {
            print("Team not found: \(teamName)")
        }
    }
    
    func setTeamPos(named teamName: String, pos: Int) {
        if pos < 0 || pos > 2 {
            print("Invalid position: \(pos)")
            return
        }
        if let index = teams.firstIndex(where: { $0.name == teamName }) {
            teams[index].pos = pos
            objectWillChange.send()
        } else {
            print("Team not found: \(teamName)")
        }
    }
    
    func getTeamPos(named teamName: String) -> Int {
        return teams.first(where: { $0.name == teamName })?.pos ?? -1
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
    
    func removeAllTeams() {
        teams.removeAll()
    }
}

