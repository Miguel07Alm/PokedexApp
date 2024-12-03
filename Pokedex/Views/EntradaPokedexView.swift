//
//  SwiftUIView.swift
//  PokédexApp
//
//  Created by Aula03 on 12/11/24.
//

import SwiftUI

struct EntradaPokedexView: View {
    @State var name: String
    @State var number: Int
    @State var image: String
    @State var backgroundColor: Color
    
    var body: some View {
        ZStack {
            ImagenPokemon(img: $image)
            CombinedShape(name: $name, num: $number).foregroundColor(backgroundColor.opacity(0.95))
        }
    }
}
struct ImagenPokemon: View {
    @Binding var img: String
    var body: some View {
        VStack {
            Image(img)
                .resizable()
        }
        .frame(width: 150, height: 150)
        .background(Color(red: 0.9333333333333333, green: 0.9333333333333333, blue: 0.9333333333333333))
    }
}


// Línea vertical
struct VerticalLine: View {
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 15))     // Empezamos después del corte
            path.addLine(to: CGPoint(x: 12, y: 0))   // Diagonal superior
            path.addLine(to: CGPoint(x: 12, y: 100)) // Línea vertical derecha
            path.addLine(to: CGPoint(x: 0, y: 100))  // Línea inferior
            path.addLine(to: CGPoint(x: 0, y: 15))   // Cerramos el path
        }
    }
}

// Rectángulo pequeño con corte diagonal
struct SmallRectangle: View {
    @Binding var num: Int
    var body: some View {
        ZStack {
            Path { path in
                path.move(to: CGPoint(x: 15, y: 0))  // Empezamos desde el punto después del corte
                path.addLine(to: CGPoint(x: 60, y: 0))  // Línea superior
                path.addLine(to: CGPoint(x: 60, y: 30)) // Lado derecho
                path.addLine(to: CGPoint(x: 0, y: 30))  // Línea inferior
                path.addLine(to: CGPoint(x: 0, y: 15))  // Lado izquierdo
                path.addLine(to: CGPoint(x: 15, y: 0))  // Diagonal para el corte
            }
            
            Text("#0\(num)")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color(red: 0.9215686274509803, green: 0.9215686274509803, blue: 0.9215686274509803))
                .offset(x:-40,y:-58)
        }
    }
}

// Forma curva inferior
struct CurvedBottom: View {
    @Binding var name: String
    var body: some View {
        ZStack {
            BottomRoundedRectangle()
                .frame(width: 150, height: 50)
            
            Text(name)
                .font(.system(size: 23, weight: .medium))
                .foregroundColor(Color(red: 0.9333333333333333, green: 0.9333333333333333, blue: 0.9333333333333333))
        }
    }
}

struct BottomRoundedRectangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let cornerRadius: CGFloat = 25
        
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))
        
        path.addArc(
            center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(0),
            endAngle: .degrees(90),
            clockwise: false
        )
        
        path.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY))
        
        path.addArc(
            center: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY - cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(90),
            endAngle: .degrees(180),
            clockwise: false
        )
        
        path.closeSubpath()
        
        return path
    }
}

// Forma completa combinada
struct CombinedShape: View {
    @Binding var name: String
    @Binding var num: Int
    var body: some View {
        ZStack(alignment: .topLeading) {
            CurvedBottom(name: $name)
                .offset(y: 100)
            
            SmallRectangle(num: $num)
                .offset(x: 80, y: 70)
            
            VerticalLine()
                .offset(x: 138, y: 0)
        }
        .frame(width: 150, height: 150)
    }
}


#Preview {

        EntradaPokedexView(name: "Crabominable", number: 0740, image: "PerfilIcon", backgroundColor: Color.red)

}




