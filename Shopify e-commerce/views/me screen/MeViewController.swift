//
//  MeViewController.swift
//  Shopify e-commerce
//
//  Created by Ayman Omara on 24/05/2021.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit
import DropDown

class MeViewController: UIViewController {
    
    @IBOutlet private weak var currencyLabel: UILabel!
    @IBOutlet private weak var signOut: UIButton!
    @IBOutlet private weak var editCustomerData: UIButton!
    private var currencyDropMenu:DropDown!
    private var userData:UserData!

    
    var meViewModel = MeViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "ME";
        
        userData = UserData.sharedInstance
        currencyLabel.text = userData.getCurrency()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        currencyLabel.addGestureRecognizer(tap)
        currencyLabel.isUserInteractionEnabled = true
        
        //initialize drop menu
        currencyDropMenu = DropDown()
        currencyDropMenu.anchorView = currencyLabel
        currencyDropMenu.dataSource = Constants.currencies
        currencyDropMenu.direction = .bottom
        currencyDropMenu.bottomOffset = CGPoint(x: 0, y:currencyLabel.frame.height)
        
        //dropList actions
        currencyDropMenu.selectionAction = { [unowned self] (index: Int, item: String) in
            self.currencyLabel.text = item
            self.userData.setCurrency(type: item)
        }
        
    }
    
    @objc func tapFunction() {
        currencyDropMenu.show()
       }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    
    
    func signoutAction(){
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
    
    
    
    
    
    func editCustomerAction(){
        let editvc = self.storyboard?.instantiateViewController(identifier: "EditIngViewController") as! EditIngViewController
        self.navigationController?.pushViewController(editvc, animated: true)
    }
    
}

