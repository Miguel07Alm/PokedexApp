
import SwiftUI

struct FooterView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        VStack {
            ZStack{
                Image("FooterRojo").resizable().frame(height: 175)
                HStack(spacing: 70) {
                    Spacer()
                    // Pokeball Tab
                    ZStack {
                        Rectangle()
                            .cornerRadius(12)
                            .frame(width: 75, height: 75)
                            .foregroundColor(Color(red: 0.8823529411764706, green: 0.4117647058823529, blue: 0.17254901960784313))
                            
                        Image("PokedexIcon")
                            .resizable()
                            .frame(width: 55, height: 55)
                            .opacity(0.6)
                    }
                    .onTapGesture {
                        selectedTab = 0
                    }
                    
                    // Profile Tab
                    ZStack {
                        Rectangle()
                            .cornerRadius(12)
                            .frame(width: 75, height: 75)
                            .foregroundColor(Color(red: 0.228, green: 0.053, blue: 0.053))
                        
                        Image("PerfilIcon")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .opacity(0.55)
                    }
                    .onTapGesture {
                        selectedTab = 1
                    }
                    Spacer()
                }.offset(CGSize(width: 0, height: 35))
            }
        }.ignoresSafeArea()
    }
}

#Preview{
    FooterView()
}
