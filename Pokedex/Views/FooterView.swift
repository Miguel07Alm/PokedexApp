import SwiftUI

    struct FooterView: View {
        @StateObject private var pokemonTeam = PokemonTeam.shared
        @StateObject var pokemonViewModel = PokemonViewModel()
        @StateObject private var refreshManager = RefreshManager.shared
        
        @State var selectedTab: Int
        @State private var combatLog: [String] = []
        
        var onAttackTapped: (() async -> Void)?
        
        
        // Closures opcionales para manejar las acciones
        var onRegisterTapped: (() -> Void)?

        var body: some View {
            VStack {
                ZStack {
                    Image("FooterRojo")
                        .resizable()
                        .frame(height: 200)
                    
                    switch selectedTab {
                    case 0: // Registro
                        HStack {
                            NavigationLink(destination: MainView(showSortFilterView: false, showFilterView: false, irA: "Pokedex")) {
                                Text("")
                            }
                            .buttonStyle(BotonRegistroGrande())
                        }
                        .offset(CGSize(width: 0, height: 35))
                        
                    case 1: // Average
#if !v2
                        HStack(spacing: 120) {
                            NavigationLink(destination: MainView(showSortFilterView: false, showFilterView: false, irA: "Pokedex")) {
                                Text("")
                            }
                            .buttonStyle(BotonPokedex())
                            
                            NavigationLink(destination: MainView(irA: "Perfil")) {
                                Text("")
                            }
                            .buttonStyle(BotonPerfil())
                        }
                        .offset(CGSize(width: 0, height: 35))
#else
                        HStack(spacing: 83) {
                            NavigationLink(destination: MainView(showSortFilterView: false, showFilterView: false, irA: "Pokedex")) {
                                Text("")
                            }
                            .buttonStyle(BotonPokedex())
                            
                            NavigationLink(destination: MainView(irA: "Perfil")) {
                                Text("")
                            }
                            .buttonStyle(BotonPerfilGrande())
                            
                            NavigationLink(destination: MainView(irA: "TeamsCombate")) {
                                Text("")
                            }
                            .buttonStyle(BotonCombate())
                        }
                        .offset(CGSize(width: 0, height: 35))
                    #endif
                        
                    case 2: // Combate
                        HStack {
                            Button(action: {
                                Task {
                                    var fastestTeam = pokemonTeam.isFaster(named: "Equipo1", thanNamed: "Equipo2") ? "Equipo1" : "Equipo2"
                                    var slowestTeam = fastestTeam == "Equipo1" ? "Equipo2" : "Equipo1"
                                    print("Comienza atacando el \(fastestTeam) ")
                                    
                                    await atacar(teamName: fastestTeam, enemyTeamName: slowestTeam)
                                    if(pokemonTeam.getTeamHealth(named: slowestTeam) < 1 ){
                                        print("se mamo el \(slowestTeam)")
                                    }
                                    await atacar(teamName: slowestTeam, enemyTeamName: fastestTeam)
                                    
                                    if(pokemonTeam.getTeamHealth(named: fastestTeam) < 1 ){
                                        print("se mamo el \(fastestTeam)")
                                    }
                                    refreshManager.forceRefresh()
                                }
                            }) {
                                Text("")
                            }
                            .buttonStyle(BotonCombateGrande())
                        }
                        .offset(CGSize(width: 0, height: 35))
                        
                    case 3: // Confirmar selecion pokemon
                        HStack {
                            NavigationLink(destination: MainView(irA: "TeamsCombate")) {
                                Text("")
                            }
                            .buttonStyle(BotonConfirmarGrande())
                        }
                        .offset(CGSize(width: 0, height: 35))
                    default:
                        Text("La cagÜe")
                    }
                }
            }
            .ignoresSafeArea()
        }
        
        private func atacar(teamName: String, enemyTeamName : String) async {
            guard let team = pokemonTeam.getTeam(named: teamName) else {
                pokemonTeam.addToCombatLog("\(teamName) no encontrado")
                return
            }
            
            var teamDamage = 0
            for poke in team.pokemons.compactMap({ $0 }) {
                let (moveName, moveAcc, movePower) = await randomMove(poke: poke)
                
                pokemonTeam.addToCombatLog("Pokémon \(poke.name) usa \(moveName)")
                pokemonTeam.addToCombatLog("Precisión: \(moveAcc) | Daño: \(movePower)")
                
                if moveAcc > Int.random(in: 0...99) {
                    teamDamage += movePower
                    pokemonTeam.addToCombatLog("¡El ataque fue exitoso!")
                } else {
                    pokemonTeam.addToCombatLog("¡El ataque falló!")
                }
            }
            pokemonTeam.addToCombatLog("Daño total del equipo \(teamName): \(teamDamage)")
            pokemonTeam.setTeamHealth(named: enemyTeamName, hp: (pokemonTeam.getTeamHealth(named: enemyTeamName) - teamDamage))
        }
        
        private func randomMove(poke: Pokemon) async -> (name: String, accuracy: Int, power: Int) {
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
        
        private func queryMoves(name: String) async -> (accuracy: Int, power: Int) {
            await withCheckedContinuation { continuation in
                pokemonViewModel.fetchMoveInfoByName(name: name) { result in
                    switch result {
                    case .success(let details):
                        continuation.resume(returning: (details.accuracy ?? 0, details.power ?? 0))
                    case .failure(let error):
                        print("Error fetching details: \(error)")
                        continuation.resume(returning: (0, 0))
                    }
                }
            }
        }
    }

 

