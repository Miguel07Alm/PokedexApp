import SwiftUI

struct PokeballTransitionView: View {
    @Binding var isPresented: Bool
    let destination: AnyView
    @State private var isClosing = false
    @State private var isSpinning = false
    @State private var isOpening = false
    @State private var backgroundOpacity = 0.0
    @State private var showTransition = true

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if showTransition {
                    // Background color with fade
                    Color.black
                        .opacity(backgroundOpacity)
                    
                    // Centered pokeball container
                    ZStack {
                        // Top semicircle (white)
                        Semicircle(color: .white)
                            .fill(color: .white) // Añadimos .fill(color:) aquí
                            .frame(width: 300, height: 300)
                            .rotation3DEffect(.degrees(180), axis: (1, 0, 0))
                            .offset(y: isClosing ? 0 : -geometry.size.height)
                            .rotationEffect(.degrees(isSpinning ? 360 : 0))
                            .offset(y: isOpening ? -geometry.size.height : 0)
                        
                        // Bottom semicircle (red) with button and line
                        ZStack {
                            // Red semicircle
                            Semicircle(color: .red)
                                .fill(color: .red) // Añadimos .fill(color:) aquí
                                .frame(width: 300, height: 300)
                            
                            // Black line on the flat part
                            Rectangle()
                                .frame(width: 300, height: 8)
                                .foregroundColor(.black)
                                .offset(y: 0)
                            
                            // Pokeball button
                            Circle()
                                .fill(.white)
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Circle()
                                        .stroke(.black, lineWidth: 6)
                                )
                                .offset(y: 0)
                        }
                        .offset(y: isClosing ? 0 : geometry.size.height)
                        .rotationEffect(.degrees(isSpinning ? 360 : 0))
                        .offset(y: isOpening ? geometry.size.height : 0)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                   
                }
             }.transition(.opacity)
                .ignoresSafeArea()
                .onAppear {
                        animateTransition()
                    }
        }
         .onChange(of: isPresented) { newValue in
             if !newValue {
                 showTransition = false
             }
        }
    }
    
    private func animateTransition() {
        // Initial fade in and close pokeball
        backgroundOpacity = 1.0
        isClosing = true
        
        // Start spinning after parts meet
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.linear(duration: 0.8)) {
                isSpinning = true
            }
            
            // Start opening animation immediately after spinning
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                isSpinning = false
                withAnimation(.easeInOut(duration: 0.5)) {
                    isOpening = true
                    backgroundOpacity = 0.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    isPresented = false
                }
            }
        }
    }
}


struct Semicircle: Shape {
    var color: Color
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                   radius: rect.width / 2,
                   startAngle: .degrees(0),
                   endAngle: .degrees(180),
                   clockwise: false)
        path.closeSubpath()
        return path
    }
}

extension Shape {
    func fill(color: Color) -> some View {
        self.fill(color)
    }
}
