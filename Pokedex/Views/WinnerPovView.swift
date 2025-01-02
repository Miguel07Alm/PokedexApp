import SwiftUI
import SDWebImageSwiftUI

struct WinnerPovView: View {
    @StateObject private var pokemonTeam = PokemonTeam.shared
    @State var teamId: Int
    
    var body: some View {
        VStack {
            Text("").frame(height: 50)
            let team = pokemonTeam.getTeam(named: teamId == 1 ? "Equipo1" : "Equipo2")
            Text("¡HA GANADO EL \(team!.name.uppercased())!").font(.title)
            Image("trofeo").resizable().frame(width: 150, height: 150)
            HStack(spacing: 1){
                let pos = sortPokemonPositions()
                WinnerPokemonDisplay(team: team!, pos: pos[1], posMaxDmg: pos[0], color: Color(red: 0.203, green: 0.62, blue: 0.218))
                WinnerPokemonDisplay(team: team!, pos: pos[0], posMaxDmg: pos[0], color: Color(hue: 1.0, saturation: 0.724, brightness: 0.752))
                WinnerPokemonDisplay(team: team!, pos: pos[2], posMaxDmg: pos[0], color: Color(hue: 0.552, saturation: 0.744, brightness: 0.564))
            }.offset(y: -15)
            DisplayCard(msg: "HP Restante: \(team!.health)", color: Color(red: 0.92, green: 0.92, blue: 0.92)).frame(width: 350, height: 70).font(.system(size: 22)).offset(y: -15)
            Text("") //empuja el footer
            Text("")
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
    
    private var barHeight: CGFloat {
        return 190 * (CGFloat(team.pokeDamage[pos]) / CGFloat(team.pokeDamage[posMaxDmg]))
    }
    
    var body: some View {
        let dmg = team.pokeDamage[pos]
        ZStack {
            VStack {
                Spacer()
                Bar3DView(currPtos: dmg, maxPtos: team.pokeDamage[posMaxDmg], color: color)
                DisplayCard(msg: team.pokemons[pos]!.name, color: color).frame(width: 120, height: 30)
            }
            VStack {
                DisplayCard(msg: "\(dmg)", color: Color(red: 0.92, green: 0.92, blue: 0.92)).frame(width: 50, height: 30).offset(y: -10)
                WebImage(url: URL(string: team.pokemons[pos]?.sprites.other?.showdown?.frontDefault ?? "")!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            }.offset(y:CGFloat(-barHeight - 16 / 2) + CGFloat(105))
        }.frame(alignment: .bottomLeading)
    }
}
    
struct Bar3DView: View {
    let currPtos: Int
    let maxPtos: Int
    let color : Color
    let maxHeight: CGFloat = 190 // Altura máxima fija
    
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
            .fill(color.opacity(0.6)).offset(y: -(maxHeight - barHeight))
            // Cara superior (para efecto 3D)
            Path { path in
                path.move(to: CGPoint(x: 7, y: maxHeight - barHeight))  // Comienza en la altura de la barra
                path.addLine(to: CGPoint(x: 22, y: maxHeight - barHeight - 16))  // Diagonal hacia arriba
                path.addLine(to: CGPoint(x: 102, y: maxHeight - barHeight - 16))  // Línea horizontal
                path.addLine(to: CGPoint(x: 87, y: maxHeight - barHeight))  // Cierra el path
            }
            .fill(color.opacity(0.8)).offset(y: -(maxHeight - barHeight) )
        }
        .frame(width: 95, height:  barHeight, alignment: .bottomLeading).offset(x: -5)  // Ajustado al nuevo ancho total
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
    //Image("trofeo").resizable().frame(width: 250, height: 250)
    Bar3DView(currPtos: 72, maxPtos: 100, color: Color(hue: 0.552, saturation: 0.744, brightness: 0.564))
    
   // DisplayCard(msg: "crabominable", color: Color(red: 0.7333333333333333, green: 0.5176470588235295, blue: 0.5176470588235295)) .frame(width: 120, height: 30)
}

