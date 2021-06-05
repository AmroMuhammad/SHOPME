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
    @IBOutlet weak var signInOutlet: UIView!
    @IBOutlet weak var customerEmail: UILabel!
    @IBOutlet weak var welcome: UILabel!
    @IBOutlet weak var wantToLogin: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var register: UIButton!
    
    @IBAction func loginBtn(_ sender: Any) {
        
        meViewModel.checkUserName_Password(email: emailTextField.text!, password: passwordTextField.text!, context: self, array: array)
        //self.checkUserName_Password()
        
    }
    @IBOutlet weak var passwordTextField: UITextField!
    
    var isLoged = false;
    var isWhishList = true;
    var array:[CustomerElement] = [CustomerElement]()
    var meViewModel = MeViewModel()
    var error:String!
    
    
    var whishListArray = ["whishListArray","whishListArray","whishListArray","whishListArray"]
    var bagArray = ["bag1","bag1","bag1","bag1","bag1","bag1"]
    var userData = UserData.getInstance()
    var support = Support()
    
    func checkUserLogedIn() -> Void {
        let tuble = userData.userStatus()
        if(tuble.1){
            welcome.alpha = 1
            customerEmail.text! = tuble.0
            register.alpha = 0
            wantToLogin.alpha = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "Settings"
        
        self.checkUserLogedIn()
        
        meViewModel.bindCustomerToView = {
            self.onSucsses()
        }
        meViewModel.bindErrorToView = {
            self.fail()
        }
        
        tableview.delegate = self
        tableview.dataSource = self
        self.changeTableDataSource()
        signInOutlet.alpha = 0
        
        let registerGesture = UITapGestureRecognizer(target: self, action: #selector(registerTap))
        
        registerGesture.numberOfTapsRequired = 1
        register.addGestureRecognizer(registerGesture)
        
        let wantToLoginGesture = UITapGestureRecognizer(target: self, action: #selector(wantToLoginTap))
        
        wantToLoginGesture.numberOfTapsRequired = 1
        wantToLogin.addGestureRecognizer(wantToLoginGesture)
        
    }
    
    func onSucsses(){
        array = meViewModel.customer
    }
    func fail(){
        error = meViewModel.errorMessage
        support.notifyUser(title: error, body: Constants.empty, context: self)
    }
    
    @objc func wantToLoginTap(){
        signInOutlet.alpha = 1
        register.alpha = 0
        wantToLogin.alpha = 0
    }
    @objc func registerTap() {
        
        let registervc = self.storyboard?.instantiateViewController(identifier: "RegisterViewController") as! RegisterViewController
        self.present(registervc, animated: true, completion: nil )
        navigationController?.pushViewController(registervc, animated: true);
    }
    
    
    
    
    
//    func checkUserName_Password() -> Void {
//        if emailTextField.text != "" && passwordTextField.text != "" {
//            self.checkIsCustomerexist(email: emailTextField.text!, password: passwordTextField.text!)
//        }
//        else{
//            support.notifyUser(title: Constants.u_p_required_t, body: Constants.u_p_required_t, context: self)
//        }
//    }
//    func checkIsCustomerexist(email:String,password:String)->Void{
//        for customer in array{
//            if customer.email == email && customer.tags == password {
//
//                userData.saveUserDefaults(email: customer.email!, id: customer.id!)
//                let mytuble = userData.userStatus()
//                print(mytuble.0)
//                print("===============================================")
//                print(mytuble.1)
//                print(userData.userStatus())
//                support.notifyUser(title: Constants.loginSuccess, body: Constants.loginSuccess, context: self)
//
//            }
//            else if(customer.email != email && customer.tags != password){
//                support.notifyUser(title: Constants.wrongEmail_Pass, body: Constants.empty, context: self)
//            }
//        }
//
//    }
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
