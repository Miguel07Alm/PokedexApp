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
        VStack (spacing: -50){
            CabeceraConNombre().offset(CGSize(width: 0, height: -20))
            ScrollView {
                ZStack {
                    VStack (spacing: 30){
                        //Imagen Carrusel
                        Spacer(minLength: 75)
                        AutoScroller(imageNames: ["https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png", "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/25.png", "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/25.png", "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/25.png", "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/showdown/female/25.gif"]).cornerRadius(48).frame(height: 100).padding()
                        
                        //Botones de extrella y boton altavoz
                        Spacer(minLength: 45)
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
                        
                        //Tipo y circulo del tipo
                        VStack {
                            ZStack {
                                Circle().frame(height: 40).foregroundColor(.gray)
                                Image("electric_icon").resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                            }
                            Text("Eléctrico").font(.title2)
                        }
                        
                        //Texto peso y altura
                        ZStack {
                            Rectangle().cornerRadius(25).foregroundColor(.white).frame(width: 350).opacity(0.65)
                            HStack {
                                Spacer()
                                VStack (){
                                    Text("Peso").font(.title2)
                                    Text("2 Kg").font(.title2)
                                }.padding()
                                Spacer()
                                VStack (){
                                    Text("Altura").font(.title2)
                                    Text("0,46m").font(.title2)
                                }.padding()
                                Spacer()
                            }
                        }
                        ZStack {
                            Rectangle().cornerRadius(25).foregroundColor(.white).frame(width: 350).opacity(0.65)
                            VStack (){
                                Text("Descripción").font(.title2)
                                Text("Levanta su cola para vigilar los alrededores. A veces, puede ser alcanzado por un rayo en esa Las bolsas de las mejillas están llenas de electricidad, que libera cuando se siente amenazado. Cada vez que Pikachu se encuentra con algo nuevo, le lanza una sacudida eléctrica. Si ves alguna baya chamuscada, seguro que ha sido Pikachu; a veces no controla la intensidad de la descarga. Este Pokémon tiene unas bolsas en las mejillas donde almacena electricidad. Parece ser que se recargan por la noche, mientras Pikachu duerme. A veces, cuando se acaba de despertar y está aún dormido, descarga un poco.").frame(width: 320)
                            }.padding()
                        }
                        
                        ZStack {
                            Rectangle().cornerRadius(25).foregroundColor(.white).frame(width: 350).opacity(0.65)
                            VStack (){
                                Text("Habilidades").font(.title2).frame(height: 60)
                                Text("Electricidad estática").frame(width: 320, alignment: .leading).font(.title3).multilineTextAlignment(.leading)
                                Text("Puede paralizar al mínimo contacto.").frame(width: 320, alignment: .leading)
                                Text("Pararrayos").padding(.top, 15.0).frame(width: 320, alignment: .leading).font(.title3)
                                Text("Atrae y neutraliza movimientos de tipo Eléctrico y sube el At. Esp.").frame(width: 320, alignment: .leading)
                            }.padding()
                        }

                        Text("Estadisticas").font(.title).padding()

                        VStack {
                            StatHexagonView(stats: [
                                StatValue(name: "Attack", value: 25, maxValue: 100),
                                StatValue(name: "Defense", value: 14, maxValue: 100),
                                StatValue(name: "Sp.Atk", value: 22, maxValue: 100),
                                StatValue(name: "Sp.Def", value: 19, maxValue: 100),
                                StatValue(name: "Speed", value: 30, maxValue: 100),
                                StatValue(name: "HP", value: 29, maxValue: 100)
                            ], size: 350)
                        }.frame(width: .infinity).offset(x: 43)
                        
                        Spacer()
                    }
                }.ignoresSafeArea()
            }.background(PokemonType.getColor(for: "electric")).edgesIgnoringSafeArea(.bottom).ignoresSafeArea().cornerRadius(48)
        }.ignoresSafeArea()
    }
}

struct CabeceraConNombre : View{
    var body: some View {
        ZStack{
            Rectangle().foregroundColor(.white)
            //Image("CabeceraSinNada").resizable().frame(height: 150)
            Text("Pokemon #006").font(.title)
        }.ignoresSafeArea().frame(alignment: .top).frame(height: 175)
    }
}

struct StatValue: Identifiable {
    let id = UUID()
    let name: String
    let value: Double
    let maxValue: Double
    
    var percentage: Double {
        value / maxValue
    }
}

struct StatHexagonView: View {
    let stats: [StatValue]
    let size: CGFloat
    let strokeColor: Color
    let fillColor: Color
    
    init(stats: [StatValue], size: CGFloat = 200, strokeColor: Color = .green, fillColor: Color = Color.gray.opacity(0.2)) {
        self.stats = stats
        self.size = size
        self.strokeColor = strokeColor
        self.fillColor = fillColor
    }
    
    private func point(for index: Int, radius: CGFloat) -> CGPoint {
        let angle = (2.0 * .pi * Double(index) / 6.0) - .pi / 2
        return CGPoint(
            x: size/2 + radius * cos(angle),
            y: size/2 + radius * sin(angle)
        )
    }
    
    var body: some View {
        ZStack {
            // Base hexagon
            Path { path in
                for i in 0..<6 {
                    let point = point(for: i, radius: size/2)
                    if i == 0 {
                        path.move(to: point)
                    } else {
                        path.addLine(to: point)
                    }
                }
                path.closeSubpath()
            }
            .stroke(strokeColor, lineWidth: 2)
            
            // Inner lines
            ForEach(0..<6) { i in
                Path { path in
                    path.move(to: CGPoint(x: size/2, y: size/2))
                    path.addLine(to: point(for: i, radius: size/2))
                }
                .stroke(strokeColor.opacity(0.5), lineWidth: 1)
            }
            
            // Stat values
            Path { path in
                for i in 0..<6 {
                    let radius = size/2 * stats[i].percentage
                    let point = point(for: i, radius: radius)
                    if i == 0 {
                        path.move(to: point)
                    } else {
                        path.addLine(to: point)
                    }
                }
                path.closeSubpath()
            }
            .fill(fillColor)
            .overlay(
                Path { path in
                    for i in 0..<6 {
                        let radius = size/2 * stats[i].percentage
                        let point = point(for: i, radius: radius)
                        if i == 0 {
                            path.move(to: point)
                        } else {
                            path.addLine(to: point)
                        }
                    }
                    path.closeSubpath()
                }
                .stroke(strokeColor, lineWidth: 2)
            )
            
            // Stat labels
            ForEach(0..<6) { i in
                let point = point(for: i, radius: size/2 + 20)
                Text(stats[i].name)
                    .font(.caption)
                    .position(point)
            }
            
            // Stat values
            ForEach(0..<6) { i in
                let point = point(for: i, radius: size/2 + 35)
                Text("\(Int(stats[i].value))")
                    .font(.caption)
                    .bold()
                    .position(point)
            }
        }
        .frame(width: size + 80, height: size + 80) // Extra space for labels
    }
}


struct CabeceraContenido : View{
    @State var selectedTab = 1
    var body: some View {
        VStack(spacing:-100){
            PokemonDetailView()
            FooterView(selectedTab: selectedTab)
        }.ignoresSafeArea()
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
    CabeceraContenido()
}
