import SwiftUI
import SDWebImageSwiftUI

struct WinnerPovView: View {
    @StateObject private var pokemonTeam = PokemonTeam.shared
    @State var teamId: Int
    
    var body: some View {
        return HStack(spacing: 25) {
            let name = teamId == 1 ? "Equipo1" : "Equipo2"
            let team = pokemonTeam.getTeam(named: name)
            let pos = sortPokemonPositions()
            WinnerPokemonDisplay(
                img: URL(string: team?.pokemons[pos[1]]?.sprites.other?.showdown?.frontDefault ?? "")!,
                dmg: team?.pokeDamage[pos[1]] ?? 0
            )
            WinnerPokemonDisplay(
                img: URL(string: team?.pokemons[pos[0]]?.sprites.other?.showdown?.frontDefault ?? "")!,
                dmg: team?.pokeDamage[pos[0]] ?? 0
            )
            WinnerPokemonDisplay(
                img: URL(string: team?.pokemons[pos[2]]?.sprites.other?.showdown?.frontDefault ?? "")!,
                dmg: team?.pokeDamage[pos[2]] ?? 0
            )
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
    @State var img: URL
    @State var dmg: Int
    
    var body: some View {
        VStack {
            WebImage(url: img)
                .resizable()
                .scaledToFit()
                .cornerRadius(20)
                .padding()
            
            Text("\(dmg)")
        }.frame(height: 525)
    }
}
    
#Preview {
    WinnerPovView(teamId: 1)
}

