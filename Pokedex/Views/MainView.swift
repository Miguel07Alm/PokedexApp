import SwiftUI

struct MainView: View {
    @StateObject private var refreshManager = RefreshManager.shared
    @State var showSortFilterView: Bool
    @State var showFilterView: Bool
    @State var teamId: Int
    @State var selectedTab: Int
    @State var irA : String
    
    var body: some View {
        VStack(spacing: -100) {
            switch selectedTab {
            case 0: // Registro o iniciar Sesion
                LoginView()
            case 1: //Todo
                PokedexView(
                    showSortFilterView: showSortFilterView,
                    showFilterView: showFilterView,
                    teamId: 0
                    )
            case 2: //Combate
                CombateView()
            case 3: //Seleccion COmbate Pokemons
                PokedexView(
                showSortFilterView: showSortFilterView,
                showFilterView: showFilterView,
                teamId: teamId
                )
            default:
                Text("la cague")
            }
            FooterView(selectedTab: selectedTab)        }.ignoresSafeArea().navigationBarBackButtonHidden()
    }
}

#Preview {
    @State var showSortFilterView: Bool = false
    @State var showFilterView: Bool = false
    @State var teamId: Int = 1
    @State var selectedTab : Int = 2
    @State var irA : String = "esta"
    
    MainView(showSortFilterView: showSortFilterView, showFilterView: showFilterView, teamId: teamId, selectedTab: selectedTab, irA: irA)
}
