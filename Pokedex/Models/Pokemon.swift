import Foundation
import UIKit
import SwiftUI
struct Pokemon: Identifiable {
    let id = UUID()
    let name: String
    let pokedexNumber: Int
    let imageName: String
    let types: [PokemonType]
    let stats: PokemonStats
    let description: String
    let evolutions: [String]
    
    var typeColor: LinearGradient {
            let typeNames = types.map { $0.name } // Extraemos los nombres de los tipos
        return PokemonType.getGradient(for: typeNames) // Pasamos los nombres de tipo a la función
        }
}

struct PokemonStats {
    let hp: Int
    let attack: Int
    let defense: Int
    let specialAttack: Int
    let specialDefense: Int
    let speed: Int
}
