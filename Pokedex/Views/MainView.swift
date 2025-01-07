import SwiftUI

struct MainView: View {
    @StateObject private var refreshManager = RefreshManager.shared
    @State var showSortFilterView: Bool
    @State var showFilterView: Bool
    @State var teamId: Int
    @State var pokemon: Pokemon
    @State var irA: String
    @State var selectedTab: Int
    
    
    init(showSortFilterView: Bool = false, showFilterView: Bool = false, pokemon : Pokemon = PokemonType.getAveraged() ,teamId: Int = 0, irA: String) {
        self.showSortFilterView = showSortFilterView
        self.showFilterView = showFilterView
        self.teamId = teamId
        self.pokemon = pokemon
        self.irA = irA
        self._selectedTab = State(initialValue: Self.getInitialTab(for: irA))
    }
    var body: some View {
        VStack(spacing: -100) {
            switch irA {
            case "Login":
                LoginView()
            case "Registro":
                RegisterView()
            case "Pokedex":
                PokedexView(
                    showSortFilterView: showSortFilterView,
                    showFilterView: showFilterView,
                    teamId: 0
                )
                
            case "Detalle":
                PokemonDetailView(pokemon: pokemon)
            case "Perfil":
                ProfileView()
#if v2
            case "TeamsCombate":
                TeamsCombateView()
            case "WinnerPov":
                WinnerPovView(teamId: teamId)
            case "Combate":
                CombateView()
            case "SeleccionarEquipo":
                PokedexView(
                    showSortFilterView: showSortFilterView,
                    showFilterView: showFilterView,
                    teamId: teamId
                )
#endif
            default:
                Text("la cague")
            }
            FooterView(selectedTab: selectedTab)
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
        .onChange(of: irA) { newValue in
            selectedTab = Self.getInitialTab(for: newValue)
        }
    }

    static func getInitialTab(for irA: String) -> Int {
        switch irA {
        case "Login", "Registro":
            return 0
            #if v2
        case "Combate":
            return 2
        case "SeleccionarEquipo":
            return 3
            #endif
        default:
            return 1
        }
    }
}

#Preview {
    @State var showSortFilterView: Bool = false
    @State var showFilterView: Bool = false
    @State var teamId: Int = 1
    @State var irA: String = "esta"
    
    MainView(showSortFilterView: showSortFilterView, showFilterView: showFilterView, teamId: teamId, irA: irA)
}

