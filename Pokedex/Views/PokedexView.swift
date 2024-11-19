//
//  PokedexView.swift
//  PokédexApp
//
//  Created by Aula03 on 12/11/24.
//

import SwiftUI

struct PokedexView: View {
    @Binding var showFilterView: Bool;
    var body: some View {
        VStack(spacing: -117) {
            HeaderView(showFilterView: $showFilterView)
            ListaPokedexView(showFilterView: $showFilterView).cornerRadius(48) 

            FooterView()
        }
    }
}
