import SwiftUI

struct HeaderView: View {
    @Binding var showSortFilterView: Bool
    @Binding var showFilterView: Bool
    @StateObject var filterState: PokemonFilterState
    
    var body: some View {
        VStack {
            // Search bar
            ZStack {
                Rectangle()
                    .frame(height: 210)
                    .foregroundColor(.white)
                
                HStack {
                    Button(action: {
                        withAnimation {
                            showSortFilterView = !showSortFilterView
                            if showFilterView {
                                showFilterView = false
                            }
                        }
                    }) {
                        Image("OrdenacionUltraFino")
                            .resizable()
                            .frame(width: 24, height: 14)
                            .foregroundColor(Color(red: 0.7215686274509804, green: 0.7215686274509804, blue: 0.7215686274509804))
                    }
                    
                    TextField("   Buscar", text: .constant(""))
                        .scrollContentBackground(.hidden)
                        .background(Color(red: 0.7215686274509804, green: 0.7215686274509804, blue: 0.7215686274509804))
                        .cornerRadius(30)
                    
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color(red: 0.7215686274509804, green: 0.7215686274509804, blue: 0.7215686274509804))
                    
                    Button(action: {
                        withAnimation {
                            showFilterView = !showFilterView
                            if showSortFilterView {
                                showSortFilterView = false
                            }
                        }
                    }) {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(Color(red: 0.7215686274509804, green: 0.7215686274509804, blue: 0.7215686274509804))
                    }
                }
                .padding(.horizontal)
                .offset(CGSize(width: 0, height: -20))
                
                // Filter chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(Array(filterState.selectedTypes), id: \.self) { type in
                            HStack(spacing: 8) {
                                Text(PokemonType.typesToSpanish[type] ?? type.capitalized) // Nombre del tipo en español
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(PokemonType.getColor(for: type)) // Fondo del chip con color del tipo
                                    .cornerRadius(20)
                                    .foregroundColor(.white)
                                
                             
                            }
                            .padding(.trailing, 8).onTapGesture {
                                filterState.selectedTypes.remove(type)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .offset(CGSize(width: 0, height: 22.5))
            }
            .ignoresSafeArea()
        }
    }
}
