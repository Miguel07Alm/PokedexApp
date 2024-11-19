import SwiftUI

struct SignUpView: View {
    var body: some View {
        ZStack {
            // Fondo de color
            Color(red: 0.9, green: 0.95, blue: 0.95)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Imagen del logo "Pokedex"
                Image("pokedex_logo") // Asegúrate de añadir la imagen al proyecto y nombrarla "pokedex_logo"
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 150) // Ajusta el tamaño según sea necesario
                
                // Imagen de Pikachu
                Image("pikachu_logo") // Asegúrate de añadir esta imagen al proyecto
                    .resizable()
                    .scaledToFit()
                    .frame(width: 390, height: 270)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                
                // Subtítulo "Sign Up"
                Text("Sign Up")
                    .font(.system(size: 50))
                    .foregroundColor(.pink)
                    .fontWeight(.semibold)
                
                // Campos de texto
                VStack(spacing: 15) {
                    // Campo de Username
                    TextField("Username", text: .constant(""))
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.pink, lineWidth: 1)
                        )
                    
                    // Campo de Password
                    SecureField("Password", text: .constant(""))
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.pink, lineWidth: 1)
                        )
                }
                .padding(.horizontal, 40)
                
                // Enlace de "Registrarme"
                HStack {
                    Text("¿No tienes cuenta?")
                        .font(.footnote)
                    
                    Button(action: {
                        // Acción de registro
                    }) {
                        Text("Registrarme")
                            .font(.footnote)
                            .foregroundColor(.pink)
                    }
                }
                
                Spacer()
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

