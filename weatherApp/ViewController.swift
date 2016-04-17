//
//  ViewController.swift
//  weatherApp
//
//  Created by Evan on 4/15/16.
//  Copyright © 2016 Evan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var weatherLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    @IBAction func findWeather(sender: AnyObject) {
        
        var successful = false
        
        let attemptedUrl = NSURL(string: "http://www.weather-forecast.com/locations/\(textField.text!.stringByReplacingOccurrencesOfString(" ", withString: "-"))/forecasts/latest")
        
        if let url = attemptedUrl {
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            
            if let urlContent = data {
                
                let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                
                let websiteArray = webContent?.componentsSeparatedByString("3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")
                
                if websiteArray!.count > 1 {
                    
                    let weatherArray = websiteArray![1].componentsSeparatedByString("</span>")
                    
                    if weatherArray.count > 1 {
                        
                        successful = true
                        
                        let weatherSummary = weatherArray[0].stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            self.weatherLabel.text = weatherSummary
                        })
                    }
                }
            }
            
            if successful == false {
                self.weatherLabel.text = "We couldn't find the weather for that city. Please try again."
            }
        }
        
        task.resume()
        
        } else {
            
            self.weatherLabel.text = "We couldn't find the weather for that city. Please try again."
            
        }
    }
    
}



