import SwiftUI


struct SeleccionarEquipoView: View {
    @State var teamId : Int
    var body: some View{
        VStack() {
            ZStack{
                Rectangle()
                    .frame(height: 175)
                    .foregroundColor(Color(red: 0.5764705882352941, green: 0.7372549019607844, blue: 0.7372549019607844))
                    .clipShape(
                        .rect(
                            topLeadingRadius: 48,
                            topTrailingRadius: 48
                        )
                    )
                
                HStack(spacing: 25){
                    ForEach(0..<3, id: \.self) { i in
                        if (i < PokemonTeam.shared.getTeam(named: "Equipo 1")?.pokemons.count ?? 0) {
                            ImagenPokemonSeleccionado(img:PokemonTeam.shared.getTeam(named: "Equipo 1")?.pokemons[i].sprites.other?.officialArtwork?.frontDefault ?? "")
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
        AsyncImage(url: URL(string: img)) { phase in
            switch phase {
            case .empty:
                // Mientras la imagen se carga
                ProgressView()
            case .success(let image):
                // Cuando la imagen se cargó correctamente
                image
                    .resizable()
                    .scaledToFit()
            case .failure:
                // Si hay un error al cargar la imagen
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
            @unknown default:
                // Fallback para futuros casos
                EmptyView()
            }
        }
        .background(Color(red: 0.9333333333333333, green: 0.9333333333333333, blue: 0.9333333333333333))
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

#Preview{
    @State var teamId: Int = 0;
    SeleccionarEquipoView(teamId: teamId)
}
    

