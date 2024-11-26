import SwiftUI

struct ProfileView: View {
    @State private var isEditingUsername: Bool = false
    @State private var isEditingPassword: Bool = false
    @State private var username: String = "[username]"
    @State private var password: String = "[password]"
    @State private var selectedImage: Image? = nil
    
    var body: some View {
        ZStack {
            // Fondo de color
            Color(red: 0.84, green: 0.93, blue: 0.93)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                // Ícono de cámara
                Button(action: {
                    // Acción para seleccionar una imagen
                    print("Icono de cámara clickeado, seleccionar imagen del sistema")
                }) {
                    if let image = selectedImage {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140, height: 140)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.pink, lineWidth: 3))
                            .shadow(radius: 5)
                    } else {
                        Image(systemName: "camera.circle")
                            .resizable()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                .padding(.top, 40)
                
                // Campos de Username y Password
                VStack(spacing: 15) {
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.pink)
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Username")
                                .foregroundColor(.pink)
                                .font(.caption)
                            if isEditingUsername {
                                TextField("Username", text: $username)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding(5)
                                    .background(Color.white)
                                    .cornerRadius(8)
                            } else {
                                Text(username)
                                    .foregroundColor(.black)
                            }
                        }
                        Spacer()
                        Image(systemName: "pencil")
                            .foregroundColor(.gray)
                            .onTapGesture {
                                isEditingUsername.toggle()
                            }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 3)
                    .padding(.horizontal, 40)
                    
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.pink)
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Password")
                                .foregroundColor(.pink)
                                .font(.caption)
                            if isEditingPassword {
                                SecureField("Password", text: $password)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding(5)
                                    .background(Color.white)
                                    .cornerRadius(8)
                            } else {
                                Text(password)
                                    .foregroundColor(.black)
                            }
                        }
                        Spacer()
                        Image(systemName: "pencil")
                            .foregroundColor(.gray)
                            .onTapGesture {
                                isEditingPassword.toggle()
                            }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 3)
                    .padding(.horizontal, 40)
                }
        
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
