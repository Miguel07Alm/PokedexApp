//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Aula03 on 19/11/24.
//

import SwiftUI

@main
struct PokedexApp: App {
    @State var showSortFilterView: Bool = false
    @State var showFilterView: Bool = false
    @State var isTeamBuilding: Bool = false

    var body: some Scene {
        WindowGroup {
            ListaPokedexView(
                showSortFilterView: $showSortFilterView,
                showFilterView: $showFilterView,
                isTeamBuilding: isTeamBuilding)
            .environmentObject(ViewModel())
        }
    }
}
