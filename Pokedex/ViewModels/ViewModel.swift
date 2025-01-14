import CoreData
import Foundation
import UIKit

class ViewModel: ObservableObject {
    let gestorCoreData = CoreDataManager.instance

    @Published var authenticatedUser: UserEntity?

    @Published var usersArray: [UserEntity] = []
    @Published var pokemonsArray: [PokemonEntity] = []
    @Published var teamsArray: [TeamEntity] = []
    @Published var battlesArray: [BattleEntity] = []

    func cargarDatos() {
        pokemonsArray.removeAll()
        teamsArray.removeAll()
        battlesArray.removeAll()

        let fetchUsers = NSFetchRequest<UserEntity>(entityName: "UserEntity")
        let fetchPokemons = NSFetchRequest<PokemonEntity>(
            entityName: "PokemonEntity")
        let fetchTeams = NSFetchRequest<TeamEntity>(entityName: "TeamEntity")
        let fetchBattles = NSFetchRequest<BattleEntity>(
            entityName: "BattleEntity")

        do {
            self.usersArray = try gestorCoreData.contexto.fetch(fetchUsers)
            self.pokemonsArray = try gestorCoreData.contexto.fetch(
                fetchPokemons)
        } catch let error {
            print("Error al cargar los datos: \(error)")
        }
    }

    // Crear un nuevo usuario
    func createUser(
        username: String, password: String, profileImage: UIImage? = nil
    ) -> Int {
        guard !username.isEmpty, !password.isEmpty else {
            print(
                "Los campos de nombre de usuario y contraseña no pueden estar vacíos."
            )
            return -1
        }

        if doesUserExist(username: username) {
            print("El usuario \(username) ya existe.")
            return -2
        }

        let newUser = UserEntity(context: gestorCoreData.contexto)
        newUser.name = username
        newUser.password = password
        newUser.profileImage = profileImage?.pngData()

        saveChanges()
        return 0
    }

    // Verificar si un usuario existe
    func doesUserExist(username: String) -> Bool {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", username)

        do {
            let count = try gestorCoreData.contexto.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error al verificar la existencia del usuario: \(error)")
            return false
        }
    }

    // Autenticar usuario (inicio de sesión)
    func authenticateUser(username: String, password: String) -> UserEntity? {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "name == %@ AND password == %@", username, password)

        do {
            let result = try gestorCoreData.contexto.fetch(fetchRequest)
            let user = result.first
            authenticatedUser = user
            return user
        } catch {
            print("Error al autenticar usuario: \(error)")
            return nil
        }
    }

    func updateUsername(newUsername: String) {
        guard let user = authenticatedUser else { return }
        user.name = newUsername
        saveChanges()
    }

    func updatePassword(newPassword: String) {
        guard let user = authenticatedUser else { return }
        user.password = newPassword
        saveChanges()
    }

    func updateProfileImage(newImage: UIImage) {
        guard let user = authenticatedUser else { return }
        user.profileImage = newImage.pngData()
    }

    // Pokemon
    func createPokemon(name: String, pokedexNumber: Int, usageCount: Int = 0)
        -> PokemonEntity?
    {
        // 1) Revisar si ya existe un Pokémon con este nombre y número
        let fetchRequest: NSFetchRequest<PokemonEntity> =
            PokemonEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "name == %@ AND pokedexNumber == %d", name, pokedexNumber
        )

        do {
            let results = try gestorCoreData.contexto.fetch(fetchRequest)

            // 2) Si ya existe, retornarlo
            if let existingPokemon = results.first {
                return existingPokemon
            }
        } catch {
            print("Error al buscar Pokémon existente: \(error)")
        }

        // 3) Si no existe, creamos uno nuevo
        let newPokemon = PokemonEntity(context: gestorCoreData.contexto)
        newPokemon.name = name
        newPokemon.pokedexNumber = Int16(pokedexNumber)
        newPokemon.usageCount = Int16(usageCount)  // 0 si no se pasa otro valor

        // 4) Guardamos en Core Data y actualizamos arrays
        saveChanges()
        pokemonsArray.append(newPokemon)

        return newPokemon
    }

    func isFavorite(namePokemon: String, pokedexNumber: Int) -> Bool {
        guard let user = authenticatedUser else { return false }
        return user.favoritePokemons?.contains(where: {
            ($0 as? PokemonEntity)?.name == namePokemon
                && ($0 as? PokemonEntity)?.pokedexNumber == Int16(pokedexNumber)
        }) ?? false
    }

    func toggleFavorite(namePokemon: String, pokedexNumber: Int) {
        guard let user = authenticatedUser else {
            print("No hay usuario autenticado.")
            return
        }
        if let existingPokemon = (user.favoritePokemons as? Set<PokemonEntity>)?
            .first(
                where: {
                    $0.name == namePokemon && $0.pokedexNumber == pokedexNumber
                })
        {
            // Eliminar de favoritos
            user.removeFromFavoritePokemons(existingPokemon)
            gestorCoreData.contexto.delete(existingPokemon)
        } else {
            // Añadir a favoritos
            let newPokemon = PokemonEntity(context: gestorCoreData.contexto)
            newPokemon.name = namePokemon
            newPokemon.pokedexNumber = Int16(pokedexNumber)
            user.addToFavoritePokemons(newPokemon)
        }
        saveChanges()
    }

    func incrementPokemonUsage(namePokemon: String, pokedexNumber: Int) {
        // Buscar si ya existe el Pokémon en el array de pokemons
        if let existingPokemon = pokemonsArray.first(where: {
            $0.name == namePokemon && $0.pokedexNumber == pokedexNumber
        }) {
            // Si existe, incrementar el contador de uso
            existingPokemon.usageCount += 1
            print(
                "El contador de uso de \(namePokemon) ha sido incrementado a \(existingPokemon.usageCount)."
            )
        } else {
            // Si no existe, crear un nuevo Pokémon con contador inicial de 1
            let newPokemon = PokemonEntity(context: gestorCoreData.contexto)
            newPokemon.name = namePokemon
            newPokemon.pokedexNumber = Int16(pokedexNumber)
            newPokemon.usageCount = 1  // Inicializar el contador en 1
            pokemonsArray.append(newPokemon)  // Añadir al array de pokemons
            print(
                "Se ha creado el Pokémon \(namePokemon) con un contador de uso inicial de \(newPokemon.usageCount)."
            )
        }
        // Guardar los cambios en Core Data
        saveChanges()
    }

    func getAllPokemonUsageCounts() -> [(
        name: String, pokedexNumber: Int, usageCount: Int
    )] {
        // Crear un array de tuplas que contengan el nombre, número y contador de uso
        return pokemonsArray.map { pokemon in
            (
                name: pokemon.name ?? "Desconocido",
                pokedexNumber: Int(pokemon.pokedexNumber),
                usageCount: Int(pokemon.usageCount)
            )
        }
    }

    func getMostUsedPokemon() -> (
        name: String, pokedexNumber: Int, usageCount: Int
    )? {
        let pokemonUsageCounts = getAllPokemonUsageCounts()

        // Encontrar el Pokémon con el mayor valor de usageCount
        let mostUsedPokemon = pokemonUsageCounts.max {
            $0.usageCount < $1.usageCount
        }

        return mostUsedPokemon
    }

    func createTeam(name: String, pokemons: [PokemonEntity]) -> TeamEntity? {
        // 1) Crear la instancia de TeamEntity
        let newTeam = TeamEntity(context: gestorCoreData.contexto)
        newTeam.id = UUID()
        newTeam.nombre = name

        // 2) Por cada Pokémon, creamos un registro en la tabla intermedia Team_PokemonEntity
        for pokemon in pokemons {
            let newTeamPokemon = Team_PokemonEntity(
                context: gestorCoreData.contexto)

            // Asignar el UUID del equipo y del pokémon, si usas esos campos
            newTeamPokemon.idEquipo = newTeam.id
            newTeamPokemon.idPokemon = pokemon.id

            // Establecer también las relaciones Core Data
            newTeamPokemon.equipo = newTeam
            newTeamPokemon.pokemon = pokemon

            // (Si tu TeamEntity o PokemonEntity tuvieran relaciones inversas configuradas,
            // Core Data se enteraría automáticamente de esta asociación.)
        }

        // 3) Guardar cambios
        saveChanges()

        return newTeam
    }

    func createBattle(
        equipo1: TeamEntity,
        equipo2: TeamEntity,
        winner: Int? = nil
    ) -> BattleEntity? {
        // Verificar que haya un usuario autenticado
        guard let user = authenticatedUser else {
            print("No hay usuario autenticado para asociar a la batalla.")
            return nil
        }

        // 1) Crear un nuevo objeto BattleEntity en el contexto
        let newBattle = BattleEntity(context: gestorCoreData.contexto)

        // 2) Asignar un UUID a idBatalla (si deseas controlarlo manualmente)
        newBattle.idBatalla = UUID()

        // 3) Relacionar la batalla con el usuario
        newBattle.usuario = user

        // 4) Asignar los equipos
        newBattle.equipo1 = equipo1
        newBattle.equipo2 = equipo2

        // 5) Asignar si hay un ganador en el momento de crearlo
        if let isWinner = winner {
            newBattle.winner = Int16(isWinner)
        }

        // (Opcional) Si vas a usar idUsuario (UUID) como atributo,
        // podrías asignarlo a partir de alguna propiedad en tu UserEntity:
        // newBattle.idUsuario = user.id  // si tu UserEntity tiene un atributo 'id' (UUID)

        // 6) Guardar cambios en Core Data
        saveChanges()

        return newBattle
    }

    func getBattleHistory() -> [(
        battle: BattleEntity, team1Pokemons: [PokemonEntity],
        team2Pokemons: [PokemonEntity]
    )] {
        // 1) Crear el fetch request para BattleEntity
        let fetchRequest: NSFetchRequest<BattleEntity> =
            BattleEntity.fetchRequest()

        do {
            // 2) Hacer el fetch de todas las batallas
            let battles = try gestorCoreData.contexto.fetch(fetchRequest)

            var battleHistory:
                [(
                    battle: BattleEntity, team1Pokemons: [PokemonEntity],
                    team2Pokemons: [PokemonEntity]
                )] = []

            // 3) Iterar sobre cada batalla
            for battle in battles {
                // 4) Obtener los equipos asociados a la batalla
                guard let team1 = battle.equipo1,
                    let team2 = battle.equipo2
                else {
                    continue  // Si no hay equipos, saltar esta batalla
                }

                // 5) Obtener los pokémon de cada equipo usando Team_PokemonEntity
                let team1Pokemons = getPokemonsForTeam(team: team1)
                let team2Pokemons = getPokemonsForTeam(team: team2)

                // 6) Añadir la batalla y sus equipos al historial
                battleHistory.append(
                    (
                        battle: battle, team1Pokemons: team1Pokemons,
                        team2Pokemons: team2Pokemons
                    ))
            }

            return battleHistory
        } catch {
            print("Error al obtener el historial de batallas: \(error)")
            return []
        }
    }

    func getPokemonsForTeam(team: TeamEntity) -> [PokemonEntity] {
        // 1) Crear un fetch request para Team_PokemonEntity
        let fetchRequest: NSFetchRequest<Team_PokemonEntity> =
            Team_PokemonEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "equipo == %@", team)

        do {
            // 2) Hacer el fetch de todas las asociaciones de ese equipo
            let teamPokemons = try gestorCoreData.contexto.fetch(fetchRequest)

            // 3) Extraer los pokémon de las relaciones y devolverlos
            return teamPokemons.compactMap { $0.pokemon }
        } catch {
            print(
                "Error al obtener pokémon para el equipo \(team.nombre ?? "Desconocido"): \(error)"
            )
            return []
        }
    }

    // Guardar cambios en el contexto
    func saveChanges() {
        do {
            try gestorCoreData.contexto.save()
            cargarDatos()  // Recargar datos después de guardar
            print("Cambios guardados exitosamente.")
        } catch let error {
            print("Error al guardar cambios: \(error)")
        }
    }

}
