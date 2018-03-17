//
//  PokeAnnotation.swift
//  Pokemon Go
//
//  Created by Steven Lerner on 3/16/18.
//  Copyright © 2018 Steven Lerner. All rights reserved.
//

import UIKit
import MapKit

class PokeAnnotation : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var pokemon : Pokemon
    
    init(coord:CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coord
        self.pokemon = pokemon
    }
}
