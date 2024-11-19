
import SwiftUI

struct FooterView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        VStack {
            //Spacer() // Pushes the TabBar to bottom
            HStack(spacing: 20) {
                Spacer()
                
                // Pokeball Tab
                VStack {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .frame(width: 45, height: 45)
                        .background(Color.orange.opacity(0.8))
                        .cornerRadius(12)
                }
                .onTapGesture {
                    selectedTab = 0
                }
                
                // Profile Tab
                VStack {
                    Image(systemName: "person.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .frame(width: 45, height: 45)
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(12)
                }
                .onTapGesture {
                    selectedTab = 1
                }
                
                Spacer()
            }
            .frame(height: 60)
            .background(Color.pink.opacity(0.7))
        }
    }
}

#Preview{
    FooterView()
}
