import SwiftUI


struct SeleccionarEquipoView: View {
    @Binding var image: String
    var body: some View{
        VStack() {
            // Search bar
            ZStack{
                Rectangle()
                    .frame(height: 175)
                    .foregroundColor(Color(red: 0.5764705882352941, green: 0.7372549019607844, blue: 0.7372549019607844))

                HStack(spacing: 25){
                        ImagenPokemonSeleccionado(img: $image)
                        ImagenPokemonNoSeleccionado()
                        ImagenPokemonNoSeleccionado()
                }.offset(y: -25)
         
            }.ignoresSafeArea()
        }
    }
}

struct ImagenPokemonSeleccionado: View {
    @Binding var img: String
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

struct SeleccionarEquipo: View {
    @Binding var showSortFilterView: Bool
    @Binding var showFilterView: Bool
    @Binding var image: String
    @Binding var pokemons: [Pokemon];
    var body: some View {
        VStack(spacing: -50) {
            HeaderView(
                showSortFilterView: $showSortFilterView,
                showFilterView: $showFilterView)
            SeleccionarEquipoView(image: $image).cornerRadius(48)
            ListaPokedexView(pokemons: $pokemons,
                showSortFilterView: $showSortFilterView,
                showFilterView: $showFilterView
            )
        }.ignoresSafeArea()
    }
}

#Preview{
    @State var showSortFilterView: Bool = false
    @State var showFilterView: Bool = false
    @State var image: String = "aceptar"
    @State var pokemons: [Pokemon] = [];
    SeleccionarEquipo(showSortFilterView: $showSortFilterView, showFilterView: $showFilterView, image: $image, pokemons: $pokemons)
}
    

