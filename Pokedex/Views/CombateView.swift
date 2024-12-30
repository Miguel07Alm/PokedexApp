import SwiftUI
import SDWebImageSwiftUI

struct CombateView: View {
    @StateObject private var pokemonTeam = PokemonTeam.shared
    var body: some View {
        ZStack{
            Image("RingCombate").resizable().frame(width: 400, height: 400)
            VStack(spacing: 50) {
                teamView(teamId: 1)
                teamView(teamId: 2)
            }
        }
    }
    
    private func teamView(teamId: Int) -> some View {
        HStack(spacing: 25) {
            let name = teamId == 1 ? "Equipo1" : "Equipo2"
            ForEach(0..<3, id: \.self) { i in
                if let team = pokemonTeam.getTeam(named: name),
                   nil != team.pokemons[i] {
                    let sprite = teamId == 1 ? team.pokemons[i]?.sprites.other?.showdown?.frontDefault : team.pokemons[i]?.sprites.other?.showdown?.backDefault
                    PokemonDisplay(img: (URL(string: sprite ?? ""))!)
                }
            }
        }
    }
}


struct PokemonDisplay: View {
    @State var img: URL
    
    var body: some View {
        VStack{
            WebImage(url: img) // Usamos WebImage para manejar GIFs
                .resizable()
                .scaledToFit()
                .cornerRadius(20)
                .padding()
            
        }
        .frame(width: 90, height: 90)
    }
}

#Preview {
    CombateView()
}
