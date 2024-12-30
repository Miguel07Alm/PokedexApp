import SwiftUI
import SDWebImageSwiftUI

struct CombateView: View {
    @StateObject private var pokemonTeam = PokemonTeam.shared
    @StateObject var pokemonViewModel = PokemonViewModel()
    @State var moveAcc = 0
    @State var movePower = 0
    
    var body: some View {

        ZStack{
            Color(red: 0.7529411764705882, green: 0.8588235294117647, blue: 0.8588235294117647)
                .ignoresSafeArea()
            
            Image("RingCombate").resizable().frame(width: 400, height: 400)
            VStack(spacing: 50) {
                teamView(teamId: 1)
                teamView(teamId: 2)
            }
            
            Button {
                print("MAWUOINDFUHWFUWIJ")
                atacar(teamId: 1)
                atacar(teamId: 2)
            } label: {
                Text("Ti pego")
            }.background(Color.red)
        }

    }
    
    
    private func atacar(teamId: Int) -> some View {
        HStack(spacing: 25) {
            if let team = pokemonTeam.getTeam(named: teamId == 1 ? "Equipo1" : "Equipo2") {
                let teamDamage = team.pokemons.compactMap { poke -> Int? in
                    guard let poke = poke else { return nil }
                    let moveName = randomMove(poke: poke)
                    
                    print("Movimiento: \(moveName)")
                    print("Precisión: \(moveAcc)")
                    print("Daño: \(movePower)")
                    
                    if moveAcc > Int.random(in: 0...99) {
                        print("Movimiento: \(moveName)")
                        print("Precisión: \(moveAcc)")
                        print("Daño: \(movePower)")
                        return movePower
                    } else {
                        print("Movimiento: \(moveName)")
                        print("Precisión: \(moveAcc), FALLO!!!")
                        return 0
                    }
                }.reduce(0, +)
                
                Text("Daño del equipo \(teamId): \(teamDamage)")
            } else {
                Text("Equipo no encontrado")
            }
        }
    }
    
    private func randomMove(poke : Pokemon) -> String{
        let randMove = 0
        repeat{
            let randMove = Int.random(in: 0...poke.moves.count-1)
            queryMoves(name: poke.moves[randMove].move.name);
        }while(movePower == 0 || moveAcc == 0 );
        return poke.moves[randMove].move.name
    }


    
    private func queryMoves(name : String){
        pokemonViewModel.fetchMoveInfoByName(name: name) { result in
                        switch result {
                        case .success(let details):
                            DispatchQueue.main.async {
                                moveAcc = details.accuracy ?? 0
                                movePower = details.power ?? 0
                            }
                        case .failure(let error):
                            print("Error fetching details: \(error)")
                        }
                    }
    }
    
    private func teamView(teamId: Int) -> some View {
           ZStack {
               let name = teamId == 1 ? "Equipo1" : "Equipo2"
               ForEach(0..<3, id: \.self) { i in
                   if let team = pokemonTeam.getTeam(named: name),
                      nil != team.pokemons[i] {
                       let sprite = teamId == 1 ? team.pokemons[i]?.sprites.other?.showdown?.frontDefault : team.pokemons[i]?.sprites.other?.showdown?.backDefault
                       PokemonDisplay(img: (URL(string: sprite ?? ""))!)
                           .offset(
                            x: CGFloat(i - 1) * 45 + (teamId == 1 ? 60 : -60),
                            y: CGFloat(i - 1) * 30 + (teamId == 1 ? 20 : -120)
                           )
                           .zIndex(Double(3 - i))  // Ensure proper layering
                       
                   }
               }
           }
           .frame(width: 200, height: 150)  // Adjust frame to accommodate the diagonal layout
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
        .frame(width: 125, height: 125)
    }
}

#Preview {
    CombateView()
}
