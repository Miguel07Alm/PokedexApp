import SwiftUI

struct TeamsCombateView: View {
    @StateObject private var pokemonTeam = PokemonTeam.shared
    @State private var navigateToTeam1 = false
    @State private var navigateToTeam2 = false

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                teamView(teamName: "Equipo1", teamId: 1)
                teamView(teamName: "Equipo2", teamId: 2)
            }
            .background(
                NavigationLink(destination: PokedexView(showSortFilterView: false, showFilterView: false, teamId: 1), isActive: $navigateToTeam1) { EmptyView() }
            )
            .background(
                NavigationLink(destination: PokedexView(showSortFilterView: false, showFilterView: false, teamId: 2), isActive: $navigateToTeam2) { EmptyView() }
            )
        }
    }
    
    private func teamView(teamName: String, teamId: Int) -> some View {
        HStack(spacing: 25) {
            ForEach(0..<3, id: \.self) { i in
                if let team = pokemonTeam.getTeam(named: teamName),
                   i < team.pokemons.count {
                    ImagenPokemonSeleccionado(img: team.pokemons[i].sprites.other?.officialArtwork?.frontDefault ?? "")
                } else {
                    ImagenPokemonNoSeleccionado()
                }
            }
        }
        .onTapGesture {
            if teamId == 1 {
                navigateToTeam1 = true
            } else {
                navigateToTeam2 = true
            }
        }
    }
}

#Preview {
    TeamsCombateView()
}
