import SwiftUI

struct MainView: View {
    @StateObject private var refreshManager = RefreshManager.shared
    @State var showSortFilterView: Bool
    @State var showFilterView: Bool
    @State var teamId: Int
    //@State var teamHealth : [Int]
    @State var irA: String
    @State var selectedTab: Int
    
    
    init(showSortFilterView: Bool = false, showFilterView: Bool = false, teamId: Int = 0, teamHealth : [Int] = [0,0], irA: String) {
        self.showSortFilterView = showSortFilterView
        self.showFilterView = showFilterView
        self.teamId = teamId
        self.irA = irA
        self._selectedTab = State(initialValue: Self.getInitialTab(for: irA))
    }
    @State var pokemon : Pokemon = PokemonType.getAveraged()
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
            
            case "TeamsCombate":
                TeamsCombateView()
            case "Perfil":
                ProfileView()
            case "Combate":
                CombateView()
            case "SeleccionarEquipo":
                PokedexView(
                    showSortFilterView: showSortFilterView,
                    showFilterView: showFilterView,
                    teamId: teamId
                )
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
        case "Combate":
            return 2
        case "SeleccionarEquipo":
            return 3
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

