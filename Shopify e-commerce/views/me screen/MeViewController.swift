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
    
    var userData = UserData.getInstance()
    var meViewModel = MeViewModel()
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

        self.navigationController?.title = "ME";
        
        
         let editGesture = UITapGestureRecognizer(target: self, action: #selector(editCustomerAction))
         
         signOutGesture.numberOfTapsRequired = 1
         editCustomerData.addGestureRecognizer(editGesture)

         
         
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        var tuble = userData.userStatus()
        if(tuble.0 != "" && tuble.2 != 0){
            editCustomerData.alpha = 1
        }
        else{
            editCustomerData.alpha = 0
        }
        
        
    }
    
    
    
    @IBOutlet weak var editCustomerData: UIButton!
    
    @objc func signoutAction(){
        meViewModel.signOutUser()
        self.registerDoneAlert(context: self)
        signOut.alpha = 0
    }
    func registerDoneAlert(context:UIViewController) -> Void {
        let signOutSucsess = UIAlertController(title: "signOut Succesfully", message: "", preferredStyle: UIAlertController.Style.alert)
        signOutSucsess.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
        context.present(signOutSucsess, animated: true, completion: nil)
    }
    @IBAction func aboutUS(_ sender: Any) {
        let aboutusvc = self.storyboard?.instantiateViewController(identifier: "AboutUsViewController") as! AboutUsViewController
        self.navigationController?.pushViewController(aboutusvc, animated: true)

    }
    
    
    
    
    
    @objc func editCustomerAction(){
        let editvc = self.storyboard?.instantiateViewController(identifier: "EditIngViewController") as! EditIngViewController
        self.navigationController?.pushViewController(editvc, animated: true)
    }
    
}

