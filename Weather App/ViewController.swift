//
//  ViewController.swift
//  Weather App
//
//  Created by Mehmet Ozdemir on 7/21/18.
//  Copyright © 2018 Mehmet Ozdemir. All rights reserved.
//

import UIKit
import Foundation
import Alamofire


class ViewController: UIViewController {
    @IBOutlet var weatherText: UITextView!
    @IBOutlet var citytext: UITextField!
    @IBAction func submitButton(_ sender: Any) {
        let city = replace(city: citytext.text!);
        
        getLocationKey(city: city)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getLocationKey(city:String)->Void{
        var key = "";
        var weather = "";
        let citySearchURL = "http://dataservice.accuweather.com/locations/v1/cities/search?apikey={}&q=\(city)";
        
        Alamofire.request(citySearchURL)
            .responseString { response in
                // check for errors
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET request")
                    print(response.result.error!)
                    return
                }
                let str = response.result.value
                let data = str?.data(using: String.Encoding.utf8, allowLossyConversion: false)!

                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [Any]
                    var keyArray = json[0] as! [String:Any];
                    key = keyArray["Key"] as! String;
                    self.getLocationWeather(key: key);
                    
                    
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
        }
    }
    
    private func getLocationWeather(key:String)->Void{
        var weather = "";
                let weatherSearchURL = "http://dataservice.accuweather.com/forecasts/v1/daily/1day/\(key)?apikey={}";
                print("here is the key \(key)")
        
                Alamofire.request(weatherSearchURL)
                    .responseString { response in
                        // check for errors
                        guard response.result.error == nil else {
                            // got an error in getting the data, need to handle it
                            print("error calling GET request")
                            print(response.result.error!)
                            return
                        }
                        let str = response.result.value
                        let data = str?.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        
                        do {
                            let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                            var weatherArray = json["Headline"] as! [String:Any];
                            weather = weatherArray["Text"] as! String;
                            self.assignWeatherText(weather: weather);
                            
                            
                        } catch let error as NSError {
                            print("Failed to load: \(error.localizedDescription)")
                        }
                        
                        
                        
        
        }
        
        
    }
    
    private func assignWeatherText(weather:String)->Void{
        weatherText.text = weather;
    }
    
    
    private func replace(city:String) -> String{
        var finalString = "";
        for x in city {
            if(x==" "){
                finalString = finalString + "%20";
            }
            else{
                finalString = "\(finalString)\(x)";
            }
        }
        return finalString;
    }
    
    


}

