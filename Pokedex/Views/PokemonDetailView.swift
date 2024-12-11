//
//  PokemonDetailView.swift
//  PokédexApp
//
//  Created by Aula03 on 19/11/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct PokemonDetailView: View {
    var body: some View {
        VStack (spacing: -100){
            CabeceraConNombre()
            ZStack {
                Rectangle().cornerRadius(48).foregroundColor( PokemonType.getColor(for: "electric"))
                VStack {
                    //Imagen Carrusel
                    AutoScroller(imageNames: ["https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png", "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/25.png", "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/25.png", "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/25.png", "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/showdown/female/25.gif"]).cornerRadius(48).frame(height: 100)
                    
                    //Botones de extrella y boton altavoz
                    HStack (spacing: 100){
                        Button {
                            //
                        }label:{
                            Image(systemName: "star").foregroundColor(.gray).font(.system(size: 35))
                        }
                        Button{
                            
                        }label:{
                            Image(systemName: "speaker.3.fill").foregroundColor(.gray).font(.system(size: 35))
                        }
                    }
                }
            }.ignoresSafeArea()
        }
    }
}

struct CabeceraConNombre : View{
    var body: some View {
        ZStack{
            Rectangle().foregroundColor(.white)
            //Image("CabeceraSinNada").resizable().frame(height: 150)
            Text("Pokemon 006")
        }.ignoresSafeArea().frame(alignment: .top).frame(height: 175)
    }
}

struct AutoScroller: View {
    var imageNames: [String]
    let timer = Timer.publish(every: 7.0, on: .main, in: .common).autoconnect()
    @State private var selectedImageIndex: Int = 0

    var body: some View {
        ZStack {
            // Step 4: Background Color
            Color.secondary
                .ignoresSafeArea()

            // Step 5: Create TabView for Carousel
            TabView(selection: $selectedImageIndex) {
                // Step 6: Iterate Through Images
                ForEach(0..<imageNames.count, id: \.self) { index in
                    ZStack(alignment: .topLeading) {
                        // Step 7: Display Image
                        let url = URL(string: "\(imageNames[index])")!
                        
                        if (index < 4) {
                            // Cargar imágenes normales (sin GIF)
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(20)
                                    .padding()
                            } placeholder: {
                                ProgressView()
                            }
                        } else {
                            // Cargar GIF usando WebImage
                            WebImage(url: url) // Usamos WebImage para manejar GIFs
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(20)
                                .padding()
                        }
                    } // Step 8: Apply Visual Effect Blur
                    .shadow(radius: 20) // Step 9: Apply Shadow
                }
            }
            .frame(height: 300) // Step 10: Set Carousel Height
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Step 11: Customize TabView Style
            .ignoresSafeArea()

            // Step 12: Navigation Dots
            HStack {
                ForEach(0..<imageNames.count, id: \.self) { index in
                    // Step 13: Create Navigation Dots
                    Capsule()
                        .fill(Color.white.opacity(selectedImageIndex == index ? 1 : 0.33))
                        .frame(width: 35, height: 8)
                        .onTapGesture {
                            // Step 14: Handle Navigation Dot Taps
                            selectedImageIndex = index
                        }
                }
                .offset(y: 130) // Step 15: Adjust Dots Position
            }
        }
        .onReceive(timer) { _ in
            // Step 16: Auto-Scrolling Logic
            withAnimation(.default) {
                selectedImageIndex = (selectedImageIndex + 1) % imageNames.count
            }
        }
    }
}



#Preview {
    PokemonDetailView()
}
