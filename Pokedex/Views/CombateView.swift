import SwiftUI
import SDWebImageSwiftUI

struct CombateView: View {
    @StateObject private var pokemonTeam = PokemonTeam.shared
    @StateObject var pokemonViewModel = PokemonViewModel()
    @State var isLoading: Bool = false
    @State private var combatLog: [String] = []
    @State var teamHealth: [Int] = [0, 0]
    @State var teamMaxHealth: [Int] = [0, 0]
    @State private var onAttackTapped: (() async -> Void)?
    @StateObject private var refreshManager = RefreshManager.shared

    var body: some View {
        ScrollView {
            VStack {
                HealthBar(maxHealth: teamMaxHealth[0], health: teamHealth[0])
                ZStack {
                    Image("RingCombate")
                        .resizable()
                        .frame(width: 400, height: 400)
                    
                    VStack(spacing: 50) {
                        teamView(teamId: 1)
                        teamView(teamId: 2)
                    }
                }
                HealthBar(maxHealth: teamMaxHealth[1], health: teamHealth[1])
                
                CombatLog(title: "Registro de Combate", messages: combatLog)
                    .padding()
            }
        }
        .background(Color(red: 0.7529411764705882, green: 0.8588235294117647, blue: 0.8588235294117647))
        .ignoresSafeArea()
        .onAppear(perform: updateView)
        .onChange(of: refreshManager.refreshFlag) { _ in
            updateView()
        }
    }
    
    private func updateView() {
            updateHealthBars()
            updateCombatLog()
        }
    
    private func updateHealthBars() { // Update 3
        teamMaxHealth[0] = pokemonTeam.getTeamMaxHealth(named: "Equipo1")
        teamMaxHealth[1] = pokemonTeam.getTeamMaxHealth(named: "Equipo2")
        
        teamHealth[0] = pokemonTeam.getTeamHealth(named: "Equipo1") < 0 ? 0 : pokemonTeam.getTeamHealth(named: "Equipo1")
        
        teamHealth[1] = pokemonTeam.getTeamHealth(named: "Equipo2") < 0 ? 0 : pokemonTeam.getTeamHealth(named: "Equipo2")
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
                        .zIndex(Double(i)) // Cambiado de `3 - i` a `i` para invertir el orden
                }
            }
        }
        .frame(width: 200, height: 150)
    }
    
    private func updateCombatLog() {
        combatLog = pokemonTeam.getCombatLog()
    }
}

struct CombatLog: View {
    let title: String
    let messages: [String]
    
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

struct HealthBar: View {
    let maxHealth: Int
    let health: Int
        
    var body: some View {
        ZStack(alignment: .leading) {
            // Background
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black.opacity(0.6))
                .frame(width: 200, height: 20)
            
            // Health bar
            HStack(spacing: 0) {
                // Red portion (depleted health)
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 200 * CGFloat(maxHealth - health ) / CGFloat(maxHealth))
                
                // Green portion (remaining health)
                Rectangle()
                    .fill(Color.green)
                    .frame(width: 200 * CGFloat(health) / CGFloat(maxHealth))
            }
            .frame(height: 16)
            .padding(.horizontal, 2)
            
            // HP Label
            Text("HP: \(health)/\(maxHealth)")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 6)
        }
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
