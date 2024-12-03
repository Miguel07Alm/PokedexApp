//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Aula03 on 19/11/24.
//

import SwiftUI

@main
struct PokedexApp: App {
    @State private var showFilterView = false

    var body: some Scene {
        WindowGroup {
            LoginView().environmentObject(ViewModel())

        }
    }
}
