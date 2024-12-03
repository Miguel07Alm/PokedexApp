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
        (name: "Charmander", number: 0004, image: "charmander", color: Color.orange),
        (name: "Charmeleon", number: 0005, image: "charmeleon", color: Color.orange),
        (name: "Charizard", number: 0006, image: "charizard", color: Color.orange),
        (name: "Pikachu", number: 0025, image: "pikachu", color: Color.yellow),
        (name: "Vaporeon", number: 0157, image: "vaporeon", color: Color.blue),
        (name: "Hydreigon", number: 0643, image: "hydreigon", color: Color.purple)
    ]
    @Binding var showSortFilterView: Bool;
    @Binding var showFilterView: Bool;

    var body: some View {
        ZStack {
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
                } .edgesIgnoringSafeArea(.bottom)// Desenfoque en el contenido principal
                    .background(Color(red: 0.7529411764705882, green: 0.8588235294117647, blue: 0.8588235294117647))

                
                // TabBar
            }

            if (showSortFilterView || showFilterView) {
                PokemonSortFilterView(isPresented: true, isFilterShow: $showFilterView, isSortFilterShow: $showSortFilterView)
                    .transition(.move(edge: .bottom))  // Transición para que aparezca desde abajo
            }

        }
    }
}
#Preview{
    @State var showSortFilterView: Bool = false;
    @State var showFilterView: Bool = false;
    ListaPokedexView(showSortFilterView: $showSortFilterView, showFilterView: $showFilterView)
}
