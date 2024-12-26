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
    @State private var isAscending: Bool = true  // Estado para controlar la dirección de la flecha
    @State private var showTypeIcons: Bool = false // Estado para controlar la visibilidad de los iconos de tipos
    
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
    
    @State var isPresented: Bool  // Para controlar la presentación
    @Binding var isFilterShow: Bool
    @Binding var isSortFilterShow: Bool
    @Binding var pokemons: [Pokemon]

    private func filterPokemon() -> [Pokemon] {
          var filteredPokemon = pokemons

          // Filtro por tipo
          let selectedTypes = filterChips.filter { $0.isSelected }.map { $0.title.lowercased() }
          if !selectedTypes.isEmpty {
              filteredPokemon = filteredPokemon.filter { pokemon in
                  pokemon.types.contains { typeElement in
                      selectedTypes.contains(typeElement.type.name)
                  }
              }
          }
           
          // Otros filtros (Favoritos, legendarios, singulares)
          // ... (implementa lógica para otros filtros)

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
          // Ordena por estadísticas (ataque, defensa, etc.)
          case "ataque", "ataque especial", "vida", "defensa", "defensa especial", "velocidad":
              let statName = selectedSort.replacingOccurrences(of: " ", with: "_").lowercased() // Convertir a formato de la API
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
            // Contenido del filtro
            VStack(spacing: 0) {
                // Sort Options - Aparece si `isSortFilterShow` es true
                if isSortFilterShow {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(sortOptions) { option in
                                Button(action: {
                                    if selectedSort == option.title.lowercased() {
                                        // Si se selecciona el mismo filtro, invertir la dirección
                                        isAscending.toggle()
                                    } else {
                                        // Si se selecciona un nuevo filtro, establecerlo y reiniciar a ascendente
                                        selectedSort = option.title.lowercased()
                                        isAscending = true
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
                                                .foregroundColor(Color(red: 85/255, green: 85/255, blue: 85/255)).fontWeight(.bold)
                                            
                                            Spacer()
                                        }
                                        .padding(.horizontal, 16)
                                        
                                        // Flecha sobrepuesta, no ocupa espacio extra
                                        if selectedSort == option.title.lowercased() {
                                            Image(systemName: isAscending ? "arrow.down" : "arrow.up")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 16, height: 16)
                                                .foregroundColor(.black)
                                                .offset(x: -2)  // Ajusta la posición a la izquierda
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 16)
                    }
                }
                
                // Filter Options - Aparece si `isFilterShow` es true
                if isFilterShow {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(filterOptions) { option in
                                Button(action: {
                                    if option.title == "TIPO" {
                                        // Mostrar/ocultar los iconos de tipos de Pokémon
                                        showTypeIcons.toggle()
                                    }
                                    // Lógica para seleccionar otros filtros si es necesario
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
                    
                    // Mostrar las imágenes de tipos si el usuario ha clicado en "TIPO"
                    if showTypeIcons {
                        ZStack {
                            // ScrollView con los iconos de tipos
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(PokemonType.typesToIcon.keys.sorted(), id: \.self) { type in
                                        VStack {
                                            Image(PokemonType.typesToIcon[type]!)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 50, height: 50)
                                                .background(Circle().fill(Color.gray.opacity(0.2)))
                                            Text(PokemonType.typesToSpanish[type]!.capitalized)
                                                .font(.caption)
                                                .foregroundColor(.black)
                                        }
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                            }
                            .offset(y: -150)  // Ajusta el offset según lo necesites

                            // GeometryReader para calcular el ancho y aplicar el blur en los extremos
                            GeometryReader { geometry in
                                HStack {
                                    // Blur en el lado izquierdo
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.clear, Color.white.opacity(1)]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                    .frame(width: geometry.size.width / 4)  // Usa 1/4 del ancho para el blur
                                    .blur(radius: 20).offset(x: -110)
                                    Spacer()
                                    // Blur en el lado derecho
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.white.opacity(1), Color.clear]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                    .frame(width: geometry.size.width / 4)  // Usa 1/4 del ancho para el blur
                                    .blur(radius: 20)
                                }
                                .frame(height: geometry.size.height)  // Asegura que el ZStack ocupe toda la altura
                                .padding(.horizontal, 16).offset(x: 60)
                            }
                            .offset(y: -150)  // Ajuste en la misma dirección que el ScrollView
                        }
                    }

                }
            }
            .background(.white).opacity(0.75)
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
