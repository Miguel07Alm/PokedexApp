//
//  PokedexView.swift
//  PokédexApp
//
//  Created by Aula03 on 12/11/24.
//

import SwiftUI

struct PokedexView: View {
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
            ListaPokedexView()
            FooterView()
        }
    }
}

#Preview {
    PokedexView()
}
