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
                    
                    ZStack(alignment: .trailing) {
                               TextField("Buscar", text: $filterState.search)                                  .frame(height: 32)
                                   .textInputAutocapitalization(.never)
                                   .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
                                   .background(Color(red: 0.7215686274509804, green: 0.7215686274509804, blue: 0.7215686274509804))
                                   .cornerRadius(30)
                                   .overlay(
                                    RoundedRectangle(cornerRadius: 30) .stroke(lineWidth: 0.5).fill(Color(red: 0.7215686274509804, green: 0.7215686274509804, blue: 0.7215686274509804))
                                   )
                               if filterState.search.isEmpty {
                                    Image(systemName: "magnifyingglass")
                                       .foregroundColor(.white)
                                       .padding(.trailing, 10)
                               } else {
                                   Button {
                                       filterState.search = ""
                                   } label: {
                                       Image(systemName: "xmark.circle.fill")
                                           .foregroundColor(.white)
                                           .padding(.trailing, 10)
                                   }
                               }
                           }
                           .padding(.horizontal, 10)
                        
                    
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
                                
                                Text("X")
                                    .font(.caption)
                             
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(PokemonType.getColor(for: type)) // Fondo del chip con color del tipo
                            .cornerRadius(20)
                            .foregroundColor(.white).onTapGesture {
                                filterState.selectedTypes.remove(type)
                            }
                        }
                        ForEach(Array(filterState.selectedRegions), id: \.self) { region in
                            HStack(spacing: 8) {
                                Text(region) // Nombre del tipo en español
                                
                                Text("X")
                                    .font(.caption)
                             
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(.black)
                            .cornerRadius(20)
                            .foregroundColor(.white).onTapGesture {
                                filterState.selectedRegions.remove(region)
                            }
                        }                    }
                }
                .padding(.horizontal)
                .offset(CGSize(width: 0, height: 22.5))
            }
            .ignoresSafeArea()
        }
    }
}
