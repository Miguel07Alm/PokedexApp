import Foundation
import UIKit
import SwiftUI

struct PokemonType {
    let name: String
    
    // Diccionario que asocia el nombre del tipo con la imagen correspondiente
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
        "fairy": "fairy_icon"
    ]


    
    // Diccionario que asocia el nombre del tipo con su color correspondiente
    static let typesToColor: [String: String] = [
        "fire": "#FF9C54",
        "dragon": "#4F7BE9",
        "water": "#4FC1E9",
        "electric": "#FFD95D",
        "dark": "#595761",
        "fighting": "#EB6B76",
        "poison": "#9B59B6",
        "ground": "#D4B887",
        "flying": "#99C2E9",
        "psychic": "#FF79C6",
        "bug": "#9BCD50",
        "rock": "#C5B78C",
        "ghost": "#7C62A3",
        "steel": "#4C91B2",
        "grass": "#63BB5B",
        "ice": "#74CEC0",
        "fairy": "#EC8FE6"
    ]


    
    // Método para obtener el color asociado a un tipo
    static func getColor(for type: String) -> UIColor? {
        if let hex = typesToColor[type] {
            return UIColor(hex: hex)
        }
        return nil
    }

    // Método para obtener el gradiente lineal entre los colores de dos tipos
    static func getGradient(for types: [String]) -> LinearGradient {
        guard types.count >= 2,
              let firstType = types.first,
              let secondType = types.last,
              let firstColor = PokemonType.getColor(for: firstType),
              let secondColor = PokemonType.getColor(for: secondType) else {
            if let firstType = types.first, let firstColor = PokemonType.getColor(for: firstType) {
                return LinearGradient(gradient: Gradient(colors: [Color(firstColor)]), startPoint: .top, endPoint: .bottom)
            }
            return LinearGradient(gradient: Gradient(colors: [.gray]), startPoint: .top, endPoint: .bottom) // Fallback color if no valid type is found
        }
        
        let interpolatedColor = PokemonType.interpolateColors(from: firstColor, to: secondColor, ratio: 0.5)
        return LinearGradient(gradient: Gradient(colors: [Color(firstColor), Color(interpolatedColor), Color(secondColor)]), startPoint: .top, endPoint: .bottom)
    }
    
    // Función para interpolar entre dos colores
    static func interpolateColors(from startColor: UIColor, to endColor: UIColor, ratio: CGFloat) -> UIColor {
        var startRed: CGFloat = 0
        var startGreen: CGFloat = 0
        var startBlue: CGFloat = 0
        var startAlpha: CGFloat = 0
        
        var endRed: CGFloat = 0
        var endGreen: CGFloat = 0
        var endBlue: CGFloat = 0
        var endAlpha: CGFloat = 0
        
        startColor.getRed(&startRed, green: &startGreen, blue: &startBlue, alpha: &startAlpha)
        endColor.getRed(&endRed, green: &endGreen, blue: &endBlue, alpha: &endAlpha)
        
        let red = startRed + (endRed - startRed) * ratio
        let green = startGreen + (endGreen - startGreen) * ratio
        let blue = startBlue + (endBlue - startBlue) * ratio
        let alpha = startAlpha + (endAlpha - startAlpha) * ratio
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

// Extensión para convertir colores hexadecimales a UIColor
extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

