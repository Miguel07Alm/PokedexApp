import SwiftUI

struct PokeballTransitionView: View {
    @Binding var isPresented: Bool
    let destination: AnyView
    @State private var isClosing = false
    @State private var isSpinning = false
    @State private var isOpening = false
    @State private var backgroundOpacity = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background color with fade
                Color.black
                    .opacity(backgroundOpacity)
                
                // Centered pokeball container
                ZStack {
                    // Top semicircle (white)
                    Semicircle(color: .white)
                        .frame(width: 300, height: 300)
                        .rotation3DEffect(.degrees(180), axis: (1, 0, 0))
                        .offset(y: isClosing ? 0 : -geometry.size.height)
                        .rotationEffect(.degrees(isSpinning ? 360 : 0))
                        .offset(y: isOpening ? -geometry.size.height : 0)
                    
                    // Bottom semicircle (red) with button and line
                    ZStack {
                        // Red semicircle
                        Semicircle(color: .red)
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
            }.ignoresSafeArea()
            .onAppear {
                animateTransition()
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
    
    var body: some View {
        self.fill(color)
    }
}

struct TransitionModifier: ViewModifier {
    @Binding var isPresented: Bool
    var destination: () -> AnyView
    @State private var isShowingTransition = false
    @State private var isShowingDestination = false
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .opacity(isShowingDestination ? 0 : 1)
            
            if isShowingTransition {
                PokeballTransitionView(
                    isPresented: $isShowingTransition,
                    destination: destination()
                )
            }
            
            if isShowingDestination {
                destination()
            }
        }
        .onChange(of: isPresented) { newValue in
            if newValue {
                isShowingTransition = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    isShowingDestination = true
                    isShowingTransition = false
                    isPresented = false
                }
            }
        }
    }
}

extension View {
    func pokeballTransition<Destination: View>(
        isPresented: Binding<Bool>,
        destination: @escaping () -> Destination
    ) -> some View {
        self.modifier(TransitionModifier(
            isPresented: isPresented,
            destination: { AnyView(destination()) }
        ))
    }
}

// Preview provider
struct PokeballTransitionView_Previews: PreviewProvider {
    static var previews: some View {
        PokeballTransitionView(
            isPresented: .constant(true),
            destination: AnyView(Color.blue)
        )
    }
}
