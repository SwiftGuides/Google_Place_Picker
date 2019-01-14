import UIKit
import GooglePlaces
import GooglePlacePicker
import GoogleMaps

class ViewController: UIViewController,GMSPlacePickerViewControllerDelegate {
    

    @IBOutlet weak var postalCodeLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var localAreaNameLabel: UILabel!
    

    var latlong:CLLocationCoordinate2D!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didFailWithError error: Error) {
        print("cant pick location")
    }
    
    // To receive the results from the place picker 'self' will need to conform to
    // GMSPlacePickerViewControllerDelegate and implement this code.
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        print(place)
        print(place.coordinate.latitude)
        print(place.coordinate.longitude)
        
        

        
        //Create Location from coordinates and type CLLocationCoordinate2D
        let location = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        
        //This Function Will get all the address from marker locations
        getPlaceAddressFrom(location: location) { (city, country, postalcode, address) in
            let city = city ?? "Unknown"
            let country = country ?? "Unknown"
            let postalcode = postalcode ?? "Unknown"
            let localAddress = address ?? "Unknown"
            
            print("\(city + country + postalcode + localAddress)")
            
            self.cityLabel.text = city
            self.countryLabel.text = country
            self.postalCodeLabel.text = postalcode
            self.localAreaNameLabel.text = localAddress
        
        }
        
        
        print("Place name \(place.name)")
        print("PostalCode\(place.addressComponents)")
        print("Place address \(place.formattedAddress)")
        print("Place attributions \(place.attributions)")
        
        // let location = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        //This Function Will get all the address from marker locations
        /*   fetchCityAndCountry(from: location) { city, country, postalcode, address, error in
         guard let city = city, let country = country , let postalcode = postalcode , let areaName = address , error == nil else { return }
         print(city + ", " + country + ", " +  postalcode + ", " + areaName) // Rio de Janeiro, Brazil , 18409 , sector 20
         self.cityLabel.text = city
         self.countryLabel.text = country
         self.postalCodeLabel.text = postalcode
         self.localAreaNameLabel.text = areaName
         
         } */

    }
    
    
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("No place selected")
    }
    
    // Get Address using CLGeocoder (won't work properly in Google Maps )
  /*  func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?,_ postalCode: String?,_ address:String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       placemarks?.first?.postalCode,
                       placemarks?.first?.subLocality,
                       error)
        }
    } */
    
    
    // Get Address Using GMSGeoCoder
    func getPlaceAddressFrom(location: CLLocationCoordinate2D, completion: @escaping (_ city: String?, _ country:  String?,_ postalCode: String?,_ address:String?) -> Void) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(location) { response, error in
            if error != nil {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            } else {
                guard let places = response?.results(),
                    let place = places.first
                    else {
                        completion("","","","")  // has to pass empty parameters in this case
                        return
                }
                completion(place.locality, // City
                           place.country,  // Country
                           place.postalCode, // PostalCode
                           place.subLocality  // Local Area Name like (Sector 20)
                    
                    )
            }
        }
    }
    
    
    @IBAction func pickPlaceButton(_ sender: Any) {
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        
        //This delegate has to be called here to proper working of cancle and selected location feature , it is not mentioned in the official documentation
        placePicker.delegate = self
        
        
        present(placePicker, animated: true, completion: nil)
        
    }
}
