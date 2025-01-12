import CoreData
import Foundation
import UIKit

class ViewModel: ObservableObject {
    let gestorCoreData = CoreDataManager.instance

    @Published var authenticatedUser: UserEntity?

    @Published var usersArray: [UserEntity] = []
    @Published var pokemonsArray: [PokemonEntity] = []

    func cargarDatos() {
        pokemonsArray.removeAll()

        let fetchUsers = NSFetchRequest<UserEntity>(entityName: "UserEntity")
        let fetchPokemons = NSFetchRequest<PokemonEntity>(
            entityName: "PokemonEntity")

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
