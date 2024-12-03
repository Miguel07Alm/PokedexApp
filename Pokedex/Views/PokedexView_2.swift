//
//  PokedexView.swift
//  PokédexApp
//
//  Created by Aula03 on 12/11/24.
//

import SwiftUI

struct PokedexView_2: View {
    @Binding var showSortFilterView: Bool;
    @Binding var showFilterView: Bool;
    @Binding var selectedTab : Int;
    var body: some View {
        VStack(spacing: -100) {
            PokedexView(showSortFilterView: $showSortFilterView, showFilterView: $showFilterView)
            FooterView(selectedTab: $selectedTab)
        }.ignoresSafeArea()
    }
}

#Preview{
    @State var showSortFilterView: Bool = false;
    @State var showFilterView: Bool = false;
    @State var selectedTab = 1;
    
    PokedexView_2(showSortFilterView: $showSortFilterView, showFilterView: $showFilterView, selectedTab: $selectedTab)
}
