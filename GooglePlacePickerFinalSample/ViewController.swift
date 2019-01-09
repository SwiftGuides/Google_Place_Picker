//
//  ViewController.swift
//  GooglePlacePickerFinalSample
//
//  Created by MacMini on 1/9/19.
//  Copyright © 2019 Immanent. All rights reserved.
//

import UIKit
import GooglePlaces
import GooglePlacePicker

class ViewController: UIViewController,GMSPlacePickerViewControllerDelegate {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var placeNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    // To receive the results from the place picker 'self' will need to conform to
    // GMSPlacePickerViewControllerDelegate and implement this code.
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("Place name \(place.name)")
        print("PostalCode\(place.addressComponents)")
        print("Place address \(place.formattedAddress)")
        print("Place attributions \(place.attributions)")
        
        //addressLabel.text = place.name
        placeNameLabel.text = place.formattedAddress
        
        
        //Get address Seperated like city,country,postalcode
        let arrays : Array = place.addressComponents!
        for i in 0..<arrays.count {
            
            let dics : GMSAddressComponent = arrays[i]
            let str : String = dics.type
            
            if (str == "country") {
                print("Country: \(dics.name)")
            }
            else if (str == "administrative_area_level_1") {
                print("State: \(dics.name)")
            }
            else if (str == "administrative_area_level_2") {
                print("City: \(dics.name)")
            }
            else if (str == "postal_code"){
                print("PostalCode:\(dics.name)")
                addressLabel.text = dics.name
            }
        }
    }
        
    
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("No place selected")
    }
    


    @IBAction func pickPlaceButton(_ sender: Any) {
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        
        //This delegate has to be called here to proper working of cancle and selected location feature , it is not mentioned in the official documentation
        placePicker.delegate = self
        
        
        present(placePicker, animated: true, completion: nil)
        
    }
}


