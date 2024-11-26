//
//  ContentView.swift
//  Pokedex
//
//  Created by Aula03 on 19/11/24.
//


//
//  ContentView.swift
//  Pokedex
//
//  Created by Aula03 on 19/11/24.
//

import SwiftUI

struct PokedexFooter: View {
    var body: some View {
        VStack(spacing: -100) {
            PokedexView()
            FooterView()
        }.ignoresSafeArea()
    }
}

#Preview {
    PokedexFooter()
}
