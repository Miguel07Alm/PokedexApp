import SwiftUI
import SDWebImageSwiftUI

struct WinnerPovView: View {
    @StateObject private var pokemonTeam = PokemonTeam.shared
    @State var teamId: Int
    
    var body: some View {
        HStack(spacing: 20) {
            let name = teamId == 1 ? "Equipo1" : "Equipo2"
            if let team = pokemonTeam.getTeam(named: name) {
                let sortedIndices = team.pokeDamage.indices.sorted { team.pokeDamage[$0] > team.pokeDamage[$1] }
                
                // Second highest damage (left)
                if sortedIndices.count > 1 {
                    WinnerPokemonDisplay(
                        img: URL(string: team.pokemons[sortedIndices[1]]?.sprites.other?.showdown?.frontDefault ?? "")!,
                        dmg: team.pokeDamage[sortedIndices[1]]
                    )
                    .frame(width: 100, height: 425)
                }
                
                // Highest damage (center)
                if !sortedIndices.isEmpty {
                    WinnerPokemonDisplay(
                        img: URL(string: team.pokemons[sortedIndices[0]]?.sprites.other?.showdown?.frontDefault ?? "")!,
                        dmg: team.pokeDamage[sortedIndices[0]]
                    )
                    .frame(width: 150, height: 525)
                }
                
                // Lowest damage (right)
                if sortedIndices.count > 2 {
                    WinnerPokemonDisplay(
                        img: URL(string: team.pokemons[sortedIndices[2]]?.sprites.other?.showdown?.frontDefault ?? "")!,
                        dmg: team.pokeDamage[sortedIndices[2]]
                    )
                    .frame(width: 100, height: 425)
                }
            }
        }
        .background(Color(red: 0.7529411764705882, green: 0.8588235294117647, blue: 0.8588235294117647))
        .ignoresSafeArea()
    }
    
    private func sortPokemonByDamage(team: Team) -> [(pokemon: Pokemon, damage: Int)] {
        let pokemonWithDamage = zip(team.pokemons, team.pokeDamage)
            .compactMap { pokemon, damage -> (Pokemon, Int)? in
                guard let pokemon = pokemon else { return nil }
                return (pokemon, damage)
            }
        return pokemonWithDamage.sorted { $0.1 > $1.1 }
    }
}

struct PokemonDamageView: View {
    let pokemon: Pokemon
    let damage: Int
    
    var body: some View {
        VStack {
            WebImage(url: URL(string: pokemon.sprites.other?.officialArtwork?.frontDefault ?? ""))
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .background(Color.white.opacity(0.8))
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                .shadow(radius: 5)
            
            Text(pokemon.name.capitalized)
                .font(.caption)
                .fontWeight(.bold)
            
            Text("Daño: \(damage)")
                .font(.caption)
                .foregroundColor(.red)
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(15)
    }
}

struct WinnerPokemonDisplay: View {
    let img: URL
    let dmg: Int
    
    var body: some View {
        VStack {
            WebImage(url: img)
                .resizable()
                .scaledToFit()
                .cornerRadius(20)
                .padding()
            
            Text("Daño: \(dmg)")
                .font(.headline)
                .foregroundColor(.red)
        }
    }
}

struct WinnerPovView_Previews: PreviewProvider {
    static var previews: some View {
        WinnerPovView(teamId: 1)
    }
}

