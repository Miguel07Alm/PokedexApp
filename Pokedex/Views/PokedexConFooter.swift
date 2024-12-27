//
//  PokedexConFooter.swift
//  Pokedex
//
//  Created by Aula03 on 23/12/24.
//

import SwiftUI

struct PokedexConFooter: View {
    @StateObject private var refreshManager = RefreshManager.shared
    @State var showSortFilterView: Bool
    @State var showFilterView: Bool
    @State var teamId: Int
    @State var selectedTab: Int
    
    var body: some View {
        VStack(spacing: -100) {
            PokedexView(
                showSortFilterView: showSortFilterView,
                showFilterView: showFilterView,
                teamId: teamId
            )
            FooterView(selectedTab: selectedTab)
        }.ignoresSafeArea().navigationBarBackButtonHidden()
    }
}

#Preview {
    @State var showSortFilterView: Bool = false
    @State var showFilterView: Bool = false
    @State var teamId: Int = 1
    @State var selectedTab : Int = 3
    
    PokedexConFooter(showSortFilterView: showSortFilterView, showFilterView: showFilterView, teamId: teamId, selectedTab: selectedTab)
}
