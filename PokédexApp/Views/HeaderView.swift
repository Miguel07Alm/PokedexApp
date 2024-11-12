import SwiftUI


struct HeaderView: View {
    var body: some View{
        VStack() {
            // Search bar
            HStack {
                Image(systemName: "line.3.horizontal")
                    .foregroundColor(.gray)
                
                TextField("Buscar", text: .constant(""))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            
            // Filter chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                }
            }
            .padding(.horizontal)
        }
    }
  
}

#Preview{
    HeaderView()
}
               

