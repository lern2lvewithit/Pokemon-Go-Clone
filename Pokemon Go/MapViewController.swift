//
//  ViewController.swift
//  Pokemon Go
//
//  Created by Steven Lerner on 3/14/18.
//  Copyright © 2018 Steven Lerner. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var manager = CLLocationManager()
    var updateCount = 0
    
    var pokemons : [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemons = getAllPokemon()
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            setUP()
        } else {
            manager.requestWhenInUseAuthorization()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            setUP()
        }
    }
    
    func setUP() {
        mapView.showsUserLocation = true
        manager.startUpdatingLocation()
        mapView.delegate = self
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            if let center = self.manager.location?.coordinate {
                
                var annoCoord = center
                annoCoord.latitude += (Double(arc4random_uniform(200)) - 100.0) / 50000.0
                annoCoord.longitude += (Double(arc4random_uniform(200)) - 100.0) / 50000.0
                
                let randomIndex = Int(arc4random_uniform(UInt32(self.pokemons.count)))
                
                let randomPokemon = self.pokemons[randomIndex]
                
                let anno = PokeAnnotation(coord: annoCoord, pokemon: randomPokemon)
                self.mapView.addAnnotation(anno)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        if annotation is MKUserLocation {
            annoView.image = UIImage(named: "player")
            var frame = annoView.frame
            frame.size.height = 50
            frame.size.width = 50
            annoView.frame = frame
        } else {
            
            if let pokeAnnotation = annotation as? PokeAnnotation {
                if let imageName = pokeAnnotation.pokemon.imageName {
                    annoView.image = UIImage(named: imageName)
                    var frame = annoView.frame
                    frame.size.height = 50
                    frame.size.width = 50
                    annoView.frame = frame
                }
            }
        }
        return annoView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        
        if view.annotation is MKUserLocation {
            // It's the trainer, do nothing
        } else {
            if let center = manager.location?.coordinate {
                if let pokemonCenter = view.annotation?.coordinate {
                    let region = MKCoordinateRegionMakeWithDistance(pokemonCenter, 300, 300)
                    mapView.setRegion(region, animated: false)
                    
                    if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(center)) {
                        
                        if let pokeAnnotation = view.annotation as? PokeAnnotation {
                            pokeAnnotation.pokemon.caught = true
                            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                                try? context.save()
                                
                                if let name = pokeAnnotation.pokemon.name {
                                    let alertVC = UIAlertController(title: "Congrats!", message: "You caught a \(name)", preferredStyle: .alert)
                                    
                                    let pokedexAction = UIAlertAction(title: "PokeDex", style: .default, handler: { (action) in
                                        self.performSegue(withIdentifier: "moveToPokedex", sender: nil)
                                    })
                                    
                                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
                                        alertVC.dismiss(animated: true, completion: nil)
                                    })
                                    
                                    alertVC.addAction(pokedexAction)
                                    alertVC.addAction(okAction)
                                    present(alertVC, animated: true, completion: nil)
                                }
                            }
                        }
                        
                    } else {
                        if let pokeAnnotation = view.annotation as? PokeAnnotation {
                            if let name = pokeAnnotation.pokemon.name {
                                let alertVC = UIAlertController(title: "Bummer! 🤬", message: "You are too far from this \(name) to catch it", preferredStyle: .alert)
                                
                                let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
                                    alertVC.dismiss(animated: true, completion: nil)
                                })
                                
                                alertVC.addAction(okAction)
                                present(alertVC, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if updateCount < 3 {
            if let center = manager.location?.coordinate {
                let region = MKCoordinateRegionMakeWithDistance(center, 300, 300)
                mapView.setRegion(region, animated: true)
            }
            updateCount += 1
        } else {
            manager.stopUpdatingLocation()
        }
    }
    
    @IBAction func centerTapped(_ sender: Any) {
        if let center = manager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(center, 300, 300)
            mapView.setRegion(region, animated: false)
        }
    }
    
    
}

