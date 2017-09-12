//
//  SearchVC.swift
//  Geocoder-Swift
//
//  Created by 刘嘉豪 on 2017/9/12.
//  Copyright © 2017年 Rick_Liu. All rights reserved.
//

import UIKit
import MapboxGeocoder

let MapboxAccessToken = "<# your Mapbox access token #>"

protocol SearchVCDelegate {
    func searchPlace(dictionary : [String : Any])
}

class SearchVC: UIViewController {

    var textField : UITextField!
    var tableView : UITableView!
    var dataSource : Array<[String:Any]>!
    var geocoder : Geocoder!
    var delegate : SearchVCDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setUpNavigationBar()
        
        dataSource = [[String:Any]]()
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "CellIdentifier")
        view.addSubview(tableView)
        
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        geocoder = Geocoder(accessToken: MapboxAccessToken)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        textField.resignFirstResponder()
    }
    
    func setUpNavigationBar() {
        textField = UITextField(frame: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: 40))
        textField.placeholder = "Search"
        textField.tintColor = .black
        textField.clearButtonMode = .whileEditing
        textField.becomeFirstResponder()
        textField.delegate = self
        navigationItem.titleView = textField
    }
    
    
}

extension SearchVC : UITableViewDataSource , UITableViewDelegate {

    //MARK: -UITableViewDataSource-
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    //MARK: -UITableViewDelegate-
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dic = dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        cell.textLabel?.text = dic["qualifiedName"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dic = dataSource[indexPath.row]
       
        if let delegate = delegate  {
            delegate.searchPlace(dictionary: dic)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension SearchVC : UITextFieldDelegate {

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        self.dataSource.removeAll()
        self.tableView.reloadData()
        return true
    }
    
    //MARK: -Action-
    func textFieldDidChange(_ textField : UITextField) {
        print(textField.text!)
        
        guard let textString = textField.text else {
            return
        }
        let options = ForwardGeocodeOptions.init(query: textString)
        options.allowedScopes = .all
        _ = geocoder.geocode(options) { [unowned self] (placemarks, attribution, error) in
            
            if let error = error {
                print("error = \(error)")
            } else if let placemarks = placemarks , !placemarks.isEmpty {
                
                self.dataSource.removeAll()
                
                for i in 0..<placemarks.count{
                    let item = placemarks[i]
                    let dic = ["qualifiedName":item.qualifiedName ,"location": item.location] as [String : Any]
                    self.dataSource.append(dic)
                }
                self.tableView.reloadData()
            } else {
                print("empty")
            }
        }
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        print(textField.text!)
//        
//        guard let textString = textField.text else {
//            return false
//        }
//        let options = ForwardGeocodeOptions.init(query: textString)
//        options.allowedScopes = .all
//        _ = geocoder.geocode(options) { [unowned self] (placemarks, attribution, error) in
//            
//            if let error = error {
//                print("error = \(error)")
//            } else if let placemarks = placemarks , !placemarks.isEmpty {
//                
//                self.dataSource.removeAll()
//                
//                for i in 0..<placemarks.count{
//                    let item = placemarks[i]
//                    let dic = ["qualifiedName":item.qualifiedName ,"location": item.location] as [String : Any]
//                    self.dataSource.append(dic)
//                }
//                self.tableView.reloadData()
//            } else {
//                print("empty")
//            }
//        }
//        
//        return true
//    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
}

