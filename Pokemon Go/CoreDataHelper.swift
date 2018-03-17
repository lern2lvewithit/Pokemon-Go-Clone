//
//  CoreDataHelper.swift
//  Pokemon Go
//
//  Created by Steven Lerner on 3/16/18.
//  Copyright © 2018 Steven Lerner. All rights reserved.
//

import UIKit
import CoreData

func addAllPokemon() {
        
        createPokemon(name: "Pikachu", imageName: "pikachu")
        createPokemon(name: "Meowth", imageName: "meowth")
        createPokemon(name: "Charmander", imageName: "charmander")
        createPokemon(name: "Bullbasaur", imageName: "bullbasaur")
        createPokemon(name: "Dratini", imageName: "dratini")
        createPokemon(name: "Eevee", imageName: "eevee")
        createPokemon(name: "Jigglypuff", imageName: "jigglypuff")
        createPokemon(name: "Psyduck", imageName: "psyduck")
        createPokemon(name: "Snorlax", imageName: "snorlax")
        createPokemon(name: "Squirtle", imageName: "squirtle")
}

func createPokemon(name:String, imageName:String) {
    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
        let pokemon = Pokemon(entity: Pokemon.entity(), insertInto: context)
        pokemon.name = name
        pokemon.imageName = imageName
        try? context.save()
    }
}

func getAllPokemon() -> [Pokemon] {
    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
        if let pokeData = try? context.fetch(Pokemon.fetchRequest()) as? [Pokemon] {
            if let pokemons = pokeData {
                if pokemons.count == 0 {
                    addAllPokemon()
                    return getAllPokemon()
                }
                return pokemons
            }
        }
    }
    return []
}

func getCaughtPokemon() -> [Pokemon] {
    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
        let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
        fetchRequest.predicate = NSPredicate(format: "caught == %@", true as CVarArg)
        if let pokemons = try? context.fetch(fetchRequest) {
            return pokemons
        }
    }
    return []
}

func getUnCaughtPokemon() -> [Pokemon] {
    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
        let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
        fetchRequest.predicate = NSPredicate(format: "caught == %@", false as CVarArg)
        if let pokemons = try? context.fetch(fetchRequest) {
            return pokemons
        }
    }
    return []
}

