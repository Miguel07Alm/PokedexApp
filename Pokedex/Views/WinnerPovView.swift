import SwiftUI
import SDWebImageSwiftUI

struct WinnerPovView: View {
    @StateObject private var pokemonTeam = PokemonTeam.shared
    @State var teamId: Int
    
    var body: some View {
        VStack{
            let team = pokemonTeam.getTeam(named: teamId == 1 ? "Equipo1" : "Equipo2")
            Text("¡HA GANADO EL \(team!.name.uppercased())!").font(.title)
            HStack(spacing: -20){
                let pos = sortPokemonPositions()
                WinnerPokemonDisplay(team: team!, pos: pos[1], posMaxDmg: pos[0], color: Color(red: 0.3686274509803922, green: 0.6196078431372549, blue: 0.3764705882352941))
                WinnerPokemonDisplay(team: team!, pos: pos[0], posMaxDmg: pos[0], color: Color(red: 0.7333333333333333, green: 0.5176470588235295, blue: 0.5176470588235295))
                WinnerPokemonDisplay(team: team!, pos: pos[2], posMaxDmg: pos[0], color: Color(red: 0.40784313725490196, green: 0.5137254901960784, blue: 0.5411764705882353))
            }
            DisplayCard(msg: "HP Restante: \(team!.health)", color: Color(red: 0.92, green: 0.92, blue: 0.92)).frame(width: 350, height: 100).font(.system(size: 22))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
    @State var color : Color
    var body: some View {
        VStack {
            WebImage(url: URL(string: team.pokemons[pos]?.sprites.other?.showdown?.frontDefault ?? "")!)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .cornerRadius(20)
                .padding()
            
            let dmg = team.pokeDamage[pos]
            DisplayCard(msg: "\(dmg)", color: Color(red: 0.92, green: 0.92, blue: 0.92)).frame(width: 50, height: 30)
            Bar3DView(currPtos: dmg, maxPtos: team.pokeDamage[posMaxDmg], color: color)
            DisplayCard(msg: team.pokemons[pos]!.name, color: color).frame(width: 120, height: 30)
        }
    }
}
    
struct Bar3DView: View {
    let currPtos: Int
    let maxPtos: Int
    let color : Color
    let maxHeight: CGFloat = 200 // Altura máxima fija
    
    private var barHeight: CGFloat {
        return maxHeight * (CGFloat(currPtos) / CGFloat(maxPtos))
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Cara frontal
            Rectangle()
                .fill(color)
                .frame(width: 80, height: barHeight)
            
            // Cara lateral derecha (para efecto 3D)
            Path { path in
                path.move(to: CGPoint(x: 87, y: maxHeight))  // Comienza desde el suelo, alineado con el borde derecho del rectángulo
                path.addLine(to: CGPoint(x: 102, y: maxHeight - 16))  // 15 pixels arriba en diagonal
                path.addLine(to: CGPoint(x: 102, y: maxHeight - barHeight - 16))  // Sube hasta la altura de la barra
                path.addLine(to: CGPoint(x: 87, y: maxHeight - barHeight))  // Conecta con la barra
            }
            .fill(color.opacity(0.6))
            
            // Cara superior (para efecto 3D)
            Path { path in
                path.move(to: CGPoint(x: 7, y: maxHeight - barHeight))  // Comienza en la altura de la barra
                path.addLine(to: CGPoint(x: 22, y: maxHeight - barHeight - 16))  // Diagonal hacia arriba
                path.addLine(to: CGPoint(x: 102, y: maxHeight - barHeight - 16))  // Línea horizontal
                path.addLine(to: CGPoint(x: 87, y: maxHeight - barHeight))  // Cierra el path
            }
            .fill(color.opacity(0.8))
        }
        .frame(width: 95, height: maxHeight).offset(x: -5)  // Ajustado al nuevo ancho total
    }
}

struct DisplayCard: View {
    let msg: String
    let color : Color

    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 25, height: 25)).foregroundStyle(color)
            Text(msg.capitalizedFirstLetter())
        }
    }
}

#Preview {
    Bar3DView(currPtos: 85, maxPtos: 100, color: Color.red)
    DisplayCard(msg: "crabominable", color: Color(red: 0.7333333333333333, green: 0.5176470588235295, blue: 0.5176470588235295)).frame(width: 120, height: 30)
}

