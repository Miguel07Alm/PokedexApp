import SwiftUI

    struct FooterView: View {
        @State var selectedTab: Int

        // Closures opcionales para manejar las acciones
        var onRegisterTapped: (() -> Void)?
        var onPokedexTapped: (() -> Void)?
        var onProfileTapped: (() -> Void)?
        var onCombateTapped: (() -> Void)?

        var body: some View {
            VStack {
                ZStack {
                    Image("FooterRojo")
                        .resizable()
                        .frame(height: 200)
                    
                    switch selectedTab {
                    case 0: // Registro
                        HStack {
                            Button(action: {
                                // Llama al closure si no es nulo
                                onRegisterTapped?()
                            }) {
                                Text("")
                            }
                            .buttonStyle(BotonRegistroGrande())
                        }
                        .offset(CGSize(width: 0, height: 35))

                    case 1: // Average
                        #if !v2
                        HStack(spacing: 120) {
                            Button(action: {
                                onPokedexTapped?()
                            }) {
                                Text("")
                            }
                            .buttonStyle(BotonPokedex())

                            Button(action: {
                                onProfileTapped?()
                            }) {
                                Text("")
                            }
                            .buttonStyle(BotonPerfil())
                        }
                        .offset(CGSize(width: 0, height: 35))
                        #else
                        HStack(spacing: 83) {
                            Button(action: {
                                onPokedexTapped?()
                            }) {
                                Text("")
                            }
                            .buttonStyle(BotonPokedex())

                            Button(action: {
                                onProfileTapped?()
                            }) {
                                Text("")
                            }
                            .buttonStyle(BotonPerfilGrande())

                            Button(action: {
                                onCombateTapped?()
                            }) {
                                Text("")
                            }
                            .buttonStyle(BotonCombate())
                        }
                        .offset(CGSize(width: 0, height: 35))
                        #endif

                    case 2: // Combate
                        HStack {
                            Button(action: {
                                onCombateTapped?()
                            }) {
                                Text("")
                            }
                            .buttonStyle(BotonCombateGrande())
                        }
                        .offset(CGSize(width: 0, height: 35))

                    default:
                        Text("La cagÜe")
                    }
                }
            }
            .ignoresSafeArea()
        }
    }

    #Preview {
        FooterViewPreviewWrapper()
    }

    struct FooterViewPreviewWrapper: View {
        @State var selectedTab = 0

        var body: some View {
            FooterView(
                selectedTab: selectedTab,
                onRegisterTapped: {
                    print("Registro button tapped")
                }
                // Los otros closures son opcionales, no necesitas definirlos ahora
            )
        }
    }


