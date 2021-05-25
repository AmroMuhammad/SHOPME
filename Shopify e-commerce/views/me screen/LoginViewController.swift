//
//  LoginViewController.swift
//  Shopify e-commerce
//
//  Created by Ayman Omara on 25/05/2021.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordFeild: UITextField!
    @IBOutlet weak var userNameFeild: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        userNameFeild.placeholder = "please enter your user name"
        passwordFeild.placeholder = "please enter your user password"
    }
    

    @IBAction func submit(_ sender: Any) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
