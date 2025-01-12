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
    @State private var showRottomAnimation = true
    @State private var destinationOpacity = 0.0 // Controlamos la opacidad de la pantalla destino

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
                .opacity(destinationOpacity) // La opacidad de la vista de destino depende de la variable destinationOpacity

            VStack {
                Spacer()
                FooterView(selectedTab: selectedTab)
            }

            if showRottomAnimation {
                RottomPushingAnimationView(onAnimationComplete: {
                    withAnimation(.easeIn(duration: 0.5)) {
                        showRottomAnimation = false // Fade out la animación de Rottom
                    }
                    withAnimation(.easeIn(duration: 0.5)) {
                        destinationOpacity = 1.0 // Fade in la vista de destino después de la animación de Rottom
                    }
                })
                .transition(.opacity) // Transición de opacidad para la animación de Rottom
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
        showRottomAnimation = true
        destinationOpacity = 0.0 // Empezamos con la opacidad de la pantalla destino en 0
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
        .transition(.opacity) // Transición de opacidad para la pantalla destino
    }

    private func startTransitionAndNavigation() {
        DispatchQueue.main.async {
            showRottomAnimation = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeOut(duration: 0.5)) {
                    isTransitioning = false // Suavizamos la transición al final
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    selectedTab = Self.getInitialTab(for: irA)
                }
            }
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
    @State var irA: String = "Pokedex"
    
    MainView(showSortFilterView: showSortFilterView, showFilterView: showFilterView, teamId: teamId, irA: irA)
}
