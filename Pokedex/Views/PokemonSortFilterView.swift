import SwiftUI

struct SortOption: Identifiable {
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
    
    let sortOptions: [SortOption] = [
        SortOption(icon: "alfabeticamente-ordenacion", title: "ALFABETICAMENTE"),
        SortOption(icon: "n_pokedex-ordenacion", title: "N° POKEDEX"),
        SortOption(icon: "ataque-ordenacion", title: "ATAQUE"),
        SortOption(icon: "ataque-especial-ordenacion", title: "ATAQUE ESPECIAL"),
        SortOption(icon: "vida-ordenacion", title: "VIDA"),
        SortOption(icon: "defensa-ordenacion", title: "DEFENSA"),
        SortOption(icon: "defensa-especial-ordenacion", title: "DEFENSA ESPECIAL"),
        SortOption(icon: "velocidad-ordenacion", title: "VELOCIDAD")
    ]
    
    @State private var filterChips: [FilterChip] = [
        FilterChip(title: "Fuego", color: .orange),
        FilterChip(title: "Kanto", color: .blue),
        FilterChip(title: "favoritos", color: .yellow)
    ]
    
    @Binding var isPresented: Bool  // Para controlar la presentación
    
    var body: some View {
        ZStack {
            
            // Contenido del filtro
            VStack(spacing: 0) {
                // Sort Options
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
                            .foregroundColor(.primary)
                        }
                    }
                    .padding(.vertical, 16)
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
    
    var body: some View {
            // Contenido principal de la pantalla
            PokedexView(showFilterView: $showFilterView)
         
            // Mostrar vista de filtros superpuesta
            
        
    }
}

#Preview {
    ContentView()
}
