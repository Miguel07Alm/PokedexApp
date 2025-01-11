//
//  PokemonDetailView.swift
//  PokédexApp
//
//  Created by Aula03 on 19/11/24.
//

import SwiftUI
import SDWebImageSwiftUI
import AVFoundation

struct habilidades : Identifiable {
    var id = UUID()
    var nombre : String
    var descripcion : String
}

struct PokemonDetailView: View {
    @State var pokemon : Pokemon
    @StateObject var pokemonViewModel = PokemonViewModel()
    @State var pokemonSpecies : PokemonSpecies?
    @State var descripcion : String = ""
    @State var abilityData : [AbilityData] = []
    @State var abilities : [habilidades] = []
    @State var isLoading : Bool = true
    @State var colorFondo : LinearGradient = LinearGradient(colors: [.white], startPoint: .top, endPoint: .bottom)
    @State var evolutionChain : PokemonEvolutionChain?
    @State var pokemonEvolucion : [Pokemon] = []
    @StateObject private var audioPlayer = AudioPlayer()
    var body: some View {
        VStack (spacing: -50){
            if isLoading {
                // Indicador de carga
                ProgressView("Cargando...").scaleEffect(1.5)
            } else {
                CabeceraConNombre(nombre:  pokemon.name.capitalizedFirstLetter(), id: String(format: "%04d", pokemon.id)).offset(CGSize(width: 0, height: -20))
                ScrollView {
                    ZStack {
                        VStack (spacing: 30){
                            //Imagen Carrusel
                            Spacer(minLength: 75)
                            AutoScroller(imageNames: [ pokemon.sprites.other?.officialArtwork?.frontDefault ?? "", pokemon.sprites.other?.officialArtwork?.frontShiny ?? "", pokemon.sprites.frontFemale ?? pokemon.sprites.frontDefault, pokemon.sprites.frontShinyFemale ?? pokemon.sprites.frontShiny, pokemon.sprites.other?.showdown?.frontDefault ?? pokemon.sprites.other?.home?.frontShiny]).cornerRadius(48).frame(height: 100).padding()
                            
                            //Botones de extrella y boton altavoz
                            Spacer(minLength: 45)
                            ZStack {
                                Rectangle().cornerRadius(25).foregroundColor(.white).frame(width: 350).opacity(0.65)
                                HStack (){
                                    Spacer()
                                    Button {
                                        //
                                    }label:{
                                        Image(systemName: "star").foregroundColor(.gray).font(.system(size: 35))
                                    }
                                    Spacer()
                                    Button{
                                        audioPlayer.playSound(for: "\(pokemon.name)")
                                    }label:{
                                        Image(systemName: "speaker.3.fill").foregroundColor(.gray).font(.system(size: 35))
                                    }
                                    Spacer()
                                }
                            }
                            
                            //Tipo y circulo del tipo
                            HStack {
                                if (pokemon.types.count == 2) {
                                    Spacer()
                                }
                                VStack {
                                    ZStack {
                                        Circle().frame(height: 40).foregroundColor(.gray)
                                        Image(PokemonType.typesToIcon[pokemon.types[0].type.name]!).resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 30, height: 30)
                                    }
                                    Text(PokemonType.typesToSpanish[pokemon.types[0].type.name]!).font(.title2)
                                }
                                if (pokemon.types.count == 2) {
                                    Spacer()
                                    VStack {
                                        ZStack {
                                            Circle().frame(height: 40).foregroundColor(.gray)
                                            Image(PokemonType.typesToIcon[pokemon.types[1].type.name]!).resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 30, height: 30)
                                        }
                                        Text(PokemonType.typesToSpanish[pokemon.types[1].type.name]!).font(.title2)
                                    }
                                    Spacer()
                                }
                            }
                            
                            //Texto peso y altura
                            ZStack {
                                Rectangle().cornerRadius(25).foregroundColor(.white).frame(width: 350).opacity(0.65)
                                HStack {
                                    Spacer()
                                    VStack (){
                                        Text("Peso").font(.title2)
                                        let peso = Double(pokemon.weight)
                                        Text("\(String(format: "%.2f", peso / 10)) Kg").font(.title2)
                                    }.padding()
                                    Spacer()
                                    VStack (){
                                        Text("Altura").font(.title2)
                                        let altura = Double(pokemon.height)
                                        Text("\(String(format: "%.2f", altura / 10)) m").font(.title2)
                                    }.padding()
                                    Spacer()
                                }
                            }
                            ZStack {
                                Rectangle().cornerRadius(25).foregroundColor(.white).frame(width: 350).opacity(0.65)
                                VStack (){
                                    Text("Descripción").font(.title)
                                    
                                    Text("\(descripcion)").frame(width: 320)
                                }.padding()
                            }
                            
                            ZStack {
                                Rectangle().cornerRadius(25).foregroundColor(.white).frame(width: 350).opacity(0.65)
                                VStack (){
                                    Text("Habilidades").font(.title).frame(height: 60)
                                    if abilities.count > 0 {
                                        Text(abilities[0].nombre).font(.title3).frame(width: 320, alignment: .leading)
                                        Text(abilities[0].descripcion).frame(width: 320, alignment: .leading)
                                    }
                                    if abilities.count > 1 {
                                        Text("")
                                        Text(abilities[1].nombre).font(.title3).frame(width: 320, alignment: .leading)
                                        Text(abilities[1].descripcion).frame(width: 320, alignment: .leading)
                                    }
                                    //Text("Electricidad estática").frame(width: 320, alignment: .leading).font(.title3).multilineTextAlignment(.leading)
                                    //Text("Puede paralizar al mínimo contacto.").frame(width: 320, alignment: .leading)
                                    //Text("Pararrayos").padding(.top, 15.0).frame(width: 320, alignment: .leading).font(.title3)
                                    //Text("Atrae y neutraliza movimientos de tipo Eléctrico y sube el At. Esp.").frame(width: 320, alignment: .leading)
                                }.padding()
                            }
                            
                            
                            if pokemon.stats.count >= 6 {
                                ZStack {
                                    Rectangle().cornerRadius(25).foregroundColor(.white).frame(width: 385).opacity(0.65)
                                    VStack (spacing: 50) {
                                        Text("Estadisticas").font(.title).padding()
                                        VStack {
                                            StatHexagonView(stats: [
                                                StatValue(name: "Attack", value: Double(pokemon.stats[1].baseStat), maxValue: 255),
                                                StatValue(name: "Defense", value: Double(pokemon.stats[2].baseStat), maxValue: 255),
                                                StatValue(name: "Sp.Atk", value: Double(pokemon.stats[3].baseStat), maxValue: 255),
                                                StatValue(name: "Sp.Def", value: Double(pokemon.stats[4].baseStat), maxValue: 255),
                                                StatValue(name: "Speed", value: Double(pokemon.stats[5].baseStat), maxValue: 255),
                                                StatValue(name: "HP", value: Double(pokemon.stats[0].baseStat), maxValue: 255)
                                            ], size: 350)
                                        }.frame(width: .infinity).offset(x: 39)
                                    }
                                }
                                
                            }
                            Spacer()
                            //Apartado evoluciones
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                ForEach(pokemonEvolucion, id: \.id) { pokemon in
                                    EntradaPokedexView(pokemon: pokemon, teamId: 0)
                                }
                            }
                            Spacer()
                        }
                    }.ignoresSafeArea()
                }.background(colorFondo).edgesIgnoringSafeArea(.bottom).ignoresSafeArea().cornerRadius(48)
            }
        }.onAppear {
            isLoading = true // Indica que la carga está en progreso
            
            // Inicializa el color de fondo
            if pokemon.types.count == 2 {
                colorFondo = PokemonType.getGradient(for: [pokemon.types[0].type.name, pokemon.types[1].type.name], firstColorProportion: 1)
            } else {
                colorFondo = PokemonType.getGradient(for: [pokemon.types[0].type.name, pokemon.types[0].type.name])
            }
            
            let group = DispatchGroup()
            
            // Fetch de la especie del Pokémon
            group.enter()
            pokemonViewModel.fetchPokemonSpecies(id: pokemon.id) { result in
                defer { group.leave() }
                switch result {
                case .success(let details):
                    pokemonSpecies = details
                    
                    // Obtener la cadena de evolución utilizando la URL de la especie
                    if let evolutionURL = details.evolutionChain?.url {
                        group.enter()
                        var pokemonEvolutionID = evolutionURL.split(separator: "/").last;                        pokemonViewModel.fetchPokemonEvolutionChain(id: String(pokemonEvolutionID ?? "-1") ) { result in
                            defer { group.leave() }
                            switch result {
                                case .success(let details):
                                    evolutionChain = details
                                    
                                    // Procesar la cadena evolutiva
                                    func processChain(_ chain: Chain?) {
                                        guard let chain = chain else { return }
                                        
                                        // Obtener el nombre del Pokémon actual
                                        if let pokemonName = chain.species?.name {
                                            group.enter()
                                            pokemonViewModel.fetchPokemonDetails(id: pokemonName) { result in
                                                defer { group.leave() }
                                                switch result {
                                                case .success(let pokemon):
                                                    pokemonEvolucion.append(pokemon)
                                                case .failure(let error):
                                                    print("Error al obtener el Pokémon \(pokemonName): \(error)")
                                                }
                                            }
                                        }
                                        
                                        // Procesar las evoluciones
                                        chain.evolvesTo?.forEach { nextChain in
                                            processChain(nextChain)
                                        }
                                    }
                                    
                                    // Iniciar el procesamiento desde la cadena principal
                                    processChain(details.chain)
                                    
                                case .failure(let error):
                                    print("Error al obtener detalles de la cadena evolutiva: \(error)")
                            }
                        }
                    } else {
                        print("Error: URL de cadena de evolución no encontrada en pokemonSpecies")
                    }
                case .failure(let error):
                    print("Error al obtener detalles del Pokémon \(pokemon.id): \(error)")
                }
            }
            
            // Fetch de las habilidades del Pokemon
            for ability in pokemon.abilities {
                group.enter()
                pokemonViewModel.fetchAbilityInfo(name: ability.ability.name) { result in
                    defer { group.leave() }
                    switch result {
                    case .success(let details):
                        abilityData.append(details)
                    case .failure(let error):
                        print("Error al obtener habilidades del Pokémon \(pokemon.id): \(error)")
                    }
                }
            }
            
            // Notificación cuando todas las tareas estén completadas
            group.notify(queue: .main) {
                descripcion = pokemonSpecies?.flavorTextEntries?
                    .filter { $0.language?.name == "en" }
                    .map { $0.flavorText ?? "" }
                    .joined(separator: " ") ?? ""
                
                abilities = abilityData.map { habilidad in
                    habilidades(
                        nombre: habilidad.names
                            .filter { $0.language.name == "es" }
                            .map { $0.name }
                            .joined(separator: " "),
                        descripcion: habilidad.flavorTextEntries
                            .filter { $0.language.name == "en" }
                            .map { $0.flavorText }
                            .joined(separator: " ")
                    )
                }
                
                isLoading = false // Indica que la carga ha finalizado
            }
        }.ignoresSafeArea()
    }
}

struct CabeceraConNombre : View{
    var nombre: String
    var id: String
    var body: some View {
        ZStack{
            Rectangle().foregroundColor(.white)
            //Image("CabeceraSinNada").resizable().frame(height: 150)
            Text(nombre + " #" + id).font(.title).offset(y: 15) // Aportacion de un pikachu
        }.ignoresSafeArea().frame(alignment: .top).frame(height: 175)
    }
}

struct StatValue: Identifiable {
    let id = UUID()
    let name: String
    let value: Double
    let maxValue: Double
    
    var percentage: Double {
        value / maxValue
    }
}

struct StatHexagonView: View {
    let stats: [StatValue]
    let size: CGFloat
    let strokeColor: Color
    let fillColor: Color
    
    init(stats: [StatValue], size: CGFloat = 200, strokeColor: Color = .green, fillColor: Color = Color.gray.opacity(0.2)) {
        self.stats = stats
        self.size = size
        self.strokeColor = strokeColor
        self.fillColor = fillColor
    }
    
    private func point(for index: Int, radius: CGFloat) -> CGPoint {
        let angle = (2.0 * .pi * Double(index) / 6.0) - .pi / 2
        return CGPoint(
            x: size/2 + radius * cos(angle),
            y: size/2 + radius * sin(angle)
        )
    }
    
    var body: some View {
        ZStack {
            // Base hexagon
            Path { path in
                for i in 0..<6 {
                    let point = point(for: i, radius: size/2)
                    if i == 0 {
                        path.move(to: point)
                    } else {
                        path.addLine(to: point)
                    }
                }
                path.closeSubpath()
            }
            .stroke(strokeColor, lineWidth: 2)
            
            // Inner lines
            ForEach(0..<6) { i in
                Path { path in
                    path.move(to: CGPoint(x: size/2, y: size/2))
                    path.addLine(to: point(for: i, radius: size/2))
                }
                .stroke(strokeColor.opacity(0.5), lineWidth: 1)
            }
            
            // Stat values
            Path { path in
                for i in 0..<6 {
                    let radius = size/2 * stats[i].percentage
                    let point = point(for: i, radius: radius)
                    if i == 0 {
                        path.move(to: point)
                    } else {
                        path.addLine(to: point)
                    }
                }
                path.closeSubpath()
            }
            .fill(fillColor)
            .overlay(
                Path { path in
                    for i in 0..<6 {
                        let radius = size/2 * stats[i].percentage
                        let point = point(for: i, radius: radius)
                        if i == 0 {
                            path.move(to: point)
                        } else {
                            path.addLine(to: point)
                        }
                    }
                    path.closeSubpath()
                }
                    .stroke(strokeColor, lineWidth: 2)
            )
            
            // Stat labels
            ForEach(0..<6) { i in
                let point = point(for: i, radius: size/2 + 20)
                Text(stats[i].name)
                    .font(.caption).position(point)
            }
            
            // Stat values
            ForEach(0..<6) { i in
               let point = point(for: i, radius: size/2 + 35)
                Text("\(Int(stats[i].value))")
                    .font(.caption)
                    .bold().position(point)
                
            }
        }
        .frame(width: size + 80, height: size + 80) // Extra space for labels
    }
}
struct AutoScroller: View {
    var imageNames: [String?]?
    let timer = Timer.publish(every: 7.0, on: .main, in: .common).autoconnect()
    @State private var selectedImageIndex: Int = 0
    
    var body: some View {
        ZStack {
            // Step 4: Background Color
            Color.secondary
                .ignoresSafeArea()
            
            // Step 5: Create TabView for Carousel
            TabView(selection: $selectedImageIndex) {
                // Step 6: Iterate Through Images
                ForEach(0..<(imageNames?.count ?? 0), id: \.self) { index in
                    ZStack(alignment: .topLeading) {
                        // Step 7: Display Image
                        if let imageName = imageNames?[index], let url = URL(string: imageName) {
                            if (index < 4) {
                                // Cargar imágenes normales (sin GIF)
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(20)
                                        .padding()
                                } placeholder: {
                                    ProgressView()
                                }
                            } else {
                                // Cargar GIF usando WebImage
                                WebImage(url: url) // Usamos WebImage para manejar GIFs
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(20)
                                    .padding()
                            }
                        } else {
                            Text("Invalid URL").foregroundColor(.red)
                        }
                    } // Step 8: Apply Visual Effect Blur
                    .shadow(radius: 20) // Step 9: Apply Shadow
                }
            }
            .frame(height: 300) // Step 10: Set Carousel Height
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Step 11: Customize TabView Style
            .ignoresSafeArea()
            
            // Step 12: Navigation Dots
            HStack {
                ForEach(0..<(imageNames?.count ?? 0), id: \.self) { index in
                    // Step 13: Create Navigation Dots
                    Capsule()
                        .fill(Color.white.opacity(selectedImageIndex == index ? 1 : 0.33))
                        .frame(width: 35, height: 8)
                        .onTapGesture {
                            // Step 14: Handle Navigation Dot Taps
                            selectedImageIndex = index
                        }
                }
                .offset(y: 130) // Step 15: Adjust Dots Position
            }
        }
        .onReceive(timer) { _ in
            // Step 16: Auto-Scrolling Logic
            withAnimation(.default) {
                selectedImageIndex = (selectedImageIndex + 1) % (imageNames?.count ?? 0)
            }
        }
    }
}

class AudioPlayer: NSObject, ObservableObject {
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var timeObserver: Any?
    @Published var isPlaying = false
    
    override init() {
        super.init()
    }
    
    func playSound(for pokemonName: String) {
        // Stop current playback if any
        stop()
        
        // Construct the URL for the Pokémon cry
        let formattedName = pokemonName.lowercased().replacingOccurrences(of: " ", with: "")
        guard let url = URL(string: "https://play.pokemonshowdown.com/audio/cries/\(formattedName).mp3") else {
            print("Invalid URL for Pokémon cry")
            playFallbackSound()
            return
        }
        
        // Check if the URL is valid
        URLSession.shared.dataTask(with: url) { [weak self] _, response, error in
            if let error = error {
                print("Error fetching Pokémon cry: \(error)")
                DispatchQueue.main.async {
                    self?.playFallbackSound()
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Pokémon cry not found: \(url)")
                DispatchQueue.main.async {
                    self?.playFallbackSound()
                }
                return
            }
            
            // URL is valid, start playback
            DispatchQueue.main.async {
                self?.startPlayback(with: url)
            }
        }.resume()
    }
    
    private func startPlayback(with url: URL) {
        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        // Set up audio session
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
            playFallbackSound()
            return
        }
        
        // Add observer for playback status
        playerItem?.addObserver(self,
                                forKeyPath: #keyPath(AVPlayerItem.status),
                                options: [.old, .new],
                                context: nil)
        
        // Add observer for when playback ends
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerDidFinishPlaying),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: playerItem)
        
        // Start playback
        player?.play()
        isPlaying = true
    }
    
    private func playFallbackSound() {
        guard let fallbackUrl = URL(string: "https://drive.google.com/file/d/1FdZyx_Oh-qKSQwG78Adp7GYDTFOH3s2I/view?usp=sharing") else {
            print("Invalid fallback URL")
            return
        }
        
        startPlayback(with: fallbackUrl)
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            
            // Switch over status value
            switch status {
            case .failed:
                print("Player item failed with error: \(String(describing: playerItem?.error))")
                DispatchQueue.main.async { [weak self] in
                    self?.isPlaying = false
                }
            case .readyToPlay:
                print("Player item is ready to play")
            case .unknown:
                print("Player item is not yet ready")
            @unknown default:
                print("Unknown player item status")
            }
        }
    }
    
    @objc func playerDidFinishPlaying() {
        DispatchQueue.main.async { [weak self] in
            self?.isPlaying = false
        }
    }
    
    private func stop() {
        if let playerItem = playerItem {
            playerItem.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
        }
        player?.pause()
        player = nil
        playerItem = nil
        isPlaying = false
    }
    
    deinit {
        stop()
        try? AVAudioSession.sharedInstance().setActive(false)
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
        }
    }
}

struct CabeceraContenido: View {
    @State private var selectedTab = 1
    @State private var pokemon: Pokemon?
    @State private var isLoading = true
    @StateObject private var pokemonViewModel = PokemonViewModel()
    
    var body: some View {
        VStack(spacing: -100) {
            if isLoading {
                // Vista de carga mientras se obtienen los datos
                ProgressView("Cargando datos...")
                    .progressViewStyle(CircularProgressViewStyle())
            } else if let pokemon = pokemon {
                // Mostrar los datos una vez cargados
                PokemonDetailView(pokemon: pokemon)
                FooterView(selectedTab: selectedTab)
            } else {
                // Vista para manejar errores o datos faltantes
                Text("Error al cargar los datos.")
                    .foregroundColor(.red)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            // Llamada asíncrona para cargar los datos
            pokemonViewModel.fetchPokemonDetails(id: "charizard") { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let details):
                        self.pokemon = details
                        self.isLoading = false
                    case .failure(let error):
                        print("Error fetching details: \(error)")
                        self.isLoading = false
                    }
                }
            }
        }
    }
}

#Preview {
    CabeceraContenido()
}
