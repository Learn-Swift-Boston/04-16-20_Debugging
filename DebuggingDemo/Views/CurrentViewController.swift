//
//  CurrentViewController.swift
//  DebuggingDemo
//
//  Created by Matthew Dias on 4/11/20.
//  Copyright © 2020 Matthew Dias. All rights reserved.
//

import UIKit
import MapKit

class CurrentViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var feelsLike: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}
