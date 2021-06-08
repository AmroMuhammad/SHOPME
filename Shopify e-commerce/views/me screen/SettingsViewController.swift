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
    
    @IBAction func settings(_ sender: UIButton) {
        let meScreen = self.storyboard?.instantiateViewController(identifier: "MeViewController") as! MeViewController
        self.navigationController?.pushViewController(meScreen, animated: true)
    }
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var signInOutlet: UIView!
    
    @IBOutlet weak var welcome: UILabel!
    @IBOutlet weak var wantToLogin: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var register: UIButton!
    
    let userData:UserData = UserData.getInstance()
    
    @IBAction func loginBtn(_ sender: Any) {
        print(userData.userStatus())
        meViewModel.checkIsCustomerexist(email: emailTextField.text!, password: passwordTextField.text!, array: array, context: self, welcome: welcome, signInOutlet: signInOutlet,emailTextField: emailTextField, passwordTextField: passwordTextField)
       

    }
    @IBOutlet weak var passwordTextField: UITextField!
    
    var isLoged = false;
    var isWhishList = true;
    var array:[CustomerElement] = [CustomerElement]()
    var meViewModel = MeViewModel()
    var error:String!
    

    
    var whishListArray = ["whishListArray","whishListArray","whishListArray","whishListArray"]
    var bagArray = ["bag1","bag1","bag1","bag1","bag1","bag1"]
    
    var support = Support()
    

    
    
    override func viewWillAppear(_ animated: Bool) {
        welcome.alpha = 0
        if(userData.userStatus().0 != ""){
            wantToLogin.alpha = 0
            print("inside view will appear in if condition")
            print(userData.userStatus().0)
            register.alpha = 0
            welcome.alpha = 1
            signInOutlet.alpha = 0
            welcome.text! = userData.userStatus().0
            
        }else if(userData.userStatus().0 == ""){
            wantToLogin.alpha = 1
            register.alpha = 1
            welcome.alpha = 0
            signInOutlet.alpha = 0
            print("inside view will appear in else condition")
            print(userData.userStatus().0)

        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "Settings"

        
        
        
        meViewModel.bindCustomerToView = {
            self.onSucsses()
        }
        meViewModel.bindErrorToView = {
            self.fail()
        }
        meViewModel.bindCustomerName = {
            
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
        Support.notifyUser(title: error, body: Constants.empty, context: self)
    }
    
    @objc func wantToLoginTap(){
        welcome.alpha = 0
        signInOutlet.alpha = 1
        register.alpha = 0
        wantToLogin.alpha = 0
    }
    @objc func registerTap() {
        
        let registervc = self.storyboard?.instantiateViewController(identifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(registervc, animated: true)

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
