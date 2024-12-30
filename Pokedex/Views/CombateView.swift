import SwiftUI
import SDWebImageSwiftUI

struct CombateView: View {
    @StateObject private var pokemonTeam = PokemonTeam.shared
    @StateObject var pokemonViewModel = PokemonViewModel()

    var body: some View {
        
        ZStack{
            Color(red: 0.7529411764705882, green: 0.8588235294117647, blue: 0.8588235294117647)
                .ignoresSafeArea()

            Image("RingCombate").resizable().frame(width: 400, height: 400)
            VStack(spacing: 50) {
                teamView(teamId: 1)
                teamView(teamId: 2)
            }
        }
    }
   
    
    private func atacar(teamId: Int) -> some View {
        HStack(spacing: 25) {
            let name = teamId == 1 ? "Equipo1" : "Equipo2"
            ForEach(0..<3, id: \.self) { i in
                if let team = pokemonTeam.getTeam(named: name),
                   let poke = team.pokemons[i] {
                    let randMove = Int.random(in: 0...poke.moves.count)
                   // poke.moves[randMove].move.url
                    
                }
            }
        }
    }
    
    private func queryMoves(id : Int){
        pokemonViewModel.fetchPokemonDetails(id: 25) { result in
                        switch result {
                        case .success(let details):
                            DispatchQueue.main.async {
                               // self.selectedPokemon = details // Actualiza el estado
                            }
                        case .failure(let error):
                            print("Error fetching details: \(error)")
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
