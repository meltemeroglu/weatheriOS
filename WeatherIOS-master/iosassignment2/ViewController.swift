//
//  ViewController.swift
//  iosassignment2
//
//  Created by cagataygul on 11.12.2018.
//  Copyright © 2018 cagataygul. All rights reserved.
//
import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import CoreLocation



class ViewController: UIViewController,  CLLocationManagerDelegate {

    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var days: UILabel!
    @IBOutlet weak var condition: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var numberofdegree: UILabel!
    @IBOutlet weak var backView: UIView!
    
    let view_Layer = CAGradientLayer()
    let key = "be046fa993e5bc53552905f305df1ca5"
   
    var lat = 38.4153
    var lon = 27.1445
    var activity: NVActivityIndicatorView!
    let myLocation = CLLocationManager()
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "asdasd.jpeg")!)
        super.viewDidLoad()
        backView.layer.addSublayer(view_Layer)
        let indicatorSize: CGFloat = 70
        let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2, y: (view.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
        activity = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20.0)
        activity.backgroundColor = UIColor.black
        view.addSubview(activity)
        myLocation.requestWhenInUseAuthorization()
        activity.startAnimating()
        if(CLLocationManager.locationServicesEnabled()){
            myLocation.delegate = self
            myLocation.desiredAccuracy = kCLLocationAccuracyBest
            myLocation.startUpdatingLocation()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        setBlue()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
       // lat = location.coordinate.latitude
       // lon = location.coordinate.longitude
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(key)&units=metric").responseJSON {
            response in
            self.activity.stopAnimating()
            if let responseStr = response.result.value {
                let jsonResponse = JSON(responseStr)
                let jsonWeather = jsonResponse["weather"].array![0]
                let jsonTemp = jsonResponse["main"]
                let iconName = jsonWeather["icon"].stringValue
                
                self.location.text = jsonResponse["name"].stringValue
                self.image.image = UIImage(named: iconName)
                self.condition.text = jsonWeather["main"].stringValue
                self.numberofdegree.text = "\(Int(round(jsonTemp["temp"].doubleValue)))"
                
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE"
                self.days.text = dateFormatter.string(from: date)
                
                let suffix = iconName.suffix(1)
                if(suffix == "n"){
                    self.setBlack()
                }else{
                    self.setBlue()
                }
            }
        }
        self.myLocation.stopUpdatingLocation()
    }
    func setBlue(){
        let topColor = UIColor(red: 95.0/255.0, green: 165.0/255.0, blue: 1.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 72.0/255.0, green: 114.0/255.0, blue: 184.0/255.0, alpha: 1.0).cgColor
        view_Layer.frame = view.bounds
        view_Layer.colors = [topColor, bottomColor]
        
    }
    
    func setBlack(){
        let topColor = UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 72.0/255.0, green: 72.0/255.0, blue: 72.0/255.0, alpha: 1.0).cgColor
       view_Layer.frame = view.bounds
        view_Layer.colors = [topColor, bottomColor]
    }
}


