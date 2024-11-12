//
//  VistaListaPokedex.swift
//  PokédexApp
//
//  Created by Aula03 on 12/11/24.
//

import SwiftUI

struct ListaPokedexView: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let pokemons = [
        (name: "Charmander", number: "0004", image: "charmander", color: Color.orange),
        (name: "Charmeleon", number: "0005", image: "charmeleon", color: Color.orange),
        (name: "Charizard", number: "0006", image: "charizard", color: Color.orange),
        (name: "Pikachu", number: "0025", image: "pikachu", color: Color.yellow),
        (name: "Vaporeon", number: "0157", image: "vaporeon", color: Color.blue),
        (name: "Hydreigon", number: "0643", image: "hydreigon", color: Color.purple)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Contenido principal
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(pokemons, id: \.name) { pokemon in
                        EntradaPokedexView(
                            name: pokemon.name,
                            number: pokemon.number,
                            image: pokemon.image,
                            backgroundColor: pokemon.color
                        )
                    }
                }
                .padding()
            }
            .background(Color(.systemGray6))
            
            // TabBar
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}
