//
//  ViewController.swift
//  Stormy
//
//  Created by Bernie Zang on 1/4/15.
//  Copyright (c) 2015 Bernie Zang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipChanceLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!
    private let apiKey = "2a0d195edf5cf9365fa02b72ed35f41c"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshActivityIndicator.hidden = true
        getWeather()
    }
    
    func getWeather() {
        let coordinates = "39.941614,-75.182271"
        let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
        let forecastURL = NSURL(string: coordinates, relativeToURL:baseURL)

        let sharedSession = NSURLSession.sharedSession()
        let downloadTask: NSURLSessionDownloadTask =
        sharedSession.downloadTaskWithURL(forecastURL!,
            completionHandler: { (location: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in
                if (error == nil) {
                    let dataObject = NSData(contentsOfURL: location)
                    let weather = NSJSONSerialization.JSONObjectWithData(dataObject!, options: nil, error: nil) as NSDictionary
                    let currentWeather = Current(weatherDictionary: weather)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.currentTempLabel.text = "\(currentWeather.temperature)"
                        self.currentTimeLabel.text = "At \(currentWeather.currentTime!) it is"
                        self.humidityLabel.text = "\(currentWeather.humidity * 100) %"
                        self.precipChanceLabel.text = "\(currentWeather.precipProbability * 100) %"
                        self.summaryLabel.text = "\(currentWeather.summary)"
                        self.iconView.image = currentWeather.icon!
                        
                        self.stopRefreshIndicator()
                        
                    })
                } else {
                    let networkIssueController = UIAlertController(title: "Error", message: "Unabled to load weather data. Cannot connect to internet", preferredStyle: .Alert)
                    
                    let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    networkIssueController.addAction(okButton)
                    self.presentViewController(networkIssueController, animated: true, completion: nil)
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.stopRefreshIndicator()
                })
        })
        downloadTask.resume()
    }
    
    func startRefreshIndicator() {
        refreshButton.hidden = true
        refreshActivityIndicator.hidden = false
        refreshActivityIndicator.startAnimating()
    }

    func stopRefreshIndicator() {
        refreshButton.hidden = false
        refreshActivityIndicator.hidden = true
        refreshActivityIndicator.stopAnimating()
    }
    
    @IBAction func refresh() {
        startRefreshIndicator()
        getWeather()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

