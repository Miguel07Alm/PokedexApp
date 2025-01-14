import SwiftUI

struct FooterView: View {
    #if v2
        @StateObject private var pokemonTeam = PokemonTeam.shared
        @EnvironmentObject var viewModel: ViewModel
    #endif
    @StateObject var pokemonViewModel = PokemonViewModel()
    @StateObject private var refreshManager = RefreshManager.shared

    @State var selectedTab: Int
    @State private var combatLog: [String] = []
    @State private var winnerId: Int = 0
    @State private var goToWinnerPov: Bool = false
    @State private var turno = 1

    // Closures opcionales para manejar las acciones
    var onRegisterTapped: (() -> Void)?

    var body: some View {
        VStack {
            ZStack {
                Image("FooterRojo")
                    .resizable()
                    .frame(height: 200)

                switch selectedTab {
                case 0:  // Registro
                    HStack {
                        Button(action: {
                            onRegisterTapped?()
                        }) {
                            Text("")
                        }
                        .buttonStyle(BotonRegistroGrande())
                    }
                    .offset(CGSize(width: 0, height: 35))

                case 1:  // Average
                    #if !v2
                        HStack(spacing: 120) {
                            NavigationLink(
                                destination: MainView(
                                    showSortFilterView: false,
                                    showFilterView: false, irA: "Pokedex")
                            ) {
                                Text("")
                            }
                            .buttonStyle(BotonPokedex())

                            NavigationLink(destination: MainView(irA: "Perfil"))
                            {
                                Text("")
                            }
                            .buttonStyle(BotonPerfil())
                        }
                        .offset(CGSize(width: 0, height: 35))
                    #else
                        HStack(spacing: 83) {
                            NavigationLink(
                                destination: MainView(
                                    showSortFilterView: false,
                                    showFilterView: false, irA: "Pokedex")
                            ) {
                                Text("")
                            }
                            .buttonStyle(BotonPokedex())

                            NavigationLink(destination: MainView(irA: "Perfil"))
                            {
                                Text("")
                            }
                            .buttonStyle(BotonPerfilGrande())

                            NavigationLink(
                                destination: MainView(irA: "TeamsCombate")
                            ) {
                                Text("")
                            }
                            .buttonStyle(BotonCombate())
                        }
                        .offset(CGSize(width: 0, height: 35))
                    #endif
                #if v2
                    case 2:  // Combate
                        HStack {
                            NavigationLink(
                                destination: MainView(
                                    teamId: winnerId, irA: "WinnerPov"),
                                isActive: $goToWinnerPov
                            ) {
                                EmptyView()
                            }
                            Button(action: {
                                Task {
                                    if winnerId != 0 {
                                        goToWinnerPov = true
                                        print("WinnerID: \(winnerId)")
                                        // Historial de Batalla
                                        var team1Pokemons: [PokemonEntity] = []
                                        var team2Pokemons: [PokemonEntity] = []
                                        
                                        if let equipo1 = pokemonTeam.getTeam(named: "Equipo1") {
                                            for (index, maybePokemon) in equipo1.pokemons.enumerated() {
                                                guard let pokemon = maybePokemon else {
                                                    print("No hay Pokémon en el slot \(index) del Equipo1.")
                                                    continue
                                                }
                                                // Ahora puedes acceder a pokemon.name, pokemon.id, etc.
                                                print("Pokémon en posición \(index): \(pokemon.name) (ID: \(pokemon.id))")
                                                let pokemonEntity: PokemonEntity = viewModel.createPokemon(name: pokemon.name, pokedexNumber: pokemon.id)!
                                                team1Pokemons.append(pokemonEntity)
                                            }
                                        } else {
                                            print("No se encontró el equipo 'Equipo1' en pokemonTeam.")
                                        }
                                        
                                        if let equipo2 = pokemonTeam.getTeam(named: "Equipo2") {
                                            for (index, maybePokemon) in equipo2.pokemons.enumerated() {
                                                guard let pokemon = maybePokemon else {
                                                    print("No hay Pokémon en el slot \(index) del Equipo2.")
                                                    continue
                                                }
                                                // Ahora puedes acceder a pokemon.name, pokemon.id, etc.
                                                print("Pokémon en posición \(index): \(pokemon.name) (ID: \(pokemon.id))")
                                                let pokemonEntity: PokemonEntity = viewModel.createPokemon(name: pokemon.name, pokedexNumber: pokemon.id)!
                                                team2Pokemons.append(pokemonEntity)
                                            }
                                        } else {
                                            print("No se encontró el equipo 'Equipo1' en pokemonTeam.")
                                        }
                                        
                                        if let team1 = viewModel.createTeam(name: "Equipo1", pokemons: team1Pokemons) {
                                            print("Equipo1 creado con ID: \(team1.id?.uuidString ?? "sin id")")
                                            
                                            if let team2 = viewModel.createTeam(name: "Equipo2", pokemons: team2Pokemons) {
                                                print("Equipo2 creado con ID: \(team2.id?.uuidString ?? "sin id")")
                                                
                                                if let battle = viewModel.createBattle(equipo1: team1, equipo2: team2, winner: winnerId) {
                                                    print("Batalla creada con ID: \(battle.idBatalla?.uuidString ?? "sin id")")
                                                }
                                            }
                                            
                                        }
                                        return
                                    }
                                    var fastestTeam =
                                        pokemonTeam.isFaster(
                                            named: "Equipo1",
                                            thanNamed: "Equipo2")
                                        ? "Equipo1" : "Equipo2"
                                    var slowestTeam =
                                        fastestTeam == "Equipo1"
                                        ? "Equipo2" : "Equipo1"
                                    pokemonTeam.addToCombatLog("Turno \(turno)")
                                    pokemonTeam.addToCombatLog(
                                        "Comienza atacando el \(fastestTeam)")
                                    pokemonTeam.addToCombatLog("")

                                    await atacar(
                                        teamName: fastestTeam,
                                        enemyTeamName: slowestTeam)
                                    print("Rapido ataca")
                                    refreshManager.forceRefresh()
                                    if pokemonTeam.getTeamHealth(
                                        named: slowestTeam) < 1
                                    {
                                        pokemonTeam.addToCombatLog(
                                            "El \(slowestTeam) fue derrotado!!!"
                                        )
                                        winnerId =
                                            fastestTeam == "Equipo1" ? 1 : 2
                                        return
                                    }
                                    await atacar(
                                        teamName: slowestTeam,
                                        enemyTeamName: fastestTeam)
                                    print("lento ataca")
                                    if pokemonTeam.getTeamHealth(
                                        named: fastestTeam) < 1
                                    {
                                        pokemonTeam.addToCombatLog(
                                            "El \(fastestTeam) fue derrotado!!!"
                                        )
                                        winnerId =
                                            slowestTeam == "Equipo1" ? 1 : 2
                                    }
                                    turno += 1
                                    refreshManager.forceRefresh()
                                }
                            }) {
                                Text("")
                            }
                            .buttonStyle(BotonCombateGrande())
                        }
                        .offset(CGSize(width: 0, height: 35))

                    case 3:  // Confirmar selecion pokemon
                        HStack {
                            NavigationLink(
                                destination: MainView(irA: "TeamsCombate")
                            ) {
                                Text("")
                            }
                            .buttonStyle(BotonConfirmarGrande())
                        }
                        .offset(CGSize(width: 0, height: 35))
                #endif
                default:
                    Text("La cagÜe")
                }
            }
        }
        .ignoresSafeArea()
    }
    #if v2
        private func atacar(teamName: String, enemyTeamName: String) async {
            guard let team = pokemonTeam.getTeam(named: teamName) else {
                pokemonTeam.addToCombatLog("\(teamName) no encontrado")
                return
            }

            var teamDamage = 0
            var i = 0
            for poke in team.pokemons.compactMap({ $0 }) {
                let (moveName, moveAcc, movePower) = await randomMove(
                    poke: poke)
                pokemonTeam.addToCombatLog(
                    "\(poke.name.capitalizedFirstLetter()) usa \(moveName.capitalizedFirstLetter())"
                )
                pokemonTeam.addToCombatLog(
                    "Precisión: \(moveAcc) | Daño: \(movePower)")

                if moveAcc > Int.random(in: 0...99) {
                    teamDamage += movePower
                    pokemonTeam.addPokemonDamage(
                        named: teamName, pos: i, damage: movePower)
                    i += 1
                    pokemonTeam.addToCombatLog("¡El ataque fue exitoso!")
                } else {
                    pokemonTeam.addToCombatLog("¡El ataque falló!")
                }
                pokemonTeam.addToCombatLog("")
            }
            pokemonTeam.addToCombatLog(
                "Daño total del \(teamName): \(teamDamage)")
            pokemonTeam.setTeamHealth(
                named: enemyTeamName,
                hp: (pokemonTeam.getTeamHealth(named: enemyTeamName)
                    - teamDamage))
            pokemonTeam.addToCombatLog("")
        }

        private func randomMove(poke: Pokemon) async -> (
            name: String, accuracy: Int, power: Int
        ) {
            var moveName = ""
            var moveAcc = 0
            var movePower = 0

            repeat {
                let randMove = Int.random(in: 0..<poke.moves.count)
                moveName = poke.moves[randMove].move.name
                let result = await queryMoves(name: moveName)
                moveAcc = result.accuracy
                movePower = result.power
            } while movePower == 0 || moveAcc == 0

            return (moveName, moveAcc, movePower)
        }

        private func queryMoves(name: String) async -> (
            accuracy: Int, power: Int
        ) {
            await withCheckedContinuation { continuation in
                pokemonViewModel.fetchMoveInfoByName(name: name) { result in
                    switch result {
                    case .success(let details):
                        continuation.resume(
                            returning: (
                                details.accuracy ?? 0, details.power ?? 0
                            ))
                    case .failure(let error):
                        print("Error fetching details: \(error)")
                        continuation.resume(returning: (0, 0))
                    }
                }
            }
        }
    #endif
}
