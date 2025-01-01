import SwiftUI
import SDWebImageSwiftUI


struct WinnerPovView: View {
    @ObservedObject private var pokemonTeam = PokemonTeam.shared
    @State var teamId : Int
    var body: some View {
        HStack(spacing: 25) {
            let name = teamId == 1 ? "Equipo1" : "Equipo2"
            let team = pokemonTeam.getTeam(named: name)
            ForEach(0..<3, id: \.self) { i in
                WinnerPokemonDisplay(
                    img: URL(string: team?.pokemons[i]?.sprites.other?.showdown?.frontDefault ?? "")!,
                    dmg: team?.pokeDamage[i] ?? 0
                )
            }
        }.background(Color(red: 0.7529411764705882, green: 0.8588235294117647, blue: 0.8588235294117647))
            .ignoresSafeArea()
    }
}


struct WinnerPokemonDisplay: View {
    @State var img: URL
    @State var dmg: Int
    
    var body: some View {
        VStack{
            WebImage(url: img)
                .resizable()
                .scaledToFit()
                .cornerRadius(20)
                .padding()
            
            Text("\(dmg)")
        }.frame( height: 525)
    }
}

    
#Preview {
    WinnerPovView(teamId: 1)
}
