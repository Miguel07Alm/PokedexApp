import SwiftUI

struct SortFilterOption: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
}

struct FilterChip: Identifiable {
    let id = UUID()
    let title: String
    let color: Color
    var isSelected: Bool = false
}

struct PokemonSortFilterView: View {
    @State private var selectedFilters: Set<UUID> = []
    @State private var selectedSort: String = "alfabeticamente"
    @State private var isAscending: Bool = true
    @State private var showTypeIcons: Bool = false
    
    let sortOptions: [SortFilterOption] = [
        SortFilterOption(icon: "alfabeticamente-ordenacion", title: "ALFABETICAMENTE"),
        SortFilterOption(icon: "n_pokedex-ordenacion", title: "N° POKEDEX"),
        SortFilterOption(icon: "ataque-ordenacion", title: "ATAQUE"),
        SortFilterOption(icon: "ataque-especial-ordenacion", title: "ATAQUE ESPECIAL"),
        SortFilterOption(icon: "vida-ordenacion", title: "VIDA"),
        SortFilterOption(icon: "defensa-ordenacion", title: "DEFENSA"),
        SortFilterOption(icon: "defensa-especial-ordenacion", title: "DEFENSA ESPECIAL"),
        SortFilterOption(icon: "velocidad-ordenacion", title: "VELOCIDAD")
    ]
    
    let filterOptions: [SortFilterOption] = [
        SortFilterOption(icon: "favorito", title: "FAVORITO"),
        SortFilterOption(icon: "tipo", title: "TIPO"),
        SortFilterOption(icon: "region", title: "REGIÓN"),
        SortFilterOption(icon: "evolucion", title: "EVOLUCION"),
        SortFilterOption(icon: "legendarios", title: "LEGENDARIOS"),
        SortFilterOption(icon: "singulares", title: "SINGULARES")
    ]
    
    @State private var filterChips: [FilterChip] = [
        FilterChip(title: "Fuego", color: .orange),
        FilterChip(title: "Kanto", color: .blue),
        FilterChip(title: "Favoritos", color: .yellow)
    ]
    
    @State var isPresented: Bool
    @Binding var isFilterShow: Bool
    @Binding var isSortFilterShow: Bool
    @Binding var pokemons: [Pokemon]
    @StateObject var filterState: PokemonFilterState
    
    private func filterPokemon() -> [Pokemon] {
        var filteredPokemon = pokemons
        
        let selectedTypes = filterChips.filter { $0.isSelected }.map { $0.title.lowercased() }
        if !selectedTypes.isEmpty {
            filteredPokemon = filteredPokemon.filter { pokemon in
                pokemon.types.contains { typeElement in
                    selectedTypes.contains(typeElement.type.name)
                }
            }
        }
        
        return filteredPokemon
    }
    
    private func sortPokemon(pokemon: [Pokemon]) -> [Pokemon] {
        switch selectedSort {
        case "alfabeticamente":
            return pokemon.sorted { (p1, p2) in
                isAscending ? p1.name < p2.name : p1.name > p2.name
            }
        case "n_pokedex":
            return pokemon.sorted { (p1, p2) in
                isAscending ? p1.id < p2.id : p1.id > p2.id
            }
        case "ataque", "ataque especial", "vida", "defensa", "defensa especial", "velocidad":
            let statName = selectedSort.replacingOccurrences(of: " ", with: "_").lowercased()
            return pokemon.sorted { (p1, p2) in
                let stat1 = p1.stats.first(where: { $0.stat.name == statName })?.baseStat ?? 0
                let stat2 = p2.stats.first(where: { $0.stat.name == statName })?.baseStat ?? 0
                return isAscending ? stat1 < stat2 : stat1 > stat2
            }
        default:
            return pokemon
        }
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                if isSortFilterShow {
                    ScrollView {
                        VStack(spacing: 16) {
                            // Using id from the Identifiable protocol
                            ForEach(sortOptions) { option in
                                Button(action: {
                                    if filterState.selectedSort == option.title.lowercased() {
                                        filterState.isAscending.toggle()
                                    } else {
                                        filterState.selectedSort = option.title.lowercased()
                                        filterState.isAscending = true
                                    }
                                }) {
                                    ZStack(alignment: .leading) {
                                        HStack(spacing: 12) {
                                            Image(option.icon)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 28, height: 28)
                                                .background(Circle().fill(Color.gray.opacity(0.2)))
                                                .foregroundColor(.primary)
                                            
                                            Text(option.title)
                                                .font(.system(.body, design: .rounded))
                                                .foregroundColor(Color(red: 85/255, green: 85/255, blue: 85/255))
                                                .fontWeight(.bold)
                                            
                                            Spacer()
                                        }
                                        .padding(.horizontal, 16)
                                        
                                        if filterState.selectedSort == option.title.lowercased() {
                                            Image(systemName: filterState.isAscending ? "arrow.down" : "arrow.up")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 16, height: 16)
                                                .foregroundColor(.black)
                                                .offset(x: -2)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 16)
                    }
                }
                
                if isFilterShow {
                    ScrollView {
                        VStack(spacing: 16) {
                            // Using id from the Identifiable protocol
                            ForEach(filterOptions) { option in
                                Button(action: {
                                    if option.title == "TIPO" {
                                        showTypeIcons.toggle()
                                    }
                                }) {
                                    HStack {
                                        Spacer()
                                        Text(option.title)
                                            .font(.system(.body, design: .rounded))
                                            .foregroundColor(Color(red: 85/255, green: 85/255, blue: 85/255))
                                            .fontWeight(.bold)
                                        
                                        Image(option.icon)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 28, height: 28)
                                            .background(Circle().fill(Color.gray.opacity(0.2)))
                                            .foregroundColor(.primary)
                                    }
                                    .padding(.horizontal, 16)
                                }
                            }
                        }
                        .padding(.vertical, 16)
                    }
                    
                    // Mostrar los iconos de tipo
                                if showTypeIcons {
                                    ZStack {
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(spacing: 16) {
                                                ForEach(Array(PokemonType.typesToIcon.keys.sorted()), id: \.self) { type in
                                                    VStack {
                                                        Image(PokemonType.typesToIcon[type]!)
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .frame(width: 50, height: 50)
                                                            .background(
                                                                // Si el tipo está seleccionado, poner fondo verde claro
                                                                filterState.selectedTypes.contains(type) ?
                                                                    Color.green.opacity(0.75) : Color.gray.opacity(0.2)
                                                            )
                                                            .clipShape(Circle())
                                                        
                                                        Text(PokemonType.typesToSpanish[type]!.capitalized)
                                                            .font(.caption)
                                                            .foregroundColor(.black)
                                                    }
                                                    .onTapGesture {
                                                        if filterState.selectedTypes.contains(type) {
                                                            filterState.selectedTypes.remove(type)
                                                        } else {
                                                            if filterState.selectedTypes.count >= 2 {
                                                                filterState.selectedTypes.remove(filterState.selectedTypes.first!)
                                                            }
                                                            filterState.selectedTypes.insert(type)
                                                        }
                                                    }
                                                }
                                            }
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                        }
                                        .offset(y: -150)

                                        GeometryReader { geometry in
                                            HStack {
                                                LinearGradient(
                                                    gradient: Gradient(colors: [Color.clear, Color.white.opacity(1)]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                                .frame(width: geometry.size.width / 4)
                                                .blur(radius: 20)
                                                .offset(x: -110)
                                                
                                                Spacer()
                                                
                                                LinearGradient(
                                                    gradient: Gradient(colors: [Color.white.opacity(1), Color.clear]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                                .frame(width: geometry.size.width / 4)
                                                .blur(radius: 20)
                                            }
                                            .frame(height: geometry.size.height)
                                            .padding(.horizontal, 16)
                                            .offset(x: 60)
                                        }
                                        .offset(y: -150)
                                    }
                    }
                }
            }
            .background(.white)
            .opacity(0.75)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding()
        }
        .animation(.smooth, value: isPresented)
    }
}


struct ContentView: View {
    @State private var showFilterView = false
    @State private var showSortFilterView = false
    @State private var teamId = 0

    var body: some View {
            // Contenido principal de la pantalla
        PokedexView(showSortFilterView: showSortFilterView, showFilterView: showFilterView,
            teamId: teamId
        )
         
            // Mostrar vista de filtros superpuesta
            
        
    }
}

#Preview {
    ContentView()
}
