//
//  SecondViewController.swift
//  iosassignment2
//
//  Created by cagataygul on 12.12.2018.
//  Copyright © 2018 cagataygul. All rights reserved.
//

import UIKit
import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import CoreLocation


class SecondViewController: UIViewController,CLLocationManagerDelegate {

    
    @IBOutlet weak var backView2: UIView!
    @IBOutlet weak var city_name: UITextField!
    @IBOutlet weak var resim: UIImageView!
    @IBOutlet weak var searchLocation: UILabel!
    @IBOutlet weak var weatherDetail: UILabel!
    @IBOutlet weak var condition2: UILabel!
    
    @IBOutlet weak var degree: UILabel!
    var activity: NVActivityIndicatorView!
    let view_Layer2 = CAGradientLayer()
    let key = "be046fa993e5bc53552905f305df1ca5"
    @IBAction func searchBtn(_ sender: Any) {
        
       let city_name = self.city_name.text
        
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?q=" + city_name! + "&appid=be046fa993e5bc53552905f305df1ca5").responseJSON {
            response in
            self.activity.stopAnimating()
            if let responseStr = response.result.value {
                let jsonResponse = JSON(responseStr)
                let jsonWeather = jsonResponse["weather"].array![0]
                let jsonTemp = jsonResponse["main"]
                let iconName = jsonWeather["icon"].stringValue
                
                self.searchLocation.text = jsonResponse["name"].stringValue
                self.resim.image = UIImage(named: iconName)
                self.condition2.text = jsonWeather["main"].stringValue
                self.degree.text = "\(Int(((jsonTemp["temp"].doubleValue) - 273.15)))"
              
                
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE"
                self.weatherDetail.text = dateFormatter.string(from: date)
                
                let suffix = iconName.suffix(1)
                if(suffix == "n"){
                    self.setBlack()
                }else{
                    self.setBlue()
                }
            }
        }
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        backView2.layer.addSublayer(view_Layer2)
        let indicatorSize: CGFloat = 70
        let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2, y: (view.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
        activity = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20.0)
        activity.backgroundColor = UIColor.black
        view.addSubview(activity)
        activity.startAnimating()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        setBlue()
    }
    func setBlue(){
    let topColor = UIColor(red: 95.0/255.0, green: 165.0/255.0, blue: 1.0, alpha: 1.0).cgColor
    let bottomColor = UIColor(red: 72.0/255.0, green: 114.0/255.0, blue: 184.0/255.0, alpha: 1.0).cgColor
    view_Layer2.frame = view.bounds
    view_Layer2.colors = [topColor, bottomColor]
    }
    
    func setBlack(){
        let topColor = UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 72.0/255.0, green: 72.0/255.0, blue: 72.0/255.0, alpha: 1.0).cgColor
        view_Layer2.frame = view.bounds
        view_Layer2.colors = [topColor, bottomColor]
    }

}
