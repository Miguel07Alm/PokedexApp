//
//  PokedexView.swift
//  PokédexApp
//
//  Created by Aula03 on 12/11/24.
//

import SwiftUI

struct PokedexView: View {
    @Binding var showSortFilterView: Bool
    @Binding var showFilterView: Bool
    @State var isTeamBuilding: Bool
    var body: some View {
        VStack(spacing: -50) {
            HeaderView(
                showSortFilterView: $showSortFilterView,
                showFilterView: $showFilterView)
           // SeleccionarEquipoView(pokemonTeam: pokemons).cornerRadius(48)
            ListaPokedexView(
                showSortFilterView: $showSortFilterView,
                showFilterView: $showFilterView,
                isTeamBuilding: isTeamBuilding
            ).cornerRadius(48)
        }.ignoresSafeArea()
    }
}

struct PokedexView_Previews: PreviewProvider {
    static var previews: some View {
        PokedexPreviewWrapper()
    }

    struct PokedexPreviewWrapper: View {
        @State var showSortFilterView = false
        @State var showFilterView = false
        @State var isTeamBuilding = true
        var body: some View {
            PokedexView(
                showSortFilterView: $showSortFilterView,
                showFilterView: $showFilterView,
                isTeamBuilding: isTeamBuilding
            )
        }
    }
}
