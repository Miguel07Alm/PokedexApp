import SwiftUI

struct MainView: View {
    @StateObject private var refreshManager = RefreshManager.shared
    @State var showSortFilterView: Bool
    @State var showFilterView: Bool
    @State var teamId: Int
    @State var pokemon: Pokemon
    @State var irA: String
    @State var selectedTab: Int
    @State private var isTransitioning = true
    @State private var viewAppeared = false

    init(showSortFilterView: Bool = false, showFilterView: Bool = false, pokemon: Pokemon = PokemonType.getAveraged(), teamId: Int = 0, irA: String) {
        self.showSortFilterView = showSortFilterView
        self.showFilterView = showFilterView
        self.teamId = teamId
        self.pokemon = pokemon
        self.irA = irA
        self._selectedTab = State(initialValue: Self.getInitialTab(for: irA))
    }

    
    var body: some View {
        ZStack {
            destinationView
                .opacity(isTransitioning ? 0 : 1)
            
            VStack {
                Spacer()
                FooterView(selectedTab: selectedTab)
            }
            
            if isTransitioning {
                PokeballTransitionView(isPresented: $isTransitioning, destination: AnyView(destinationView))
                    .zIndex(1)
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
        .onAppear {
            if viewAppeared {
                resetTransitionAndStartAnimation()
            } else {
                startTransitionAndNavigation()
                viewAppeared = true
            }
        }
    }
    
    private func resetTransitionAndStartAnimation() {
          isTransitioning = true
            startTransitionAndNavigation()
      }


    private var destinationView: some View {
        Group {
            switch irA {
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
        }
        .transition(.opacity)

    }

    private func startTransitionAndNavigation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(.easeIn(duration: 1)) {
                isTransitioning = false
            }
            selectedTab = Self.getInitialTab(for: irA)
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
    @State var irA: String = "Login"

    MainView(showSortFilterView: showSortFilterView, showFilterView: showFilterView, teamId: teamId, irA: irA)
}
