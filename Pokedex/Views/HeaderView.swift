import SwiftUI


struct HeaderView: View {
    var body: some View{
        VStack() {
            // Search bar
            ZStack{
                Rectangle()
                    .frame(height: 210)
                    .foregroundColor(.white)
                HStack {
                    Image("OrdenacionUltraFino")
                        .resizable()
                        .frame(width: 24, height: 14)
                        .foregroundColor(Color(red: 0.7215686274509804, green: 0.7215686274509804, blue: 0.7215686274509804))
                    
                    TextField("   Buscar", text: .constant(""))
                        .scrollContentBackground(.hidden)
                        .background(Color(red: 0.7215686274509804, green: 0.7215686274509804, blue: 0.7215686274509804))
                        .cornerRadius(30)
                    
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color(red: 0.7215686274509804, green: 0.7215686274509804, blue: 0.7215686274509804))
                    
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(Color(red: 0.7215686274509804, green: 0.7215686274509804, blue: 0.7215686274509804))
                }
                .padding(.horizontal).offset(CGSize(width: 0, height: -20))
                
                // Filter chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                    }
                }
                .padding(.horizontal)
         
            }.ignoresSafeArea()
        }
    }
  
}

#Preview{
    HeaderView()
}
               

