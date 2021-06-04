//
//  MeViewController.swift
//  Shopify e-commerce
//
//  Created by Ayman Omara on 24/05/2021.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit

class MeViewController: UIViewController {
    
    @IBOutlet weak var signOut: UIButton!
    let currencyArray = ["USD","LE"];
    var userData = UserData.getInstance()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var tuble = userData.userStatus()
        if(tuble.1){
            
        }else{
            signOut.alpha = 0
        }
        
        let signOutGesture = UITapGestureRecognizer(target: self, action: #selector(signoutAction))
        
        signOutGesture.numberOfTapsRequired = 1
        signOut.addGestureRecognizer(signOutGesture)
        
        pickerView.dataSource = self
        pickerView.delegate = self
        self.navigationController?.title = "ME";
        
    }
    @objc func signoutAction(){
        userData.deleteUserDefaults()
    }
    
    
    
    @IBAction func aboutUS(_ sender: Any) {
        let settingsVC = self.storyboard?.instantiateViewController(identifier: "SettingsViewController") as! SettingsViewController
        self.present(settingsVC, animated: true, completion: nil )
        navigationController?.pushViewController(settingsVC, animated: true);
    }
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    
}
// MARK:- pickerview for currency
extension MeViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return currencyArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        currencyArray[row]
        
    }
}
