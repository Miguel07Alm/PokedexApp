import SwiftUI


struct SeleccionarEquipoView: View {
    @State var pokemonTeam : [Pokemon]
    var body: some View{
        VStack() {
            ZStack{
                Rectangle()
                    .frame(height: 175)
                    .foregroundColor(Color(red: 0.5764705882352941, green: 0.7372549019607844, blue: 0.7372549019607844))

                HStack(spacing: 25){
                    ForEach(0..<3, id: \.self) { i in
                        if i < pokemonTeam.count {
                            ImagenPokemonSeleccionado(img: pokemonTeam[i].sprites.other?.officialArtwork?.frontDefault ?? "")
                        } else {
                            ImagenPokemonNoSeleccionado()
                        }
                    }
                }.offset(y: -25)
         
            }.ignoresSafeArea()
        }
    }
}

struct ImagenPokemonSeleccionado: View {
    @State var img: String
    var body: some View {
        VStack {
            Image(img)
                .resizable()
                .background(Color(red: 0.9333333333333333, green: 0.9333333333333333, blue: 0.9333333333333333))
        }
        .frame(width: 90, height: 90)
        .clipShape(
            .rect(
                topLeadingRadius: 25,
                bottomLeadingRadius: 25,
                bottomTrailingRadius: 25
            )
        )
    }
}

struct ImagenPokemonNoSeleccionado: View {
    var body: some View {
        VStack {
            Image(systemName: "plus")
                .resizable()
                .foregroundColor(Color(red: 0.5764705882352941, green: 0.7372549019607844, blue: 0.7372549019607844))
                .frame(width: 50, height: 50)
        }
        .frame(width: 90, height: 90)
        .background(Color(red: 0.7529411764705882, green: 0.8588235294117647, blue: 0.8588235294117647))
        .clipShape(
            .rect(
                topLeadingRadius: 25,
                bottomLeadingRadius: 25,
                bottomTrailingRadius: 25
            )
        )
    }
}


//Prwwiew
struct SeleccionarEquipo: View {
    @Binding var showSortFilterView: Bool
    @Binding var showFilterView: Bool
    @Binding var pokemons: [Pokemon];
    var body: some View {
        VStack(spacing: -50) {
            HeaderView(
                showSortFilterView: $showSortFilterView,
                showFilterView: $showFilterView)
            SeleccionarEquipoView(pokemonTeam: pokemons).cornerRadius(48)
            ListaPokedexView(
                showSortFilterView: $showSortFilterView,
                showFilterView: $showFilterView
            )
        }.ignoresSafeArea()
    }
}

#Preview{
    @State var showSortFilterView: Bool = false
    @State var showFilterView: Bool = false
    @State var pokemons: [Pokemon] = [];
    SeleccionarEquipo(showSortFilterView: $showSortFilterView, showFilterView: $showFilterView, pokemons: $pokemons)
}
    

