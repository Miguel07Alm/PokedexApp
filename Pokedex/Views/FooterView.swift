
import SwiftUI

struct FooterView: View {
    @Binding var selectedTab : Int;
    var body: some View {
        VStack {
            ZStack{
                Image("FooterRojo").resizable().frame(height: 200)
                switch selectedTab{
                    
                    case 0: //Registro
                        HStack {
                            Button("", action: {print("hello")})
                            .buttonStyle(BotonRegistroGrande())
                            
                        }.offset(CGSize(width: 0, height: 35))
                    case 1: //Average
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
                    case 2: //Combate
                        HStack{
                            Button("", action: {print("hello")})
                                .buttonStyle(BotonCombateGrande())
                        }.offset(CGSize(width: 0, height: 35))
                    default:
                        Text("La cagÜe")
                }
            }
        }.ignoresSafeArea()
    }
}

#Preview{
    @State var selectedTab = 1;
    FooterView(selectedTab: $selectedTab)
}
