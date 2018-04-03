//
//  PokemonDetailVC.swift
//  pokedex
//
//  Created by Andrew Miller on 03/04/2018.
//  Copyright © 2018 Andrew Miller. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    var pokemon: Pokemon!
    @IBOutlet weak var nameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLbl.text = pokemon.name
    }

    
}
