//
//  SettingsViewController.swift
//  Shopify e-commerce
//
//  Created by Ayman Omara on 25/05/2021.
//  Copyright © 2021 ITI41. All rights reserved.

import UIKit
import RxSwift
import RxCocoa

class SettingsViewController: UIViewController {
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBAction func wantToLogIn(_ sender: UIButton) {
        signInOutlet.alpha = 1
        
    }
    @IBOutlet weak var signInOutlet: UIView!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func register(_ sender: UIButton) {
        let registervc = self.storyboard?.instantiateViewController(identifier: "RegisterViewController") as! RegisterViewController
        self.present(registervc, animated: true, completion: nil )
        navigationController?.pushViewController(registervc, animated: true);
        
 
        
    }
    @IBAction func loginBtn(_ sender: Any) {
        self.checkUserName_Password()
    }
    @IBOutlet weak var passwordTextField: UITextField!
    
    var isLoged = false;
    var isWhishList = true;
    var array:[CustomerElement]!
    var whishListArray = ["whishListArray","whishListArray","whishListArray","whishListArray"]
    var bagArray = ["bag1","bag1","bag1","bag1","bag1","bag1"]
    var userData = UserData.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "Settings"
        let api = ShopifyAPI.shared
        
        api.getCustomers { (result) in
            switch(result){
            case .success(let response):
                let customers = response
                print(customers!.customers)
                self.array = customers?.customers
                
            case .failure(_):
                print("error")
            }
        }
        
        tableview.delegate = self
        tableview.dataSource = self
        self.changeTableDataSource()
        signInOutlet.alpha = 0
    }
    
    func checkUserName_Password() -> Void {
        if emailTextField.text != "" && passwordTextField.text != "" {
            self.checkIsCustomerexist(email: emailTextField.text!, password: passwordTextField.text!)
        }
        else{
            self.checkUserName_PasswordIsEnterd()
        }
    }
    func checkIsCustomerexist(email:String,password:String)->Void{
            for customer in array{
                if customer.email == email && customer.tags == password {
                    
                    userData.saveUserDefaults(userID: customer.email!)
                    let mytuble = userData.userStatus()
                    print(mytuble.0)
                    print("===============================================")
                    print(mytuble.1)
                    print(userData.userStatus())
                    
                }
                else if(customer.email == email && customer.password == nil ){
                    userData.saveUserDefaults(userID: customer.email!)
                    let mytuble = userData.userStatus()
                    print(mytuble.0)
                    print("===============================================")
                    print(mytuble.1)
                    print(userData.userStatus())
                    
                }
            }
        
    }
    func changeTableDataSource() -> Void {
        segmentControl.rx.selectedSegmentIndex.subscribe(onNext: {index in
            switch (index)
            {
            case 0:
                self.isWhishList = true;
                self.tableview.reloadData()
                print("case 0")
            case 1:
                self.isWhishList = false;
                self.tableview.reloadData()
                print("case 1")
            default:
                break
            }
            
        })
    }
    @IBOutlet weak var tableview: UITableView!
    //MARK:- Check if user is logdin or not and show message
    func checkUserName_PasswordIsEnterd()->Void{
        let alert = UIAlertController(title: "Email and password are required", message: "Email and password are required", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
// MARK:- Refactor to RX Swift
extension SettingsViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isWhishList {
            return whishListArray.count
        }
        else{
            return bagArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if isWhishList {
            cell.textLabel?.text = whishListArray[indexPath.row]
            return cell;
        }
        else{
            cell.textLabel?.text = bagArray[indexPath.row]
            return cell;
        }
    }
}
