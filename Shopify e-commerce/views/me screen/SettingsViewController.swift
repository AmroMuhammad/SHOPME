//
//  SettingsViewController.swift
//  Shopify e-commerce
//
//  Created by Ayman Omara on 25/05/2021.
//  Copyright © 2021 ITI41. All rights reserved.

import UIKit
import RxSwift
import RxCocoa
import TKFormTextField
class SettingsViewController: UIViewController {
    
    @IBOutlet weak var signInOutlet: UIView!
//    @IBOutlet weak var welcome: UILabel!
    @IBOutlet weak var emailTextField: TKFormTextField!
    @IBOutlet weak var register: UIButton!
    @IBOutlet weak var passwordTextField: TKFormTextField!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var isLoggedTableViewView: UIView!
    @IBOutlet weak var isNoItemView: UIView!
    @IBOutlet weak var welcomeView: UIView!
    @IBOutlet weak var orderTableView: UITableView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    private var activityView:UIActivityIndicatorView!
    private var disposeBag:DisposeBag!
    private var meViewModel:MeViewModel!
    private var userData:UserData!

    @IBAction func passwordEditindChange(_ sender: Any) {
        if(passwordTextField.text == ""){
            passwordTextField.error = "All fields required"
        }
        else{
            passwordTextField.error = nil
        }
    }
    @IBAction func emailEditingChanged(_ sender: Any) {
        if(emailTextField.text == ""){
            emailTextField.error = "All fields required"
        }
        else if(!meViewModel.emailRegexCheck(text: emailTextField.text!)){
            emailTextField.error = "inavlid email"
        }
        else{
            emailTextField.error = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ME"
        
        userData = UserData.sharedInstance
        meViewModel = MeViewModel()
        disposeBag = DisposeBag()
        activityView = UIActivityIndicatorView(style: .large)
        
        meViewModel.errorObservable.subscribe(onNext: {[weak self] (message, boolValue) in
            if(boolValue){
                if(message.contains("networkLayer")){
                    Support.notifyUser(title: "Error", body: "No Internet Connection", context: self!)
                }else{
                    if(message.contains("noItems")){
                        self?.isNoItemView.isHidden = false
                    }else{
                        if message == "Email or password is Wrong"{
                            self!.emailTextField.error = message
                            self!.passwordTextField.error = message
                        }
                        else{
                        Support.notifyUser(title: "Error", body: message, context: self!)
                        self?.isNoItemView.isHidden = true
                        }
                    }
                }
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
        
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 40)))
        button.setTitle("Load more", for: .normal)
        button.backgroundColor = .lightGray
        button.addTarget(self, action: #selector(moreButtonClicked(_:)), for: .touchUpInside)
                
        let registerGesture = UITapGestureRecognizer(target: self, action: #selector(registerTap))
        registerGesture.numberOfTapsRequired = 1
        register.addGestureRecognizer(registerGesture)
        
        meViewModel.localObservable.bind(to: tableview.rx.items(cellIdentifier: "localCell")){[weak self] row,item,cell in
            self?.isNoItemView.isHidden = true
            if(row == 3){
                self?.tableview.tableFooterView = button
                cell.textLabel?.text = item.title
                cell.imageView?.image = UIImage(data: item.productImageData)
            }else{
                cell.textLabel?.text = item.title
                self?.tableview.tableFooterView = nil
                cell.imageView?.image = UIImage(data: item.productImageData)
            }
        }.disposed(by: disposeBag)
        
        meViewModel.ordersObservable.bind(to: orderTableView.rx.items(cellIdentifier: "OrderTableViewCell")){row,item,cell in
            let castedCell = cell as! OrderTableViewCell
            castedCell.orderPriceLabel.text = "Price: " + item.totalPrice
            castedCell.orderDateLabel.text = "Created At: " + item.creationDate
            castedCell.accessoryType = .disclosureIndicator
        }.disposed(by: disposeBag)
        

        tableview.rx.modelSelected(LocalProductDetails.self).subscribe(onNext: {[weak self] (cartProduct) in
            let storyBoard : UIStoryboard = UIStoryboard(name: "productDetails", bundle:nil)
            let productDetailsVC = storyBoard.instantiateViewController(identifier: Constants.productDetailsVC) as! ProductDetailsTableViewController
            productDetailsVC.productId = "\(cartProduct.productId)"
            productDetailsVC.productMainCategory = "\(cartProduct.mainCategory!)"
            self?.navigationController?.pushViewController(productDetailsVC, animated: true)
        }).disposed(by: disposeBag)
        
        orderTableView.rx.modelSelected(Order.self).subscribe(onNext: {[weak self] (orderItem) in
            let orderVC = self?.storyboard?.instantiateViewController(identifier: "OrderViewController") as! OrderViewController
            orderVC.orderID = orderItem.orderId
            self?.present(orderVC, animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        
    }
    
    @objc func moreButtonClicked(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "shop", bundle: nil)
            let favVC = storyboard.instantiateViewController(identifier: "wishListViewController")
            self.navigationController?.pushViewController(favVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(userData.isLoggedIn()){
            print("logged In")
            showWelcomeView()
        }else{
            print("Logged Off")
            showLoginView()
        }
        meViewModel.fetchLocalData()
        meViewModel.fetchOrders()
    }
    
    func showLoginView(){
        welcomeView.isHidden = true
        signInOutlet.alpha = 1
        register.alpha = 1
        isLoggedTableViewView.isHidden = false
    }
    
    func showWelcomeView(){
        welcomeView.isHidden = false
        signInOutlet.alpha = 0
        register.alpha = 0
        emailTextField.text = ""
        passwordTextField.text = ""
        meViewModel.fetchLocalData()
        isLoggedTableViewView.isHidden = true
        meViewModel.fetchOrders()
        let firstName = userData.getUserFromUserDefaults().firstName ?? " "
        let lastName = userData.getUserFromUserDefaults().lastName ?? " "
        welcomeLabel.text = "Welcome, " + firstName + " " + lastName
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        let meScreen = self.storyboard?.instantiateViewController(identifier: "MeViewController") as! MeViewController
        self.navigationController?.pushViewController(meScreen, animated: true)
    }
    
    @objc func registerTap() {
        let registerVC = self.storyboard?.instantiateViewController(identifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        
            if emailTextField.text == ""{
                emailTextField.error = "all faild required"
            }
            if passwordTextField.text == ""{
                passwordTextField.error = "all faild required"
            }
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
