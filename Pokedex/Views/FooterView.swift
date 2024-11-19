
import SwiftUI

struct FooterView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        VStack {
            ZStack{
                Image("FooterRojo").resizable().frame(height: 210)
                HStack(spacing: 70) {
                    Spacer()
                    // Pokeball Tab
                    VStack {
                        Image("PokedexIcon")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 75, height: 75)
                            .background(Color.orange.opacity(0.8))
                            .cornerRadius(12)
                    }
                    .onTapGesture {
                        selectedTab = 0
                    }
                    
                    // Profile Tab
                    VStack {
                        Image("PerfilIcon")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 75, height: 75)
                            .background(Color.black.opacity(0.8))
                            .cornerRadius(12)

                    }
                    .onTapGesture {
                        selectedTab = 1
                    }
                    
                    Spacer()
                }.offset(CGSize(width: 0, height: 40))
            }
        }
    }
}

#Preview{
    FooterView()
}
