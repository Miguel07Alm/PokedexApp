import SwiftUI
import SDWebImageSwiftUI


struct CombateView: View {
    @StateObject private var pokemonTeam = PokemonTeam.shared
    @StateObject var pokemonViewModel = PokemonViewModel()
    @State var moveAcc = 0
    @State var movePower = 0
    @State private var combatLog: [String] = []
    
    var body: some View {
        ZStack {
            Color(red: 0.7529411764705882, green: 0.8588235294117647, blue: 0.8588235294117647)
                .ignoresSafeArea()
            
            VStack {
                ZStack {
                    Image("RingCombate")
                        .resizable()
                        .frame(width: 400, height: 400)
                    
                    VStack(spacing: 50) {
                        teamView(teamId: 1)
                        teamView(teamId: 2)
                    }
                }
                
                Button {
                    addToCombatLog("¡Comienza el combate!")
                    atacar(teamId: 1)
                    atacar(teamId: 2)
                } label: {
                    Text("Atacar")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .padding(.bottom)
                
                CombatLog(title: "Registro de Combate", messages: $combatLog)
                    .padding()
                
                
            }
        }
    }
    
    // Método para añadir mensajes al registro
    private func addToCombatLog(_ message: String) {
        combatLog.append(message)
        
        // Opcional: mantener un límite de mensajes para evitar problemas de memoria
        if combatLog.count > 100 {
            combatLog.removeFirst()
        }
    }
    
    private func atacar(teamId: Int){
             let team = pokemonTeam.getTeam(named: teamId == 1 ? "Equipo1" : "Equipo2")
             var teamDamage = 0
             for poke in team!.pokemons{
                 let moveName = randomMove(poke: poke!)
                 
                 addToCombatLog("Pokémon \(poke!.name) usa \(moveName)")
                 addToCombatLog("Precisión: \(moveAcc) | Daño: \(movePower)")
                 
                 if(moveAcc > Int.random(in: 0...99)){
                     teamDamage = movePower
                 }else{
                     addToCombatLog("¡El ataque falló!")
                 }
             }
             print ("Daño del equipo: ", teamDamage)
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

struct CombatLog: View {
    let title: String
    @Binding var messages: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .padding(.bottom, 4)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(messages.indices, id: \.self) { index in
                        Text(messages[index])
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: 200)
            .background(Color.white.opacity(0.9))
            .cornerRadius(12)
            .padding(8)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(16)
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
