import Foundation
import UIKit
import SwiftUI

struct PokemonType {
    let name: String
    
    // Diccionario que asocia el nombre del tipo con la imagen correspondiente
    static let typesToIcon: [String: String] = [
        "Fuego": "fire_icon",
        "Agua": "water_icon",
        "Planta": "grass_icon",
        "Eléctrico": "electric_icon",
        "Hielo": "ice_icon",
        "Lucha": "fighting_icon",
        "Veneno": "poison_icon",
        "Tierra": "ground_icon",
        "Volador": "flying_icon",
        "Psíquico": "psychic_icon",
        "Bicho": "bug_icon",
        "Roca": "rock_icon",
        "Fantasma": "ghost_icon",
        "Dragón": "dragon_icon",
        "Siniestro": "dark_icon",
        "Acero": "steel_icon",
        "Hada": "fairy_icon"
    ]
    
    // Diccionario que asocia el nombre del tipo con su color correspondiente
    static let typesToColor: [String: String] = [
        "Fuego": "#FF9C54",
        "Dragón": "#4F7BE9",
        "Agua": "#4FC1E9",
        "Eléctrico": "#FFD95D",
        "Siniestro": "#595761",
        "Lucha": "#EB6B76",
        "Veneno": "#9B59B6",
        "Tierra": "#D4B887",
        "Volador": "#99C2E9",
        "Psíquico": "#FF79C6",
        "Bicho": "#9BCD50",
        "Roca": "#C5B78C",
        "Fantasma": "#7C62A3",
        "Acero": "#4C91B2",
        "Planta": "#63BB5B",
        "Hielo": "#74CEC0",
        "Hada": "#EC8FE6"
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

