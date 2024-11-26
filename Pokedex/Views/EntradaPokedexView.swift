//
//  SwiftUIView.swift
//  PokédexApp
//
//  Created by Aula03 on 12/11/24.
//

import SwiftUI

struct EntradaPokedexView: View {
    let name: String
    let number: String
    let image: String
    let backgroundColor: Color
    
    var body: some View {
        VStack {
            Image(image)
                .resizable()
            
            Text(name)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
            
            Text("#\(number)")
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
        .padding()
        .background(backgroundColor.opacity(0.2))
        .cornerRadius(12)
        .frame(width: 150, height: 150)
    }
}

#Preview {
    EntradaPokedexView(name: "PerfilIcon", number: "2", image: "PerfilIcon", backgroundColor: Color.red)
}




