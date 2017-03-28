//
//  ViewController.swift
//  Pokedex
//
//  Created by Ammad on 10/03/2017.
//  Copyright © 2017 Ammad. All rights reserved.
//

import UIKit
import  AVFoundation

class ViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout , UISearchBarDelegate
{

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchbar: UISearchBar!
    
    var pokemon = [Pokemon]()
    var filteredpokemon = [Pokemon]()
    var inSearchMode = false
    var musicplayer: AVAudioPlayer!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        collection.delegate = self
        collection.dataSource = self
        searchbar.delegate = self
        searchbar.returnKeyType = UIReturnKeyType.done
        parseCSV()
        initaudio()
    }
    
        func initaudio()
        {
            let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
            
            do
            {
                
                musicplayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
                musicplayer.prepareToPlay()
                musicplayer.numberOfLoops = -1
                musicplayer.play()
            }
            catch let error as NSError
            {
                print(error.description)
            }
        }
        
        func parseCSV() {
            
            let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
            do {
                
            let csv = try CSV(contentsOfURL: path)
                let rows = csv.rows
                for row in rows {
                    let pokeID = Int(row["id"]!)!
                    let name = row["identifier"]!
                    let poke = Pokemon(name: name, pokedexId: pokeID)
                    pokemon.append(poke)
                }
            }
            catch let error as NSError
            {
                print(error.description)
            }
            
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
                let poke : Pokemon!
                if inSearchMode
                {
                     poke = filteredpokemon[indexPath.row]
                    cell.configureCell(poke)
                }
                else {
                    poke = pokemon[indexPath.row]
                    cell.configureCell(poke)
                }
                return cell
            }
            else
            {
                return UICollectionViewCell()
            }
        }
        func numberOfSections(in collectionView: UICollectionView) -> Int {
        
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            if inSearchMode
            {
                return filteredpokemon.count
            }
           
            return pokemon.count
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            let poke : Pokemon!
            if inSearchMode {
                poke = filteredpokemon[indexPath.row]

            }
            else {
                poke = pokemon[indexPath.row]
            }
            
            performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
            
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 65, height: 75)
        }
        @IBAction func soundBtnPressed(_ sender: UIButton) {
            
            if musicplayer.isPlaying {
                musicplayer.pause()
                sender.alpha = 0.4
            }
            else
            {
            musicplayer.play()
            sender.alpha = 1.0
            }
        }
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        // or whatever
//        // The user clicked the [X] button or otherwise cleared the text.
//        if (searchText.characters.count ) == 0 {
//            searchBar.perform(#selector(self.resignFirstResponder), with: nil, afterDelay: 0.1)
//        }
//    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchBar.text == nil || searchBar.text == ""
            {
                searchBar.perform(#selector(self.resignFirstResponder), with: nil, afterDelay: 0.1)
                inSearchMode = false
                collection.reloadData()
                view.endEditing(true)
                
            }
            else
            {
                inSearchMode = true
                let lower = searchBar.text!.lowercased()
                filteredpokemon = pokemon.filter({$0.name.range(of: lower) != nil})
                collection.reloadData()
            }
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDetailVC" {
            if let detailsVC = segue.destination as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                    detailsVC.pokemon = poke
                }
            }
        }
    }
    
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
