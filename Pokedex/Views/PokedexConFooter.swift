//
//  PokedexConFooter.swift
//  Pokedex
//
//  Created by Aula03 on 23/12/24.
//

import SwiftUI

struct PokedexConFooter: View {
    @Binding var showSortFilterView: Bool
    @Binding var showFilterView: Bool
    @State var teamId: Int
    @Binding var selectedTab : Int
    @State var pokemons: [Pokemon]

    var body: some View {
        VStack(spacing: -100) {
            PokedexView(
                showSortFilterView: $showSortFilterView,
                showFilterView: $showFilterView,
                teamId: teamId,pokemonTeam: pokemons)
            FooterView(selectedTab: $selectedTab)
        }.ignoresSafeArea()
    }
}

#Preview {
    @State var showSortFilterView: Bool = false
    @State var showFilterView: Bool = false
    @State var teamId: Int = 0
    @State var selectedTab : Int = 1
    @State var pokemons: [Pokemon] = [PokemonType.getAveraged()];

    
    PokedexConFooter(showSortFilterView: $showSortFilterView, showFilterView: $showFilterView, teamId: teamId, selectedTab: $selectedTab, pokemons: pokemons)
}
