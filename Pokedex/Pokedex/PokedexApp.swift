//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Aula03 on 19/11/24.
//

import SwiftUI

@main
struct PokedexApp: App {
    @State var showSortFilterView: Bool = false
    @State var showFilterView: Bool = false
    @State var teamId: Int = 0

    var body: some Scene {
        WindowGroup {
            InitialView().environmentObject(ViewModel())
        }
    }
}
