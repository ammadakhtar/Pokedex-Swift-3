//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Ammad on 12/03/2017.
//  Copyright © 2017 Ammad. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
     var pokemon : Pokemon!

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainnImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLbl.text = pokemon.name.capitalized
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainnImg.image = img
        currentEvoImg.image = img
        pokemon.downloadpokemonDetail {
        self.updateUI()
        }
       
 }
    func updateUI() {
        //self.nameLbl.text = pokemon.name
        attackLbl.text = pokemon.attack
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        pokedexLbl.text = "\(pokemon.pokedexId)"
        typeLbl.text = pokemon.type
        descriptionLbl.text = pokemon.description
        if pokemon.nextEvolutionId == "" {
            
            evoLbl.text = "No Evolutions"
            nextEvoImg.isHidden = true
            
        } else {
            
            nextEvoImg.isHidden = false
            nextEvoImg.image = UIImage(named: pokemon.nextEvolutionId)
            let str = "Next Evolution: \(pokemon.nextEvolutionName) - LVL \(pokemon.nextEvolutionLevel)"
            evoLbl.text = str
        }
        
        
    }
    @IBAction func backBtnPressed(_ sender: UIButton) {
        
        _ = dismiss(animated: true, completion: nil)
        
    }
}
