import SwiftUI
import SDWebImageSwiftUI

struct CombateView: View {
    @StateObject private var pokemonTeam = PokemonTeam.shared
    @StateObject var pokemonViewModel = PokemonViewModel()
    @State private var isLoading = false
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
                    Task {
                        await startCombat()
                    }
                } label: {
                    Text(isLoading ? "Cargando..." : "Atacar")
                        .foregroundColor(.white)
                        .padding()
                        .background(isLoading ? Color.gray : Color.red)
                        .cornerRadius(10)
                }
                .disabled(isLoading)
                .padding(.bottom)
                
                CombatLog(title: "Registro de Combate", messages: $combatLog)
                    .padding()
            }
        }
    }
    
    private func addToCombatLog(_ message: String) {
        combatLog.append(message)
        if combatLog.count > 100 {
            combatLog.removeFirst()
        }
    }
    
    private func startCombat() async {
        isLoading = true
        addToCombatLog("¡Comienza el combate!")
        await atacar(teamId: 1)
        await atacar(teamId: 2)
        isLoading = false
    }
    
    private func atacar(teamId: Int) async {
        guard let team = pokemonTeam.getTeam(named: teamId == 1 ? "Equipo1" : "Equipo2") else {
            addToCombatLog("Equipo \(teamId) no encontrado")
            return
        }
        
        var teamDamage = 0
        for poke in team.pokemons.compactMap({ $0 }) {
            let (moveName, moveAcc, movePower) = await randomMove(poke: poke)
            
            addToCombatLog("Pokémon \(poke.name) usa \(moveName)")
            addToCombatLog("Precisión: \(moveAcc) | Daño: \(movePower)")
            
            if moveAcc > Int.random(in: 0...99) {
                teamDamage += movePower
                addToCombatLog("¡El ataque fue exitoso!")
            } else {
                addToCombatLog("¡El ataque falló!")
            }
        }
        addToCombatLog("Daño total del equipo \(teamId): \(teamDamage)")
    }
    
    private func randomMove(poke: Pokemon) async -> (name: String, accuracy: Int, power: Int) {
        var moveName = ""
        var moveAcc = 0
        var movePower = 0
        
        repeat {
            let randMove = Int.random(in: 0..<poke.moves.count)
            moveName = poke.moves[randMove].move.name
            let result = await queryMoves(name: moveName)
            moveAcc = result.accuracy
            movePower = result.power
        } while movePower == 0 || moveAcc == 0
        
        return (moveName, moveAcc, movePower)
    }
    
    private func queryMoves(name: String) async -> (accuracy: Int, power: Int) {
        await withCheckedContinuation { continuation in
            pokemonViewModel.fetchMoveInfoByName(name: name) { result in
                switch result {
                case .success(let details):
                    continuation.resume(returning: (details.accuracy ?? 0, details.power ?? 0))
                case .failure(let error):
                    print("Error fetching details: \(error)")
                    continuation.resume(returning: (0, 0))
                }
            }
        }
    }
    
    private func teamView(teamId: Int) -> some View {
        ZStack {
            let name = teamId == 1 ? "Equipo1" : "Equipo2"
            ForEach(0..<3, id: \.self) { i in
                if let team = pokemonTeam.getTeam(named: name),
                   let pokemon = team.pokemons[i] {
                    let sprite = teamId == 1 ? pokemon.sprites.other?.showdown?.frontDefault : pokemon.sprites.other?.showdown?.backDefault
                    PokemonDisplay(img: URL(string: sprite ?? "")!)
                        .offset(
                            x: CGFloat(i - 1) * 45 + (teamId == 1 ? 60 : -60),
                            y: CGFloat(i - 1) * 30 + (teamId == 1 ? 20 : -120)
                        )
                        .zIndex(Double(3 - i))
                }
            }
        }
        .frame(width: 200, height: 150)
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
    let img: URL
    
    var body: some View {
        VStack {
            WebImage(url: img)
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
