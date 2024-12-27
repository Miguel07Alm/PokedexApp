//
//  PokedexView.swift
//  PokédexApp
//
//  Created by Aula03 on 12/11/24.
//

import SwiftUI

struct PokedexView: View {
    @State var showSortFilterView: Bool
    @State var showFilterView: Bool
    @State var teamId: Int
    @StateObject private var pokemonTeam = PokemonTeam.shared
    @StateObject private var refreshManager = RefreshManager.shared
    @StateObject var filterState = PokemonFilterState()

    var body: some View {
        VStack(spacing: -50) {
            HeaderView(
                showSortFilterView: $showSortFilterView,
                showFilterView: $showFilterView,
                filterState: filterState)
            if(teamId != 0){
                SeleccionarEquipoView(teamId: teamId).id(refreshManager.refreshFlag)            }
            ListaPokedexView(
                showSortFilterView: $showSortFilterView,
                showFilterView: $showFilterView,
                teamId: teamId
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
        @State var teamId = 1
        var body: some View {
            PokedexView(
                showSortFilterView: showSortFilterView,
                showFilterView: showFilterView,
                teamId: teamId
            )
        }
    }
}
