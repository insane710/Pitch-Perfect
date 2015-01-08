//
//  TodayViewController.swift
//  Where Am I
//
//  Created by Dheeraj Gembali on 11/12/14.
//  Copyright (c) 2014 Insanity. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreLocation

class TodayViewController: UIViewController, NCWidgetProviding, CLLocationManagerDelegate {
    
    @IBOutlet weak var locationLabel: UILabel!
    let locationManager = LocationManager.sharedManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        self.preferredContentSize = CGSizeMake(0, 75)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        locationLabel.text = "Loading..."
        startConnection()
    }
    override func preferredContentSizeDidChangeForChildContentContainer(container: UIContentContainer) {
        print("preferredContentSizeDidChangeForChildContentContainer")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        locationManager.stopUpdatingLocation()
        
        self.preferredContentSize = CGSizeMake(0, 75)

        var locationArray = locations as NSArray
        var location = locationArray.lastObject as CLLocation
        locationLabel.text = "Lat: \(location.coordinate.latitude), Long: \(location.coordinate.longitude)"
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationManager.stopUpdatingLocation()
        
        self.preferredContentSize = CGSizeMake(0, 75)
        locationLabel.text = "\(error.description)"
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
    func startConnection() {
        var ipAddress = IPAddress.ipAddressForInterface("en0")
        if !(ipAddress != nil) {
            ipAddress = IPAddress.ipAddressForInterface("en1")
        }
        
        var url: NSURL = NSURL(string: NSString(format: "http://%@:3000", ipAddress))!;
        var urlRequest = NSMutableURLRequest(URL: url)
        urlRequest.HTTPMethod = "POST"
        var dataString = "some data"
        var requestBodyData: NSData = dataString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
        
        urlRequest.HTTPBody = requestBodyData
        var urlConnection = NSURLConnection(request: urlRequest, delegate: self)
        
        urlConnection?.start()
    }
    
    @IBAction func fetchRequest(sender: AnyObject) {
        startConnection()
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        println(response)
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        var responseString: NSString = NSString(data: data, encoding:NSUTF8StringEncoding)!
        self.preferredContentSize = CGSizeMake(0, 75)
        locationLabel.text = "\(responseString)"
        println(responseString)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        self.preferredContentSize = CGSizeMake(0, 500)
        locationLabel.text = String(error.code)
        locationLabel.text = String(error.description)
    }

}
