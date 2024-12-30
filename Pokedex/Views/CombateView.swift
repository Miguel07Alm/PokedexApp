import SwiftUI
import SDWebImageSwiftUI

struct CombateView: View {
    @StateObject private var pokemonTeam = PokemonTeam.shared
    @StateObject var pokemonViewModel = PokemonViewModel()

    var body: some View {
        ZStack {
            Color(red: 0.7529411764705882, green: 0.8588235294117647, blue: 0.8588235294117647)
                .ignoresSafeArea()

            Image("RingCombate").resizable().frame(width: 400, height: 400)
            VStack(spacing: 50) {
                teamView(teamId: 1)
                teamView(teamId: 2)
            }
           
        }
        .onAppear{
            print("team 1: \(pokemonTeam.getTeam(named: "Equipo1")?.pokemons.first??.name ?? "no team")")
            print("team 2: \(pokemonTeam.getTeam(named: "Equipo2")?.pokemons.first??.name ?? "no team")")
        }
    }

    private func atacar(teamId: Int) -> some View {
        HStack(spacing: 25) {
            let name = teamId == 1 ? "Equipo1" : "Equipo2"
            ForEach(0..<3, id: \.self) { i in
                if let team = pokemonTeam.getTeam(named: name),
                   let poke = team.pokemons[i],
                   !poke.moves.isEmpty { // Ensure the pokemon has moves
                    let randMove = Int.random(in: 0..<poke.moves.count)
                    let id = poke.moves[randMove].move.url.split(separator: "/").last
                   MoveDisplay(moveURL:  id.map{ String($0) })
                }
                else{
                    Text("No move available")
                }
            }
        }
    }
    
    private func MoveDisplay(moveURL: String?) -> some View{
        print("Move name: \(moveURL)")
        if let moveURL = moveURL{
            
        
            return  AnyView(Text("\(moveURL)").task {
                    queryMoves(name: moveURL)
             }
            
            
        )
        }
        else{
           return AnyView(Text("No move available"))
        }
    }
    
    
    private func queryMoves(name : String){
        pokemonViewModel.fetchMoveInfoByName(name: name) { result in
            switch result {
            case .success(let details):
                DispatchQueue.main.async {
                   // self.selectedPokemon = details // Actualiza el estado
                    print("Accuracy: \(details.accuracy ?? 0)")
                    print("Name: \(details.name ?? "NoName")")
                    print("Power: \(details.power ?? 0)")
                    print("PP: \(details.pp ?? 0)")
                    print()
                }
            case .failure(let error):
                print("Error fetching details: \(error)")
            }
        }
    }

    private func teamView(teamId: Int) -> some View {
        VStack{
            HStack(spacing: 25) {
                let name = teamId == 1 ? "Equipo1" : "Equipo2"
                ForEach(0..<3, id: \.self) { i in
                    if let team = pokemonTeam.getTeam(named: name),
                       let poke = team.pokemons[i],
                       let sprite = teamId == 1 ? poke.sprites.other?.showdown?.frontDefault : poke.sprites.other?.showdown?.backDefault {
                        PokemonDisplay(img: URL(string: sprite)!)
                    }
                }
            }
             atacar(teamId: teamId)
        }
    }
}


struct PokemonDisplay: View {
    @State var img: URL

    var body: some View {
        VStack{
            WebImage(url: img)
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
