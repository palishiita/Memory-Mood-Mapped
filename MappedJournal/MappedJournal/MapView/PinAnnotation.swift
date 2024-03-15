//
//  PinAnnotation.swift
//  MappedJournal
//
//  Created by BamaLiu on 2024/1/9.
//

import Foundation
import MapKit

class PinAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var categorySymbol: String

    init(coordinate: CLLocationCoordinate2D, categorySymbol: String) {
        self.coordinate = coordinate
        self.categorySymbol = categorySymbol
    }
}
