import Foundation
import SwiftUI

struct PokemonType: Codable, Identifiable {
    let id = UUID()
    let type: PokemonTypeDetails
    
    struct PokemonTypeDetails: Codable {
        let name: String
    }
    
    // Existing dictionaries
    static let typesToIcon: [String: String] = [
        "fire": "fire_icon",
        "water": "water_icon",
        "grass": "grass_icon",
        "electric": "electric_icon",
        "ice": "ice_icon",
        "fighting": "fighting_icon",
        "poison": "poison_icon",
        "ground": "ground_icon",
        "flying": "flying_icon",
        "psychic": "psychic_icon",
        "bug": "bug_icon",
        "rock": "rock_icon",
        "ghost": "ghost_icon",
        "dragon": "dragon_icon",
        "dark": "dark_icon",
        "steel": "steel_icon",
        "fairy": "fairy_icon",
        "normal": "normal_icon"
    ]
    
    static let typesToSpanish: [String: String] = [
        "fire": "Fuego",
        "water": "Agua",
        "grass": "Planta",
        "electric": "Eléctrico",
        "ice": "Hielo",
        "fighting": "Lucha",
        "poison": "Veneno",
        "ground": "Tierra",
        "flying": "Volador",
        "psychic": "Psíquico",
        "bug": "Bicho",
        "rock": "Roca",
        "ghost": "Fantasma",
        "dragon": "Dragón",
        "dark": "Siniestro",
        "steel": "Acero",
        "fairy": "Hada",
        "normal": "Normal"
    ]
    
    static let typesToColor: [String: Color] = [
        "fire": Color(hex: "#FF9C54"),
        "dragon": Color(hex: "#4F7BE9"),
        "water": Color(hex: "#4FC1E9"),
        "electric": Color(hex: "#FFD95D"),
        "dark": Color(hex: "#595761"),
        "fighting": Color(hex: "#EB6B76"),
        "poison": Color(hex: "#9B59B6"),
        "ground": Color(hex: "#D4B887"),
        "flying": Color(hex: "#99C2E9"),
        "psychic": Color(hex: "#FF79C6"),
        "bug": Color(hex: "#9BCD50"),
        "rock": Color(hex: "#C5B78C"),
        "ghost": Color(hex: "#7C62A3"),
        "steel": Color(hex: "#4C91B2"),
        "grass": Color(hex: "#63BB5B"),
        "ice": Color(hex: "#74CEC0"),
        "fairy": Color(hex: "#EC8FE6"),
        "normal": Color(hex: "#919AA2")
    ]
    
    static let typesToIconColor: [String: Color] = [
        "fire": Color(hex: "#FF9741"),
        "dragon": Color(hex: "#006FC9"),
        "water": Color(hex: "#3692DC"),
        "electric": Color(hex: "#FBD100"),
        "dark": Color(hex: "#5B5466"),
        "fighting": Color(hex: "#E0306A"),
        "poison": Color(hex: "#B567CE"),
        "ground": Color(hex: "#E87236"),
        "flying": Color(hex: "#89AAE3"),
        "psychic": Color(hex: "#FF6675"),
        "bug": Color(hex: "#83C300"),
        "rock": Color(hex: "#C8B686"),
        "ghost": Color(hex: "#4C6AB2"),
        "steel": Color(hex: "#5A8EA2"),
        "grass": Color(hex: "#38BF4B"),
        "ice": Color(hex: "#4CD1C0"),
        "fairy": Color(hex: "#FB89EB"),
        "normal": Color(hex: "#919AA2")
    ]
    
    // Updated method to get color for a type
    static func getColor(for type: String) -> Color {
        return typesToColor[type.lowercased()] ?? .gray
    }
    
    // Updated method to get color for a type
    static func getColorIcon(for type: String) -> Color {
        return typesToIconColor[type.lowercased()] ?? .gray
    }
    
    static func getGradient(for types: [String], firstColorProportion: Double = 0.1) -> LinearGradient {
        guard types.count == 2 else {
            // Si no hay exactamente dos tipos, devolvemos un gradiente predeterminado
            return LinearGradient(gradient: Gradient(colors: [.gray, .white]), startPoint: .topLeading, endPoint: .bottomTrailing)
        }
        
        let colors = types.map { getColorIcon(for: $0) }
        
        // Aseguramos que firstColorProportion esté entre 0 y 1
        let proportion = firstColorProportion
        
        return LinearGradient(
            gradient: Gradient(
                stops: [
                    .init(color: colors[0], location: 0),
                    .init(color: colors[1], location: 1)
                ]
            ),
            startPoint: UnitPoint(x: 0, y: 0),
            endPoint: UnitPoint(x: 1 / proportion, y: 1 / proportion)
        )
    }
    
    static func getAveraged() -> Pokemon{
        return  Pokemon(
            abilities: [
                Ability(ability: Species(name: "overgrow", url: ""), isHidden: false, slot: 1),
                Ability(ability: Species(name: "chlorophyll", url: ""), isHidden: true, slot: 3)
            ],
            baseExperience: 64,
            cries: Cries(latest: "bulbasaur_cry", legacy: ""),
            forms: [Species(name: "CMELMAN", url: "")],
            gameIndices: [GameIndex(gameIndex: 1, version: Species(name: "red", url: ""))],
            height: 7,
            heldItems: [],
            id: 0,
            isDefault: true,
            locationAreaEncounters: "",
            moves: [Move(move: Species(name: "tackle", url: ""), versionGroupDetails: [])],
            name: "CMELMAN",
            order: 1,
            pastAbilities: [],
            pastTypes: [],
            species: Species(name: "bulbasaur", url: ""),
            sprites: Sprites(backDefault: nil, backFemale: nil, backShiny: nil, backShinyFemale: nil, frontDefault: nil, frontFemale: nil, frontShiny: nil, frontShinyFemale: nil, other: Other(dreamWorld: DreamWorld(frontDefault: nil, frontFemale: nil), home: Home(frontDefault: nil, frontFemale: nil, frontShiny: nil, frontShinyFemale: nil), officialArtwork: OfficialArtwork(frontDefault: "https://external-preview.redd.it/yEq2rNEa_uklQU2AGaI7hh-wtO0otiS2h04orK0wE7k.png?format=pjpg&auto=webp&s=5c39e0c3965d0a2b7d5b09b1ae6206b9920f337a", frontShiny: nil), showdown: Sprites(backDefault: nil, backFemale: nil, backShiny: nil, backShinyFemale: nil, frontDefault: nil, frontFemale: nil, frontShiny: nil, frontShinyFemale: nil))),
            stats: [
                Stat(baseStat: 45, effort: 0, stat: Species(name: "hp", url: "")),
                Stat(baseStat: 49, effort: 0, stat: Species(name: "attack", url: "")),
                Stat(baseStat: 49, effort: 0, stat: Species(name: "defense", url: ""))
            ],
            types: [
                TypeElement(slot: 1, type: Species(name: "grass", url: "")),
                TypeElement(slot: 2, type: Species(name: "poison", url: ""))
            ],
            weight: 69
        )
    }
}

// Extension for Color to support hex initialization in SwiftUI
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
