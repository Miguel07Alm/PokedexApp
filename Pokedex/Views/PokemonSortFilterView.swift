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
    @State private var showTypeIcons: Bool = false
    @State private var showRegionIcons: Bool = false

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

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                if isSortFilterShow {
                    ScrollView {
                        VStack(spacing: 24) {
                            ForEach(sortOptions) { option in
                                Button(action: {
                                    if filterState.selectedSort == option.title.lowercased() {
                                        filterState.isAscending.toggle()
                                    } else {
                                        filterState.selectedSort = option.title.lowercased()
                                        filterState.isAscending = true
                                    }
                                    isSortFilterShow.toggle()
                                }) {
                                    ZStack(alignment: .leading) {
                                        HStack(spacing: 12) {
                                            Image(option.icon)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 36, height: 36)
                                                .background(Circle().fill(Color.gray.opacity(0.2)))
                                                .foregroundColor(.primary)

                                            Text(option.title)
                                                .font(.system(.title2, design: .rounded))
                                                .foregroundColor(Color(red: 85/255, green: 85/255, blue: 85/255))
                                                .fontWeight(.bold)

                                            Spacer()
                                        }
                                        .padding(.horizontal, 16).offset(x: 5)

                                        if filterState.selectedSort == option.title.lowercased() {
                                            Image(systemName: filterState.isAscending ? "arrow.down" : "arrow.up")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(.black)
                                                .offset(x: 0)
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
                        VStack(spacing: 24) {
                            ForEach(filterOptions) { option in
                                Button(action: {
                                    filterState.addShowFilters(filter: option.title.lowercased())
                                    
                                    if (option.title == "LEGENDARIOS") {
                                        filterState.showLegendaries.toggle()
                                    }
                                    if (option.title == "SINGULARES") {
                                        filterState.showSingulares.toggle()
                                    }
                                    if (option.title == "FAVORITO") {
                                        filterState.showFavorites.toggle()
                                    }
                                    
                                }) {
                                    HStack(spacing: 12) {
                                        Spacer()
                                        Text(option.title)
                                            .font(.system(.title2, design: .rounded))
                                            .foregroundColor(Color(red: 85/255, green: 85/255, blue: 85/255))
                                            .fontWeight(.bold)

                                        Image(option.icon)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 36, height: 36)
                                            .background(
                                                filterState.selectedFilters.contains(option.title.lowercased()) ? Circle().fill(Color.green.opacity(0.75)) : Circle().fill(Color.gray.opacity(0.2))
                                            )
                                            .foregroundColor(.primary)
                                    }
                                    .padding(.horizontal, 16)
                                }
                            }
                        }
                        .padding(.vertical, 16)
                        .onDisappear{
                            showTypeIcons = false;
                            showRegionIcons = false;
                        }
                    }
                    VStack {
                       if filterState.selectedFilters.contains("tipo") {
                           
                                typeIconsView
                        }
                       if filterState.selectedFilters.contains("región") {
                           Text("Regiones")
                               .font(.headline)
                               .padding(.leading)
                               .frame(maxWidth: .infinity, alignment: .leading)
                                regionIconsView
                        }
                    }.offset(y:125)
                    
                }
            }
            .background(.white)
            .opacity(0.75)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding()
        }
        .animation(.smooth, value: isPresented)
    }
    
    var typeIconsView: some View {
           ZStack {
               Text("Tipos")
                   .font(.headline)
                   .padding(.leading)
                   .frame(maxWidth: .infinity, alignment: .leading).offset(y: -75)
               ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(Array(PokemonType.typesToIcon.keys.sorted()), id: \.self) { type in
                            VStack {
                                Image(PokemonType.typesToIcon[type]!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60, height: 60)
                                    .background(
                                        filterState.selectedTypes.contains(type) ?
                                            Color.green.opacity(0.75) : Color.gray.opacity(0.2)
                                    )
                                    .clipShape(Circle())

                                Text(PokemonType.typesToSpanish[type]!.capitalized)
                                    .font(.callout)
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
                
                
                 GeometryReader { geometry in
                        HStack {
                            Rectangle()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [Color.white, Color.clear]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ))
                                .frame(width: geometry.size.width / 4, height: 90)
                                .blur(radius: 10)
                                .offset(x: -5, y: -10)

                            Spacer()

                            Rectangle()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [Color.clear, Color.white]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ))
                                .frame(width: geometry.size.width / 4, height:90)
                                .blur(radius: 10)
                                .offset(x: 5, y:-10)
                        }
                }
                 .frame(height: 90)
            }.offset(y: -200)
    }
    
    var regionIconsView: some View {
        ZStack {
            Text("Regiones")
                .font(.headline)
                .padding(.leading)
                .frame(maxWidth: .infinity, alignment: .leading).offset(y: -75)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                   ForEach(PokemonRegion.regions, id: \.name) { region in
                       VStack {
                           Image(region.icon)
                               .resizable()
                               .aspectRatio(contentMode: .fit)
                               .frame(width: 60, height: 60)
                               .background(
                                   Color.gray.opacity(0.2)
                               )
                               .clipShape(Circle())
                           
                           Text(region.name.capitalized)
                               .font(.callout)
                               .foregroundColor(.black)
                       }
                       .onTapGesture {
                           if filterState.selectedRegions.contains(region.name) {
                               filterState.selectedRegions.remove(region.name)
                           } else {
                               filterState.selectedRegions.insert(region.name)
                           }
                       }
                   }
               }
               .padding(.horizontal, 16)
               .padding(.vertical, 8)
            }
            GeometryReader { geometry in
                    HStack {
                        Rectangle()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [Color.white, Color.clear]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                            .frame(width: geometry.size.width / 4, height: 90)
                            .blur(radius: 10)
                            .offset(x: -5, y: -10)

                        Spacer()

                        Rectangle()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [Color.clear, Color.white]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                            .frame(width: geometry.size.width / 4, height:90)
                            .blur(radius: 10)
                            .offset(x: 5, y:-10)
                    }
            }
             .frame(height: 90)
        }            .offset(y: -200)
    }
}

struct ContentView: View {
    @State private var showFilterView = false
    @State private var showSortFilterView = false
    @State private var teamId = 0
    @StateObject var filterState = PokemonFilterState()

    var body: some View {
        PokedexView(showSortFilterView: showSortFilterView, showFilterView: showFilterView,
                    teamId: teamId, filterState: filterState
        )
    }
}

#Preview {
    ContentView()
}
