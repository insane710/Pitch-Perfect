//
//  LocationViewController.swift
//  Pitch Perfect
//
//  Created by Dheeraj Gembali on 11/12/14.
//  Copyright (c) 2014 Insanity. All rights reserved.
//

import UIKit
import CoreLocation

class LocationViewController: UIViewController, CLLocationManagerDelegate, NSURLConnectionDelegate {
    
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitude: UILabel!
    
    let locationManager = LocationManager.sharedManager
    
    override func viewDidLoad() {
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            println("Location services are not enabled");
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - CoreLocation Delegate Methods
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationManager.stopUpdatingLocation()

        if ((error) != nil) {
            print(error)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        locationManager.stopUpdatingLocation()
        
        var locationArray = locations as NSArray
        var locationObj = locationArray.lastObject as CLLocation
        var coord = locationObj.coordinate
        println(coord.latitude)
        println(coord.longitude)
        
        let latitudeText: String = String(format: "%.2f", coord.latitude)
        println(latitudeText)
        let longitudeText: String = String(format: "%.2f", coord.longitude)
        println(longitudeText)

        latitude.text = latitudeText
        longitude.text = longitudeText
    }
    
    @IBAction func sendRequest(sender: AnyObject) {
        var ipAddress = IPAddress.ipAddressForInterface("en0")
        if !(ipAddress != nil) {
            ipAddress = IPAddress.ipAddressForInterface("en1")
        }
        
        var url: NSURL = NSURL(string: NSString(format: "http://%@:9000", ipAddress))!
        var urlRequest = NSURLRequest(URL: url)
        var urlConnection = NSURLConnection(request: urlRequest, delegate: self)

        urlConnection?.start()
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        println(response)
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        var responseString = NSString(data: data, encoding:NSUTF8StringEncoding)
        println(responseString)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        println(error.description)
    }
}
