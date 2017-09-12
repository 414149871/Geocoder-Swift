//
//  MainVC.swift
//  Geocoder-Swift
//
//  Created by Rick_Liu on 2017/9/12.
//  Copyright © 2017年 Rick_Liu. All rights reserved.
//

import UIKit
import Mapbox

class MainVC: UIViewController {

    var mapView : MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        self.navigationItem.title = "Geocoder"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "search button").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(search(_:)))
        
        mapView = MGLMapView(frame: CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height-64))
        mapView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        view.addSubview(mapView)

    }

    func search(_ sender : UIBarButtonItem) {
     
        let searchVC = SearchVC()
        searchVC.delegate = self
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
}

extension MainVC : SearchVCDelegate {
    
    func searchPlace(dictionary: [String : Any]) {
        if let location = dictionary["location"] as? CLLocation {
            mapView.setCenter(location.coordinate, zoomLevel: 13, animated: true)
//                mapView.centerCoordinate = location.coordinate
            
        }
    }
}
