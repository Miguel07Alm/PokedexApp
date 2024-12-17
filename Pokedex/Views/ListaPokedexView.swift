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
    @ObservedObject var pokemonViewModel = PokemonViewModel()
    
    
    let pokemonsMock = [
        (name: "Charmander", number: 0004, image: "charmander", color: Color.orange),
        (name: "Charmeleon", number: 0005, image: "charmeleon", color: Color.orange),
        (name: "Charizard", number: 0006, image: "charizard", color: Color.orange),
        (name: "Pikachu", number: 0025, image: "pikachu", color: Color.yellow),
        (name: "Vaporeon", number: 0157, image: "vaporeon", color: Color.blue),
        (name: "Hydreigon", number: 0643, image: "hydreigon", color: Color.purple)
    ]
    @Binding var pokemons: [Pokemon];
    @Binding var showSortFilterView: Bool;
    @Binding var showFilterView: Bool;

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Contenido principal
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(pokemonsMock, id: \.name) { pokemon in
                            EntradaPokedexView(
                                name: pokemon.name,
                                number: pokemon.number,
                                image: pokemon.image,
                                backgroundColor: pokemon.color
                            ).onAppear{
                                pokemonViewModel.fetchPokemonDetails(id: 25) { result in
                                    switch result {
                                    case .success(let pokemon):
                                        print("Pokemon name: \(pokemon.name)")
                                        print("Height: \(pokemon.height)")
                                        print("Weight: \(pokemon.weight)")
                                        print("Abilities: \(pokemon.abilities.map { $0.ability.name }.joined(separator: ", "))")
                                        print("Types: \(pokemon.types.map { $0.type.name }.joined(separator: ", "))")
                                        print("Sprites: \(pokemon.sprites.frontDefault)")
                                    case .failure(let error):
                                        print("Error fetching Pokémon details: \(error)")
                                    }
                                }
                                pokemonViewModel.fetchPokemonSpecies(id: 25, completion: { result in
                                    switch result {
                                    case .success(let evolution):
                                        print("name: \(evolution.name)")
                                        print("Evolution chain url: \(evolution.evolutionChain.url)")
                                        pokemonViewModel.fetchPokemonEvolutionChain(id:10, completion: { result in
                                            switch result {
                                            case .success(let evolutionChain):
                                                print("Evoluciona a: \(evolutionChain.chain.evolvesTo)")
                                                
                                            case .failure(let error):
                                                print("Error fetching Pokémon evolution chain: \(error)")
                                            }
                                        })
                                        
                                    case .failure(let error):
                                        print("Error fetching Pokémon species: \(error)")
                                    }
                                })
                                pokemonViewModel.fetchAbilityInfo(name: "stench", completion: { result in
                                    switch result {
                                    case .success(let ability):
                                        print("Ability name: \(ability.name)")
                                        print("Cuantos pokemons tienen la habilidad: : \(ability.pokemon.count)")
                                    case .failure(let error):
                                        print("Error fetching Pokémon ability info: \(error)")
                                    }
                                });
                                                            
                                
                                
                                

                                print("Aparece el pokemon")
                            }
                        }
                    }
                    .padding()
                } .edgesIgnoringSafeArea(.bottom)// Desenfoque en el contenido principal
                    .background(Color(red: 0.7529411764705882, green: 0.8588235294117647, blue: 0.8588235294117647))

                
                // TabBar
            }

            if (showSortFilterView || showFilterView) {
                PokemonSortFilterView( isPresented: true, isFilterShow: $showFilterView, isSortFilterShow: $showSortFilterView,
                    pokemons: $pokemons)
                    .transition(.move(edge: .bottom))  // Transición para que aparezca desde abajo
            }

        }
    }
}
#Preview{
    @State var showSortFilterView: Bool = false;
    @State var showFilterView: Bool = false;
    @State var pokemon: [Pokemon] = [] // Tu array de Pokémon
    ListaPokedexView(pokemons: $pokemon, showSortFilterView: $showSortFilterView, showFilterView: $showFilterView)
}
