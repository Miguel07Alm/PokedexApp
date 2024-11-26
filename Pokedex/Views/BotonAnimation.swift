//
//  BotonAnimation.swift
//  Pokedex
//
//  Created by Aula03 on 26/11/24.
//

import Foundation
import SwiftUI

struct BotonGenerico: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
    configuration.label
        .padding()
        .background(
            ZStack {
                Rectangle()
                    .fill(.gray)
                    .cornerRadius(16)
                    .offset(y:configuration.isPressed ? 0 : 5)
                    .offset(x:configuration.isPressed ? 0 : 4)
                    
                Rectangle()
                    .fill(.white)
                    .cornerRadius(16)
            }
        )
        .offset(y:configuration.isPressed ? 9 : 0)
        .offset(x:configuration.isPressed ? 7 : 0)
    }
}

struct BotonPokedex: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
    configuration.label
        .padding()
        .background(
            ZStack {
                Rectangle()
                    .foregroundColor(Color(hue: 0.056, saturation: 0.927, brightness: 0.505))
                    .cornerRadius(16)
                    .offset(y:configuration.isPressed ? 0 : 5)
                    .offset(x:configuration.isPressed ? 0 : 4)
                    
                Rectangle()
                    .cornerRadius(16)
                    .foregroundColor(Color(red: 0.8823529411764706, green: 0.4117647058823529, blue: 0.17254901960784313))
                
                Image("PokedexIcon")
                    .resizable()
                    .frame(width: 55, height: 55)
                    .opacity(0.6)
                
            }.frame(width: 75, height: 75)
        )
        .offset(y:configuration.isPressed ? 9 : 0)
        .offset(x:configuration.isPressed ? 7 : 0)
    }
}

struct BotonPerfil: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
    configuration.label
        .padding()
        .background(
            ZStack {
                Rectangle()
                    .foregroundColor(Color(red: 0.1450980392156863, green: 0.050980392156862744, blue: 0.050980392156862744))
                    .cornerRadius(16)
                    .offset(y:configuration.isPressed ? 0 : 5)
                    .offset(x:configuration.isPressed ? 0 : 4)
                
                Rectangle()
                    .foregroundColor(Color(red: 0.228, green: 0.053, blue: 0.053))
                    .cornerRadius(16)
                
                Image("PerfilIcon")
                    .resizable()
                    .opacity(0.55)
                    .frame(width: 50, height: 50)
                
            }.frame(width: 75, height: 75)
        )
        .offset(y:configuration.isPressed ? 5 : 0)
        .offset(x:configuration.isPressed ? 4 : 0)
    }
}

struct BotonPerfilGrande: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
    configuration.label
        .padding()
        .background(
            ZStack {
                Rectangle()
                    .foregroundColor(Color(red: 0.1450980392156863, green: 0.050980392156862744, blue: 0.050980392156862744))
                    .cornerRadius(16)
                    .offset(y:configuration.isPressed ? 0 : 5)
                    .offset(x:configuration.isPressed ? 0 : 4)
                
                Rectangle()
                    .foregroundColor(Color(red: 0.228, green: 0.053, blue: 0.053))
                    .cornerRadius(16)
                
                Image("PerfilIcon")
                    .resizable()
                    .opacity(0.55)
                    .frame(width: 60, height: 60)
                
            }.frame(width: 90, height: 90)
        )
        .offset(y:configuration.isPressed ? 5 : 0)
        .offset(x:configuration.isPressed ? 4 : 0)
    }
}

struct BotonCombate: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
    configuration.label
        .padding()
        .background(
            ZStack {
                Rectangle()
                    .foregroundColor(Color(red: 0.4235294117647059, green: 0.12941176470588237, blue: 0.12941176470588237))
                    .cornerRadius(16)
                    .offset(y:configuration.isPressed ? 0 : 5)
                    .offset(x:configuration.isPressed ? 0 : 4)
                
                Rectangle()
                    .foregroundColor(Color(red: 0.6392156862745098, green: 0.1568627450980392, blue: 0.1568627450980392))
                    .cornerRadius(16)
                
                Image("PerfilIcon")
                    .resizable()
                    .opacity(0.55)
                    .frame(width: 50, height: 50)
                
            }.frame(width: 75, height: 75)
        )
        .offset(y:configuration.isPressed ? 5 : 0)
        .offset(x:configuration.isPressed ? 4 : 0)
    }
}


