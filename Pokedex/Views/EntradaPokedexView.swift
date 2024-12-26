//
//  SwiftUIView.swift
//  PokédexApp
//
//  Created by Aula03 on 12/11/24.
//

import SwiftUI

struct EntradaPokedexView: View {
    @ObservedObject private var pokemonTeam = PokemonTeam.shared
    @State private var pokemon: Pokemon
    @State private var teamId: Int
        
        // Variables de estado derivadas
        @State private var name: String
        @State private var number: String
        @State private var image: String
    @State private var backgroundColor: [String]
        
        init(pokemon: Pokemon, teamId: Int) {
            // Inicializa el objeto completo
            _pokemon = State(initialValue: pokemon)
            
            _teamId = State(initialValue: teamId)
            
            // Inicializa las variables de estado derivadas
            _name = State(initialValue: pokemon.name.capitalizedFirstLetter())
            _number = State(initialValue: String(format: "%04d", pokemon.id))
            _image = State(initialValue: pokemon.sprites.other?.officialArtwork?.frontDefault ?? "")
            _backgroundColor = State(initialValue:[ pokemon.types.first?.type.name ?? "normal",
                pokemon.types.last?.type.name ?? (pokemon.types.first?.type.name ?? "normal")])
        }
    
    var body: some View {
        ZStack {
            ImagenPokemon(img: $image)
            CombinedShape(name: $name, num: $number, backgroundColor: $backgroundColor).opacity(0.9)
        }.onTapGesture {
            if teamId != 0{
                let name = teamId == 1 ? "Equipo1" : "Equipo2"
                print("no pigamo: " + name)
                pokemonTeam.addPokemon(pokemon, to: name, at: 1)
            }else{
                print("fui clicao")
               // NavigationLink(destination: PokemonDetailView()) { EmptyView() }
            }
        }
    }
}
struct ImagenPokemon: View {
    @Binding var img: String
    var body: some View {
        AsyncImage(url: URL(string: img)) { phase in
                    switch phase {
                    case .empty:
                        // Mientras la imagen se carga
                        ProgressView()
                    case .success(let image):
                        // Cuando la imagen se cargó correctamente
                        image
                            .resizable()
                            .scaledToFit()
                    case .failure:
                        // Si hay un error al cargar la imagen
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray)
                    @unknown default:
                        // Fallback para futuros casos
                        EmptyView()
                    }
                }
        .frame(width: 150, height: 150)
        .background(Color(red: 0.9333333333333333, green: 0.9333333333333333, blue: 0.9333333333333333))
        .clipShape(
            .rect(
                topLeadingRadius: 25,
                bottomLeadingRadius: 25,
                bottomTrailingRadius: 25
            )
        )
    }
}


// Línea vertical
struct VerticalLine: View {
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 15))     // Empezamos después del corte
            path.addLine(to: CGPoint(x: 10, y: 0))   // Diagonal superior
            path.addLine(to: CGPoint(x: 10, y: 110)) // Línea vertical derecha
            path.addLine(to: CGPoint(x: 0, y: 110))  // Línea inferior
            path.addLine(to: CGPoint(x: 0, y: 15))   // Cerramos el path
        }
    }
}

// Rectángulo pequeño con corte diagonal
struct SmallRectangle: View {
    @Binding var num: String
    var body: some View {
        ZStack {
            Path { path in
                path.move(to: CGPoint(x: 15, y: 0))  // Empezamos desde el punto después del corte
                path.addLine(to: CGPoint(x: 60, y: 0))  // Línea superior
                path.addLine(to: CGPoint(x: 60, y: 30)) // Lado derecho
                path.addLine(to: CGPoint(x: 0, y: 30))  // Línea inferior
                path.addLine(to: CGPoint(x: 0, y: 15))  // Lado izquierdo
                path.addLine(to: CGPoint(x: 15, y: 0))  // Diagonal para el corte
            }
            
            Text("#\(num)")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color(red: 0.9215686274509803, green: 0.9215686274509803, blue: 0.9215686274509803))
                .offset(x:-40,y:-58)
        }
    }
}

// Forma curva inferior
struct CurvedBottom: View {
    @Binding var name: String
    var body: some View {
        ZStack {
            BottomRoundedRectangle()
                .frame(width: 150, height: 40)
            
            Text(name)
                .font(.system(size: 23, weight: .medium))
                .foregroundColor(Color(red: 0.9333333333333333, green: 0.9333333333333333, blue: 0.9333333333333333))
        }
    }
}

struct BottomRoundedRectangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let cornerRadius: CGFloat = 25
        
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))
        
        path.addArc(
            center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(0),
            endAngle: .degrees(90),
            clockwise: false
        )
        
        path.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY))
        
        path.addArc(
            center: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY - cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(90),
            endAngle: .degrees(180),
            clockwise: false
        )
        
        path.closeSubpath()
        
        return path
    }
}

// Forma completa combinada
struct CombinedShape: View {
    @Binding var name: String
    @Binding var num: String
    @Binding var backgroundColor: [String]
    var body: some View {
        ZStack(alignment: .topLeading) {
            CurvedBottom(name: $name)
                .offset(y: 110)
                .foregroundStyle(PokemonType.getGradient(for: backgroundColor,firstColorProportion: 1))
            
            SmallRectangle(num: $num)
                .offset(x: 80, y: 80)
                .foregroundStyle(PokemonType.getGradient(for: backgroundColor,firstColorProportion: 4))
            
            VerticalLine()
                .offset(x: 140, y: 0)
                .foregroundStyle(PokemonType.getGradient(for: backgroundColor,firstColorProportion: 100))
        }
        .frame(width: 150, height: 150)
    }
}

extension Color {
    static func forType(_ type: String) -> Color {
        switch type {
        case "fire": return Color(hex: "#FF9741")
        case "water": return Color(hex: "#3692DC")
        case "grass": return Color(hex: "#38BF4B")
        case "electric": return Color(hex: "#FBD100")
        case "bug": return Color(hex: "#83C300")
        case "dark": return Color(hex: "#5B5466")
        case "ghost": return Color(hex: "#4C6AB2")
        case "dragon": return Color(hex: "#006FC9")
        case "fairy": return Color(hex: "#FB89EB")
        case "fighting": return Color(hex: "#E0306A")
        case "flying": return Color(hex: "#89AAE3")
        case "ground": return Color(hex: "#E87236")
        case "rock": return Color(hex: "#C8B686")
        case "ice": return Color(hex: "#4CD1C0")
        case "normal": return Color(hex: "#919AA2")
        case "poison": return Color(hex: "#B567CE")
        case "psychic": return Color(hex: "#FF6675")
        case "steel": return Color(hex: "#5A8EA2")
        default: return .black
        }
    }
}

#Preview {
    @State var teamId: Int = 0
    @State var pokemon : Pokemon = PokemonType.getAveraged()
    EntradaPokedexView(pokemon: pokemon, teamId: teamId)
}
