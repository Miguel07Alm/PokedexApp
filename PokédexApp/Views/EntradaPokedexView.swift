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
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
            
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
    }
}



