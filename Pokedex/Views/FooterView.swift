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
                                    await atacar(teamId: 1)
                                    await atacar(teamId: 2)
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
        
        private func addToCombatLog(_ message: String) {
            combatLog.append(message)
            if combatLog.count > 100 {
                combatLog.removeFirst()
            }
        }
        
        private func atacar(teamId: Int) async {
            guard let team = pokemonTeam.getTeam(named: teamId == 1 ? "Equipo1" : "Equipo2") else {
                addToCombatLog("Equipo \(teamId) no encontrado")
                return
            }
            
            var teamDamage = 0
            for poke in team.pokemons.compactMap({ $0 }) {
                let (moveName, moveAcc, movePower) = await randomMove(poke: poke)
                
                addToCombatLog("Pokémon \(poke.name) usa \(moveName)")
                addToCombatLog("Precisión: \(moveAcc) | Daño: \(movePower)")
                
                if moveAcc > Int.random(in: 0...99) {
                    teamDamage += movePower
                    addToCombatLog("¡El ataque fue exitoso!")
                } else {
                    addToCombatLog("¡El ataque falló!")
                }
            }
            addToCombatLog("Daño total del equipo \(teamId): \(teamDamage)")
            let teamName = teamId == 2 ? "Equipo1" : "Equipo2"
            pokemonTeam.setTeamHealth(named: teamName, hp: (pokemonTeam.getTeamHealth(named: teamName) - teamDamage))
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

 

