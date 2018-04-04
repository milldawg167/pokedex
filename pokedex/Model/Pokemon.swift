//
//  Pokemon.swift
//  pokedex
//
//  Created by Andrew Miller on 01/04/2018.
//  Copyright © 2018 Andrew Miller. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexID: Int!
    private var _description: String!
    private var _type: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _defense: String!
    private var _nextEvoTxt: String!
    private var _pokemonURL: String!
    private var _pokemonDescURL: String!
    private var _pokemonEvoURL: String!
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var nextEvoTxt: String {
        if _nextEvoTxt == nil {
            _nextEvoTxt = ""
        }
        return _nextEvoTxt
    }
    
    var name: String {
        return _name
    }
    var pokedexID: Int {
        return _pokedexID
    }
    
    init(name: String, pokedexID: Int) {
        self._name = name
        self._pokedexID = pokedexID
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexID)/"
        self._pokemonDescURL = "\(URL_BASE)\(URL_DESCRIPTION)\(self.pokedexID)"
        self._pokemonEvoURL = "\(URL_BASE)\(URL_EVOLUTION)\(self.pokedexID)"
    }
    
    func downloadPokemonDetail(completed: @escaping DownloadComplete) {
        Alamofire.request(_pokemonURL).responseJSON { response in
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                if let weight = dict["weight"] as? Int {
                    self._weight = "\(weight)"
                }
                if let height = dict["height"] as? Int {
                    self._height = "\(height)"
                }
                if let stats = dict["stats"] as? [Dictionary<String, AnyObject>] {
                    if let defense = stats[3]["base_stat"] as? Int {
                        self._defense = "\(defense)"
                    }
                    if let attack = stats[4]["base_stat"] as? Int {
                        self._attack = "\(attack)"
                    }
                }
                if let types = dict["types"] as? [Dictionary<String, AnyObject>] , types.count > 0 {
                    if let type = types[0]["type"] as? Dictionary<String, String> {
                        if let name = type["name"] {
                            self._type = name.capitalized
                        }
                    }
                    if types.count > 1 {
                        for x in 1..<types.count {
                            if let type = types[x]["type"] as? Dictionary<String, String> {
                                if let name = type["name"] {
                                    self._type! += "/\(name.capitalized)"
                                }
                            }
                        }
                    }
                } else {
                    self._type = ""
                }
            }
            completed()
        }
    }
    
    func downloadPokemonDescription(completed: @escaping DownloadComplete) {
        Alamofire.request(_pokemonDescURL).responseJSON { response in
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                if let text = dict["flavor_text_entries"] as? [Dictionary<String, AnyObject>] {
                    if let description = text[1]["flavor_text"] as? String {
                        let newDescription = description.replacingOccurrences(of: "\n", with: " ")
                        self._description = newDescription
                    }
                }
            } else {
                self._description = ""
            }
            completed()
        }
    }
    
    func downloadEvoDescription(completed: @escaping DownloadComplete) {
        Alamofire.request(_pokemonEvoURL).responseJSON { response in
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                if let chain = dict["chain"] as? Dictionary<String, AnyObject> {
                    if let evo = chain["evolves_to"] as? [Dictionary<String, AnyObject>] {
                        if let species = evo[0]["species"] as? Dictionary<String, String> {
                            if let name = species["name"] {
                                self._nextEvoTxt = name.capitalized
                                print(self._nextEvoTxt)
                            }
                        }
                    }
                }
            } else {
                self._nextEvoTxt = ""
            }
            completed()
        }
    }
    
}
