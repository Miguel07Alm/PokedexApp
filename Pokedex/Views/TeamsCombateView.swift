import SwiftUI

struct TeamsCombateView: View {
    @StateObject private var pokemonTeam = PokemonTeam.shared
    @State private var navigateToTeam1 = false
    @State private var navigateToTeam2 = false

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                teamView(teamId: 1)
                teamView(teamId: 2)
            }
            .background(
                NavigationLink(destination: PokedexConFooter(showSortFilterView: false, showFilterView: false, teamId: 1, selectedTab: 3), isActive: $navigateToTeam1) { EmptyView() }
            )
            .background(
                NavigationLink(destination: PokedexConFooter(showSortFilterView: false, showFilterView: false, teamId: 2, selectedTab: 3), isActive: $navigateToTeam2) { EmptyView() }
            )
        }
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
                        ImagenPokemonSeleccionado(img: team.pokemons[i]?.sprites.other?.officialArtwork?.frontDefault ?? "", isSelected: false)
                    } else {
                        ImagenPokemonNoSeleccionado(isSelected: false)
                    }
                }
            }
        }
    }
}

#Preview {
    TeamsCombateView()
}
