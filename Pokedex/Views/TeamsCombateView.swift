import SwiftUI

struct TeamsCombateView: View {
    @StateObject private var pokemonTeam = PokemonTeam.shared
    @State private var navigateToTeam1 = false
    @State private var navigateToTeam2 = false
    @State private var teamIsNil = false
    @State private var teamHealth : [Int] = [0,0]

    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.7529411764705882, green: 0.8588235294117647, blue: 0.8588235294117647)
                    .ignoresSafeArea()

                VStack(spacing: 100) {
                    VStack(spacing: 30){
                        teamView(teamId: 1)
                        
                        VersusIcon().frame(width: 450)
                        
                        teamView(teamId: 2)
                    }
                    HStack {
                        if(!teamIsNil){
                            NavigationLink(destination: MainView(teamHealth: teamHealth, irA: "Combate")) {
                                Text("")
                            }
                            .buttonStyle(BotonConfirmarGrande())
                        }
                    }
                }
            }
            .background(
                NavigationLink(destination: MainView(showSortFilterView: false, showFilterView: false, teamId: 1, irA: "SeleccionarEquipo"), isActive: $navigateToTeam1) { EmptyView() }
            )
            .background(
                NavigationLink(destination: MainView(showSortFilterView: false, showFilterView: false, teamId: 2, irA: "SeleccionarEquipo"), isActive: $navigateToTeam2) { EmptyView() }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarBackButtonHidden(true)
    }
    
    private func teamView(teamId: Int) -> some View {
        HStack(spacing: 25) {
            let name = teamId == 1 ? "Equipo1" : "Equipo2"
            ForEach(0..<3, id: \.self) { i in
                Button(action: {
                    pokemonTeam.setTeamPos(named: name, pos: i)
                    if teamId == 1 {
                        navigateToTeam1 = true
                    } else {
                        navigateToTeam2 = true
                    }
                }) {
                    if let team = pokemonTeam.getTeam(named: name),
                       nil != team.pokemons[i] {
                        ImagenPokemonSeleccionado(img: team.pokemons[i]?.sprites.other?.officialArtwork?.frontDefault ?? "", isSelected: false).onAppear(){
                            teamHealth[teamId-1] += team.pokemons[i]?.stats[0].baseStat ?? 0
                        }
                    } else {
                        ImagenPokemonNoSeleccionado(isSelected: false).onAppear(){
                            teamIsNil =  true
                        }
                    }
                }
            }
        }
    }
}

struct VersusIcon: View {
    var body: some View {
        HStack(spacing: 0) {
            // Left line
            Rectangle()
                .fill(.white)
                .frame(height: 2)
            
            // VS Circle
            ZStack {
                Circle()
                    .fill(Color(red: 239/255, green: 83/255, blue: 96/255))
                    .frame(width: 50, height: 50)
                
                Text("VS")
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .bold))
                    .overlay {
                        Circle().stroke(Color.white, lineWidth: 5)
                            .frame(width: 50, height: 50)
                    }
            }
            .padding(.horizontal, -1) // Adjust circle overlap with lines
            
            // Right line
            Rectangle()
                .fill(.white)
                .frame(height: 2)
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 40) // Adjust the overall width of the component
    }
}

#Preview {
    TeamsCombateView()
}
