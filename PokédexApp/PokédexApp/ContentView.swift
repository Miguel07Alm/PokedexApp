//
//  ContentView.swift
//  PokédexApp
//
//  Created by Aula03 on 12/11/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        // Ejemplo de uso del gradiente con los tipos "Fuego" y "Agua"
        PokemonType.getGradient(for: ["Fuego"])
            .edgesIgnoringSafeArea(.all)
    }
}


#Preview {
    ContentView()
}
