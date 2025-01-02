import SwiftUI
import SDWebImageSwiftUI

struct WinnerPovView: View {
    @StateObject private var pokemonTeam = PokemonTeam.shared
    @State var teamId: Int
    
    var body: some View {
        return HStack(spacing: -20){
            let team = pokemonTeam.getTeam(named: teamId == 1 ? "Equipo1" : "Equipo2")
            let pos = sortPokemonPositions()
            WinnerPokemonDisplay(team: team!, pos: pos[1], posMaxDmg: pos[0])
            WinnerPokemonDisplay(team: team!, pos: pos[0], posMaxDmg: pos[0])
            WinnerPokemonDisplay(team: team!, pos: pos[2], posMaxDmg: pos[0])
        }
        .background(Color(red: 0.7529411764705882, green: 0.8588235294117647, blue: 0.8588235294117647))
        .ignoresSafeArea()
    }
    
    private func sortPokemonPositions() -> [Int] {
        var pos: [Int] = [0, -1, -1]
        let name = teamId == 1 ? "Equipo1" : "Equipo2"
        guard let team = pokemonTeam.getTeam(named: name) else { return [0,0,0] }
        
        for i in 1..<3 {
            let dmg = team.pokeDamage[i]
            if dmg > team.pokeDamage[pos[0]]{
                pos[2] = pos[1]
                pos[1] = pos[0]
                pos[0] = i
                print(pos[0])
            } else if pos[1] == -1 || dmg > team.pokeDamage[pos[1]]{
                pos[2] = pos[1]
                pos[1] = i
                print(pos[1])
            } else if pos[2] == -1 {
                pos[2] = i
                print(pos[2])
            }
        }
        print(pos)
        return pos
    }
}

struct WinnerPokemonDisplay: View {
    @StateObject private var pokemonTeam = PokemonTeam.shared
    @State var team : Team
    @State var pos : Int
    @State var posMaxDmg : Int
    var body: some View {
        VStack {
            WebImage(url: URL(string: team.pokemons[pos]?.sprites.other?.showdown?.frontDefault ?? "")!)
                .resizable()
                .scaledToFit()
                .cornerRadius(20)
                .padding()
            
            let dmg = team.pokeDamage[pos]
            Text("\(dmg)")
            Bar3DView(currPtos: dmg, maxPtos: team.pokeDamage[posMaxDmg])
        }.frame(height: 525)
    }
}
    
struct Bar3DView: View {
    let currPtos: Int
    let maxPtos: Int
    let maxHeight: CGFloat = 200 // Altura máxima fija
    
    private var barHeight: CGFloat {
        return maxHeight * (CGFloat(currPtos) / CGFloat(maxPtos))
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Cara frontal
            Rectangle()
                .fill(Color.red)
                .frame(width: 80, height: barHeight)
            
            // Cara lateral derecha (para efecto 3D)
            Path { path in
                path.move(to: CGPoint(x: 87, y: maxHeight))  // Comienza desde el suelo, alineado con el borde derecho del rectángulo
                path.addLine(to: CGPoint(x: 102, y: maxHeight - 16))  // 15 pixels arriba en diagonal
                path.addLine(to: CGPoint(x: 102, y: maxHeight - barHeight - 16))  // Sube hasta la altura de la barra
                path.addLine(to: CGPoint(x: 87, y: maxHeight - barHeight))  // Conecta con la barra
            }
            .fill(Color.red.opacity(0.6))
            
            // Cara superior (para efecto 3D)
            Path { path in
                path.move(to: CGPoint(x: 7, y: maxHeight - barHeight))  // Comienza en la altura de la barra
                path.addLine(to: CGPoint(x: 22, y: maxHeight - barHeight - 16))  // Diagonal hacia arriba
                path.addLine(to: CGPoint(x: 102, y: maxHeight - barHeight - 16))  // Línea horizontal
                path.addLine(to: CGPoint(x: 87, y: maxHeight - barHeight))  // Cierra el path
            }
            .fill(Color.red.opacity(0.8))
        }
        .frame(width: 95, height: maxHeight)  // Ajustado al nuevo ancho total
    }
}

#Preview {
    Bar3DView(currPtos: 0, maxPtos: 100)
}

