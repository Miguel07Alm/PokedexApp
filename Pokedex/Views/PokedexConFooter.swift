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
    @State var isTeamBuilding: Bool
    @Binding var selectedTab : Int
    @State var pokemons: [Pokemon]

    var body: some View {
        VStack(spacing: -100) {
            PokedexView(
                showSortFilterView: $showSortFilterView,
                showFilterView: $showFilterView,
                isTeamBuilding: isTeamBuilding,pokemonTeam: pokemons)
            FooterView(selectedTab: $selectedTab)
        }.ignoresSafeArea()
    }
}

#Preview {
    @State var showSortFilterView: Bool = false
    @State var showFilterView: Bool = false
    @State var isTeamBuilding: Bool = false
    @State var selectedTab : Int = 1
    @State var pokemons: [Pokemon] = [PokemonType.getAveraged()];

    
    PokedexConFooter(showSortFilterView: $showSortFilterView, showFilterView: $showFilterView, isTeamBuilding: isTeamBuilding, selectedTab: $selectedTab, pokemons: pokemons)
}
