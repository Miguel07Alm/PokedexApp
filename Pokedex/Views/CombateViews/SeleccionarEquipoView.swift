import SwiftUI

struct SeleccionarEquipoView: View {
    @ObservedObject private var pokemonTeam = PokemonTeam.shared
    @State var teamId: Int
    
    var body: some View {
        VStack() {
            ZStack {
                Rectangle()
                    .frame(height: 175)
                    .foregroundColor(Color(red: 0.5764705882352941, green: 0.7372549019607844, blue: 0.7372549019607844))
                    .clipShape(
                        .rect(
                            topLeadingRadius: 48,
                            topTrailingRadius: 48
                        )
                    )
                
                HStack(spacing: 25) {
                    let name = teamId == 1 ? "Equipo1" : "Equipo2"
                    ForEach(0..<3, id: \.self) { i in
                        Button(action: {
                            pokemonTeam.setTeamPos(named: name, pos: i)
                        }) {
                            if (nil != pokemonTeam.getTeam(named: name)?.pokemons[i]) {
                                ImagenPokemonSeleccionado(
                                    img: pokemonTeam.getTeam(named: name)?.pokemons[i]?.sprites.other?.officialArtwork?.frontDefault ?? pokemonTeam.getTeam(named: name)?.pokemons[i]?.sprites.frontDefault ?? "",
                                    isSelected: pokemonTeam.getTeamPos(named: name) == i
                                )
                            } else {
                                ImagenPokemonNoSeleccionado(isSelected:pokemonTeam.getTeamPos(named: name) == i)
                            }
                        }
                    }
                }.offset(y: -25)
            }.ignoresSafeArea()
        }
    }
}

struct ImagenPokemonSeleccionado: View {
    @State var img: String
    var isSelected: Bool
    
    var body: some View {
        AsyncImage(url: URL(string: img)) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
            case .failure:
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
            @unknown default:
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
        .overlay(
            UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(
                topLeading: 25,
                bottomLeading: 25,
                bottomTrailing: 25))
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 5)
        )
    }
}

struct ImagenPokemonNoSeleccionado: View {
    var isSelected: Bool
    var body: some View {
        VStack {
            Image(systemName: "plus")
                .resizable()
                .foregroundColor(Color(red: 0.7529411764705882, green: 0.8588235294117647, blue: 0.8588235294117647))
                .frame(width: 50, height: 50)
        }
        .frame(width: 90, height: 90)
        .background(Color(hue: 0.5, saturation: 0.0, brightness: 0.908))
        .clipShape(
            .rect(
                topLeadingRadius: 25,
                bottomLeadingRadius: 25,
                bottomTrailingRadius: 25
            )
        )
        .overlay(
            UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(
                topLeading: 25,
                bottomLeading: 25,
                bottomTrailing: 25))
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 5)
        )
    }
}

struct SeleccionarEquipoView_Previews: PreviewProvider {
    static var previews: some View {
        @State var teamId: Int = 1
        SeleccionarEquipoView(teamId: teamId)
    }
}

