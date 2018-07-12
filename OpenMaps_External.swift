//
//  UploadFile.swift
//  Service App-Provider
//
//  Created by IosDeveloper on 06/06/18.
//  Copyright © 2018 serviceApp. All rights reserved.
//

import Foundation
import UIKit

//MARK:- Open location in Maps
extension SwiftCodes
{
    // ----> Keys Required
    /*
     <key>LSApplicationQueriesSchemes</key>
     <array>
     <string>googlechromes</string>
     <string>comgooglemaps</string>
     </array>
     */
    
    //MARK: Open Google maps
    func openGoogleMaps(){
        // Open in Google Maps
        if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL))
        {
            /// Driving google map
            ///"comgooglemaps://?saddr=&daddr=40.765819,-73.975866&directionsmode=driving"
            UIApplication.shared.open(URL.init(string: "comgooglemaps://?center=40.765819,-73.975866&zoom=14&views=traffic&q=40.765819,-73.975866")!, options: [:], completionHandler: nil)
        }
        else
        {
            print("Can't use Google Maps");
        }
    }
    
    //MARK: Open Mapkit
    func openMapKit(){
        /// Open in Mapkit
        let latitude:CLLocationDegrees = 40.773379
        let longitude: CLLocationDegrees = -73.964546
        let regiondistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionspan  = MKCoordinateRegionMakeWithDistance(coordinates, regiondistance, regiondistance)
        let options = [MKLaunchOptionsMapCenterKey:regionspan.center]
        
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapitem = MKMapItem(placemark: placemark)
        mapitem.name = "Lawyer Location"
        mapitem.openInMaps(launchOptions: options)
    }
}
