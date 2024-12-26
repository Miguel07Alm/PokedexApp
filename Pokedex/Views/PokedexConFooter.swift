//
//  PokedexConFooter.swift
//  Pokedex
//
//  Created by Aula03 on 23/12/24.
//

import SwiftUI

struct PokedexConFooter: View {
    @State var showSortFilterView: Bool
    @State var showFilterView: Bool
    @State var teamId: Int
    @State var selectedTab : Int
    @State var teamPos: Int
    var body: some View {
        VStack(spacing: -100) {
            PokedexView(
                showSortFilterView: showSortFilterView,
                showFilterView: showFilterView,
                teamId: teamId,
                teamPos: teamPos)
            FooterView(selectedTab: selectedTab)
        }.ignoresSafeArea()
    }
}

#Preview {
    @State var showSortFilterView: Bool = false
    @State var showFilterView: Bool = false
    @State var teamId: Int = 0
    @State var selectedTab : Int = 1
    @State var teamPos: Int = 0
    
    PokedexConFooter(showSortFilterView: showSortFilterView, showFilterView: showFilterView, teamId: teamId, selectedTab: selectedTab, teamPos: teamPos)
}
