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
    @IBOutlet weak var welcome: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var register: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var tableview: UITableView!
    private var activityView:UIActivityIndicatorView!

    //Amr
    var userData:UserData!

    //Ayman
    var isLoged = false;
    var isWhishList = true;
    var meViewModel:MeViewModel!
    var error:String!
    var whishListArray = ["whishListArray","whishListArray","whishListArray","whishListArray"]
    var bagArray = ["bag1","bag1","bag1","bag1","bag1","bag1"]
    var disposeBag:DisposeBag!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "Settings"
        userData = UserData.sharedInstance
        meViewModel = MeViewModel()
        disposeBag = DisposeBag()
        activityView = UIActivityIndicatorView(style: .large)
        
        meViewModel.errorObservable.subscribe(onNext: { (message, boolValue) in
            if(boolValue){
                Support.notifyUser(title: "Error", body: message, context: self)
            }
            }).disposed(by: disposeBag)
        
        meViewModel.loadingObservable.subscribe(onNext: {[weak self] (boolValue) in
            switch boolValue{
            case true:
                self?.showLoading()
            case false:
                self?.hideLoading()
            }
            }).disposed(by: disposeBag)
        
        meViewModel.signedInObservable.subscribe(onNext: {[weak self] (boolValue) in
            switch boolValue{
            case true:
                self?.showWelcomeView()
            case false:
                self?.showLoginView()
            }
            }).disposed(by: disposeBag)
        
        tableview.delegate = self
        tableview.dataSource = self
        self.changeTableDataSource()
        signInOutlet.alpha = 0
        
        let registerGesture = UITapGestureRecognizer(target: self, action: #selector(registerTap))
        registerGesture.numberOfTapsRequired = 1
        register.addGestureRecognizer(registerGesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(userData.isLoggedIn()){
            print("logged In")
            showWelcomeView()
        }else{
            print("Logged Off")
            showLoginView()
        }
//        welcome.alpha = 0
//        if(userData.userStatus().0 != ""){
//            wantToLogin.alpha = 0
//            print("inside view will appear in if condition")
//            print(userData.userStatus().0)
//            register.alpha = 0
//            welcome.alpha = 1
//            signInOutlet.alpha = 0
//            welcome.text! = userData.userStatus().0
//            
//        }else if(userData.userStatus().0 == ""){
//            wantToLogin.alpha = 1
//            register.alpha = 1
//            welcome.alpha = 0
//            signInOutlet.alpha = 0
//            print("inside view will appear in else condition")
//            print(userData.userStatus().0)
//
//        }
    }
    
    func showLoginView(){
        welcome.alpha = 0
        signInOutlet.alpha = 1
        //register.alpha = 1
        //wantToLogin.alpha = 0
    }
    
    func showWelcomeView(){
            welcome.alpha = 1
            signInOutlet.alpha = 0
        }
    
    @objc func registerTap() {
        let registerVC = self.storyboard?.instantiateViewController(identifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(registerVC, animated: true)
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
    
    
    @IBAction func settings(_ sender: UIButton) {
        let meScreen = self.storyboard?.instantiateViewController(identifier: "MeViewController") as! MeViewController
        self.navigationController?.pushViewController(meScreen, animated: true)
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        meViewModel.validateRegisterdData(email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    func showLoading() {
        activityView!.center = self.view.center
        self.view.addSubview(activityView!)
        activityView!.startAnimating()
    }
    
    func hideLoading() {
        activityView!.stopAnimating()
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
