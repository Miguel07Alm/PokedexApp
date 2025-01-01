import Foundation
import SwiftUI

struct Team: Identifiable {
    let id = UUID()
    let name: String
    var pos : Int
    var pokemons: [Pokemon?]
    var pokeDamage: [Int]
    var health : Int
    var maxHealth : Int
}

struct Log: Identifiable {
    let id = UUID()
    let name: String
    var combatLog : [String]
}

class PokemonTeam: ObservableObject {
    static let shared = PokemonTeam() // Singleton instance
    
    @Published private var teams: [Team] = []
    
    @Published private var log: Log = Log(name: "log", combatLog: [])
    private init() {
        removeAllTeams()
        createTeam(name: "Equipo1")
        createTeam(name: "Equipo2")
    }
    
    func createTeam(name: String) {
        let newTeam = Team(name: name, pos: 0, pokemons: [nil, nil, nil], pokeDamage: [0,0,0], health: 0, maxHealth: 0)
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
    
    func getTeamMaxHealth(named teamName: String) -> Int {
        return teams.first(where: { $0.name == teamName })?.maxHealth ?? -1
    }
    
    func getTeamHealth(named teamName: String) -> Int {
        return teams.first(where: { $0.name == teamName })?.health ?? 0
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
    
    func updateMaxHealth(named teamName: String) {
        if let index = teams.firstIndex(where: { $0.name == teamName }) {
            var updatedTeam = teams[index]
            updatedTeam.maxHealth = 0
            for poke in updatedTeam.pokemons.compactMap({ $0 }) {
                updatedTeam.maxHealth += poke.stats[0].baseStat
            }
            teams[index] = updatedTeam
            objectWillChange.send()
        } else {
            print("Team not found: \(teamName)")
        }
    }
    
    func setTeamHealth(named teamName: String, hp: Int) {
        if let index = teams.firstIndex(where: { $0.name == teamName }) {
            teams[index].health = hp
            objectWillChange.send()
        } else {
            print("Team not found: \(teamName)")
        }
    }
    
    func addPokemonDamage(named teamName: String, poke: Pokemon, damage: Int) {
        if let index = teams.firstIndex(where: { $0.name == teamName }) {
            if let pokeIndex = teams[index].pokemons.firstIndex(where: { $0?.id == poke.id }) {
                teams[index].pokeDamage[pokeIndex] += damage
                objectWillChange.send()
            } else {
                print("Pokemon not found in the team")
            }
        } else {
            print("Team not found: \(teamName)")
        }
    }
    
    func clearTeamDamage(named teamName: String) {
        if let index = teams.firstIndex(where: { $0.name == teamName }) {
            teams[index].pokeDamage = [0,0,0]
            objectWillChange.send()
        } else {
            print("Team not found: \(teamName)")
        }
     }
    
    func isFaster(named thisTeamName: String, thanNamed otherTeamName : String) -> Bool{
        var thisVel = 0
        var otherVel = 0
        if let thisIndex = teams.firstIndex(where: { $0.name == thisTeamName }),
           let otherIndex = teams.firstIndex(where: { $0.name == otherTeamName }) {
            let thisTeam = teams[thisIndex]
            var otherTeam = teams[otherIndex]
            for poke in thisTeam.pokemons.compactMap({ $0 }) {
                thisVel += poke.stats[5].baseStat
            }
            for poke in otherTeam.pokemons.compactMap({ $0 }) {
                otherVel += poke.stats[5].baseStat
            }
        } else {
            print("Team not found")
            return false
        }
        
        return ((thisVel > otherVel) ? true : ((thisVel == otherVel) ?  Bool.random() : false))
    }
    
    func addToCombatLog(_ message: String) {
        log.combatLog.append(message)
        if log.combatLog.count > 100 {
           log.combatLog.removeFirst()
        }
        objectWillChange.send()
    }
    
    func clearCombatLog() {
         log.combatLog.removeAll()
         objectWillChange.send()
     }
    
    func getCombatLog() -> [String] {
         return log.combatLog
     }
}

