import SwiftUI

struct MainView: View {
    @StateObject private var refreshManager = RefreshManager.shared
    @State var showSortFilterView: Bool
    @State var showFilterView: Bool
    @State var teamId: Int
    @State var selectedTab: Int
    
    var body: some View {
        VStack(spacing: -100) {
            PokedexView(
                showSortFilterView: showSortFilterView,
                showFilterView: showFilterView,
                teamId: teamId
            )
            FooterView(selectedTab: selectedTab)
        }.ignoresSafeArea().navigationBarBackButtonHidden()
    }
}

#Preview {
    @State var showSortFilterView: Bool = false
    @State var showFilterView: Bool = false
    @State var teamId: Int = 1
    @State var selectedTab : Int = 3
    
    MainView(showSortFilterView: showSortFilterView, showFilterView: showFilterView, teamId: teamId, selectedTab: selectedTab)
}
