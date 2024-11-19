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
    
    let sortOptions: [SortOption] = [
        SortOption(icon: "textformat", title: "ALFABETICAMENTE"),
        SortOption(icon: "number", title: "N° POKEDEX"),
        SortOption(icon: "bolt.fill", title: "ATAQUE"),
        SortOption(icon: "sparkles", title: "ATAQUE ESPECIAL"),
        SortOption(icon: "heart.fill", title: "VIDA"),
        SortOption(icon: "shield.fill", title: "DEFENSA"),
        SortOption(icon: "shield.lefthalf.filled", title: "DEFENSA ESPECIAL"),
        SortOption(icon: "bolt.horizontal.fill", title: "VELOCIDAD")
    ]
    
    @State private var filterChips: [FilterChip] = [
        FilterChip(title: "Fuego", color: .orange),
        FilterChip(title: "Kanto", color: .blue),
        FilterChip(title: "favoritos", color: .yellow)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Filter Chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach($filterChips) { $chip in
                        Button(action: {
                            chip.isSelected.toggle()
                            if chip.isSelected {
                                selectedFilters.insert(chip.id)
                            } else {
                                selectedFilters.remove(chip.id)
                            }
                        }) {
                            Text(chip.title)
                                .font(.subheadline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(chip.isSelected ? chip.color : chip.color.opacity(0.2))
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            
            // Sort Options
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(sortOptions) { option in
                        Button(action: {
                            selectedSort = option.title.lowercased()
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: option.icon)
                                    .frame(width: 28, height: 28)
                                    .background(Circle().fill(Color.gray.opacity(0.2)))
                                    .foregroundColor(.primary)
                                
                                Text(option.title)
                                    .font(.system(.body, design: .rounded))
                                
                                Spacer()
                                
                                if selectedSort == option.title.lowercased() {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        .foregroundColor(.primary)
                    }
                }
                .padding(.vertical, 16)
            }
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.3)
            .ignoresSafeArea()
        
        PokemonSortFilterView()
            .padding()
    }
}
