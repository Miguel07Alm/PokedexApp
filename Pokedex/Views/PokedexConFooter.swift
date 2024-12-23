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
    @State var isTeamBuilding = false
    @Binding var selectedTab : Int
    
    var body: some View {
        VStack(spacing: -100) {
            PokedexView(
                showSortFilterView: $showSortFilterView,
                showFilterView: $showFilterView,
                isTeamBuilding: isTeamBuilding)
            FooterView(selectedTab: $selectedTab)
        }.ignoresSafeArea()
    }
}

#Preview {
    @State var showSortFilterView: Bool = false
    @State var showFilterView: Bool = false
    @State var isTeamBuilding: Bool = false
    @State var selectedTab : Int = 1
    
    PokedexConFooter(showSortFilterView: $showSortFilterView, showFilterView: $showFilterView, selectedTab: $selectedTab)
}
