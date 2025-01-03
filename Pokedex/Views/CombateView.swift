import SwiftUI
import SDWebImageSwiftUI

struct CombateView: View {
    @StateObject private var pokemonTeam = PokemonTeam.shared
    @StateObject var pokemonViewModel = PokemonViewModel()
    @State var isLoading: Bool = false
    @State private var combatLog: [String] = []
    @State var teamHealth: [Int] = [0, 0]
    @State var teamMaxHealth: [Int] = [0, 0]
    @State var showLog = false
    @StateObject private var refreshManager = RefreshManager.shared

    var body: some View {
        ScrollView{
            VStack {
                Text("").frame(height: 75)
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
                
                if(showLog){
                    CombatLog(title: "Registro de Combate", messages: combatLog)
                        .padding()
                }else{
                    VersusNames().offset(y:55)
                  //  Text("").frame(height: 157)
                }
            }
        }
        .background(Color(red: 0.7529411764705882, green: 0.8588235294117647, blue: 0.8588235294117647).ignoresSafeArea())
        .ignoresSafeArea()
        .frame(width: .infinity, height: .infinity)
        .onAppear(perform: updateView)
        .onChange(of: refreshManager.refreshFlag) { _ in
            updateView()
            showLog = true
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
                    let sprite = teamId == 1 ? (pokemon.sprites.other?.showdown?.frontDefault ?? team.pokemons[i]?.sprites.frontDefault) : (pokemon.sprites.other?.showdown?.backDefault ?? pokemon.sprites.backDefault)
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
            
            Image("HealthBc").resizable().frame(width: 350, height: 40).offset(x: -15)
            // Background
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black.opacity(0.6))
                .frame(width: 300, height: 20)
            
            // Health bar
            HStack(spacing: 0) {
                // Red portion (depleted health)
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 300 * CGFloat(maxHealth - health ) / CGFloat(maxHealth))
                
                // Green portion (remaining health)
                Rectangle()
                    .fill(Color.green)
                    .frame(width: 300 * CGFloat(health) / CGFloat(maxHealth))
            }
            .frame(height: 16)
            .padding(.horizontal, 2)
            .offset(x: +15)
            
            // HP Label
            Text("HP: \(health)/\(maxHealth)")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 6)
        }
    }
}

struct HealthBarView: View {
        let currentHealth: Int
       let maxHealth: Int
       
       // Animation state
       @State private var animatedValue: Double = 0
       
       var body: some View {
           HStack(spacing: 4) {
               // HP Label
               Text("HP")
                   .font(.system(size: 16, weight: .bold))
                   .foregroundColor(.white)
                   .padding(8)
                   .background(
                       Circle()
                           .fill(Color(.sRGB, red: 0.2, green: 0.2, blue: 0.2, opacity: 1))
                   )
               
               // Health Bar Container
               GeometryReader { geometry in
                   ZStack(alignment: .leading) {
                       // Striped Background (outside the health bar)
                       HStack(spacing: 0) {
                           ForEach(0..<20) { index in
                               Rectangle()
                                   .fill(index % 2 == 0 ?
                                       Color(.sRGB, red: 0.3, green: 0.3, blue: 0.3, opacity: 1) :
                                       Color(.sRGB, red: 0.4, green: 0.4, blue: 0.4, opacity: 1))
                                   .frame(width: geometry.size.width / 20)
                           }
                       }
                       
                       // Health Bar Background (Red for depleted health)
                       Rectangle()
                           .fill(
                               Color(.sRGB, red: 0.8, green: 0.2, blue: 0.2, opacity: 1)
                           )
                           .padding(2) // Add padding to show the striped background
                       
                       // Current Health (Green)
                       Rectangle()
                           .fill(
                               LinearGradient(
                                   gradient: Gradient(colors: [
                                       Color(.sRGB, red: 0.2, green: 1, blue: 0.2, opacity: 1),
                                       Color(.sRGB, red: 0.1, green: 0.8, blue: 0.1, opacity: 1)
                                   ]),
                                   startPoint: .top,
                                   endPoint: .bottom
                               )
                           )
                           .frame(width: (geometry.size.width - 4) * CGFloat(animatedValue))
                           .padding(2) // Match padding with background
                   }
               }
               .frame(height: 24)
               .clipShape(RoundedRectangle(cornerRadius: 12))
           }
       }
   }
struct VersusNames: View {
    var body: some View {
        HStack(spacing: 20){
            DisplayTeamNames(teamId: 1)
            // VS Circle
            ZStack {
                Circle()
                    .fill(Color(red: 239/255, green: 83/255, blue: 96/255))
                    .frame(width: 60, height: 60)
                
                Text("VS")
                    .foregroundColor(.white)
                    .font(.system(size: 22, weight: .bold))
                    .overlay {
                        Circle().stroke(Color.white, lineWidth: 4)
                            .frame(width: 60, height: 60)
                    }
            }
            .padding(.horizontal, -1) // Adjust circle overlap with lines
            DisplayTeamNames(teamId: 2)
        }
    }
}

struct DisplayTeamNames: View {
    @StateObject private var pokemonTeam = PokemonTeam.shared
    let teamId : Int

    var body: some View {
        let teamName = teamId == 1 ? "Equipo1" : "Equipo2"
        VStack(spacing:  10){
            ForEach(0..<3, id: \.self) { i in
                if let team = pokemonTeam.getTeam(named: teamName),
                   let pokemon = team.pokemons[i] {
                    ZStack {
                        RoundedRectangle(cornerSize: CGSize(width: 25, height: 25)).foregroundStyle(Color.white)
                        Text(pokemon.name.capitalizedFirstLetter())
                    }.frame(width: 120, height: 25)
                }
            }
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
    @State var a = 100
    CombateView()
   // HealthBar(maxHealth: 100, health: 100)
    //HealthBarView(currentHealth: 10, maxHealth: 100)
}
