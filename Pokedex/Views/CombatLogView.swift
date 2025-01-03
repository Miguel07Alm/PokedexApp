import SwiftUI

struct CombatLogView: View {
    let messages: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Registro de Combate")
                .font(.headline)
                .padding(.bottom, 4)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(messages.indices, id: \.self) { index in
                        let message = messages[index]
                        if message.contains("Turno") {
                            Text(message)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                        } else if message.contains("Comienza atacando") {
                            Text(message)
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(Color(red: 0.4, green: 0.6, blue: 1.0))
                        } else if message.contains("usa") {
                            formatMoveMessage(message)
                        } else if message.contains("¡El ataque falló!") || message.contains("derrotado") {
                            Text(message)
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.red)
                        } else if message.contains("¡El ataque fue exitoso!") {
                            Text(message)
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.green)
                        } else if message.contains("Daño total") {
                            formatTotalDamageMessage(message)
                        } else if message.contains("Precisión:") {
                            formatPrecisionAndDamageMessage(message)
                        } else {
                            Text(message)
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(Color(hue: 0.611, saturation: 0.0, brightness: 0.091))
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: 400)
            .background(Color.white.opacity(0.9))
            .cornerRadius(12)
            .padding(8)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(16)
    }
    
    private func formatMoveMessage(_ message: String) -> some View {
        let parts = message.split(separator: " ")
        
        return HStack(spacing: 4) {
            ForEach(parts.indices, id: \.self) { index in
                if index == 0 { // Nombre del Pokémon
                    Text(String(parts[index]))
                        .foregroundColor(Color(hue: 0.611, saturation: 0.824, brightness: 0.86))
                        .font(.system(.body, design: .monospaced))
                } else if index == 2 { // Nombre del movimiento
                    Text(String(parts[index]))
                        .foregroundColor(.purple)
                        .font(.system(.body, design: .monospaced))
                } else {
                    Text(String(parts[index]))
                        .foregroundColor(Color(hue: 0.611, saturation: 0.0, brightness: 0.091))
                        .font(.system(.body, design: .monospaced))
                }
                if index < parts.count - 1 {
                    Text(" ")
                        .font(.system(.body, design: .monospaced))
                }
            }
        }
    }
    
    private func formatPrecisionAndDamageMessage(_ message: String) -> some View {
        let parts = message.split(separator: " | ")
        
        return HStack(spacing: 4) {
            // Precisión
            if let precisionPart = parts.first {
                let precisionStr = precisionPart.split(separator: ": ")[1]
                if let precision = Int(precisionStr) {
                    Text("Precisión: ")
                        .foregroundColor(Color(hue: 0.611, saturation: 0.0, brightness: 0.091))
                        .font(.system(.body, design: .monospaced))
                    Text("\(precision)")
                        .foregroundColor(precisionColor(precision))
                        .font(.system(.body, design: .monospaced))
                }
            }
            
            Text(" | ")
                .foregroundColor(Color(hue: 0.611, saturation: 0.0, brightness: 0.091))
                .font(.system(.body, design: .monospaced))
            
            // Daño
            if parts.count > 1 {
                let damagePart = parts[1]
                let damageStr = damagePart.split(separator: ": ")[1]
                if let damage = Int(damageStr) {
                    Text("Daño: ")
                        .foregroundColor(Color(hue: 0.611, saturation: 0.0, brightness: 0.091))
                        .font(.system(.body, design: .monospaced))
                    Text("\(damage)")
                        .foregroundColor(damageColor(damage))
                        .font(.system(.body, design: .monospaced))
                }
            }
        }
    }
    
    private func formatTotalDamageMessage(_ message: String) -> some View {
        let parts = message.split(separator: ": ")
        return HStack(spacing: 4) {
            Text(String(parts[0]) + ": ")
                .foregroundColor(Color(hue: 0.611, saturation: 0.0, brightness: 0.091))
                .font(.system(.body, design: .monospaced))
            if let damage = Int(parts[1]) {
                Text("\(damage)")
                    .foregroundColor(totalDamageColor(damage))
                    .font(.system(.body, design: .monospaced))
            }
        }
    }
    
    private func precisionColor(_ precision: Int) -> Color {
        // Normalizar el valor entre 30 y 100
        let clampedPrecision = min(max(precision, 30), 100)
        let normalizedPrecision = (Double(clampedPrecision) - 30.0) / (100.0 - 30.0)
        
        return Color(
            red: 1.0 - normalizedPrecision,  // Rojo disminuye con mayor precisión
            green: normalizedPrecision,     // Verde aumenta con mayor precisión
            blue: 0.0                       // Azul siempre es 0
        )
    }
    
    
    private func damageColor(_ damage: Int) -> Color {
        let clampedDamage = max(damage, 30)  // Mínimo 30
        let normalizedDamage = Double(min(clampedDamage, 150)) / 150.0
        return Color(
            red: 1.0,                         // Siempre rojo máximo
            green: 1.0 - normalizedDamage,    // Verde disminuye con más daño
            blue: 0.0                         // Azul siempre 0
        )
    }
    
    private func totalDamageColor(_ damage: Int) -> Color {
        let clampedDamage = max(damage, 100) // Mínimo 100
        let normalizedDamage = Double(min(clampedDamage, 400)) / 400.0
        return Color(
            red: 1.0,                         // Siempre rojo máximo
            green: 1.0 - normalizedDamage,    // Verde disminuye con más daño total
            blue: 0.0                         // Azul siempre 0
        )
    }
}

#Preview {
    CombatLogView(messages: ["get cemelmaned"])
}
