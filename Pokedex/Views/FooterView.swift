
import SwiftUI

struct FooterView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        VStack {
            ZStack{
                Image("FooterRojo").resizable().frame(height: 200)
                #if !v2
                    HStack(spacing: 120) {
                        Button("", action: {print("hello")})
                        .buttonStyle(BotonPokedex())
                        
                        Button("", action: {print("hello")})
                        .buttonStyle(BotonPerfil())
                    }.offset(CGSize(width: 0, height: 35))
                #else
                    HStack(spacing: 83) {
                        Button("", action: {print("hello")})
                        .buttonStyle(BotonPokedex())
                        
                        Button("", action: {print("hello")})
                        .buttonStyle(BotonPerfilGrande())
                        
                        Button("", action: {print("hello")})
                        .buttonStyle(BotonCombate())
                    }.offset(CGSize(width: 0, height: 35))
                #endif
            }
        }.ignoresSafeArea()
    }
}

#Preview{
    FooterView()
}
