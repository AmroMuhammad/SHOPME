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
    @IBOutlet weak var isLoggedTableViewView: UIView!

    private var activityView:UIActivityIndicatorView!
    private var disposeBag:DisposeBag!
    private var meViewModel:MeViewModel!
    private var userData:UserData!

  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "Settings"
        userData = UserData.sharedInstance
        meViewModel = MeViewModel()
        disposeBag = DisposeBag()
        activityView = UIActivityIndicatorView(style: .large)
        
        meViewModel.errorObservable.subscribe(onNext: { (message, boolValue) in
            if(boolValue){
                if(message.contains("networkLayer")){
                    Support.notifyUser(title: "Error", body: "No Internet Connection", context: self)
                }else{
                    Support.notifyUser(title: "Error", body: message, context: self)
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
        
        segmentControl.rx.selectedSegmentIndex.subscribe(onNext: {[weak self] index in
            if(self?.userData.isLoggedIn() ?? false){
                switch (index){
                case 0:
                    self?.meViewModel.fetchLocalData(type: "favourite")
                case 1:
                    self?.meViewModel.fetchLocalData(type: "wishlist")
                default:
                    break
                }
            }
            }).disposed(by: disposeBag)
        
        meViewModel.favouriteObservable.bind(to: tableview.rx.items(cellIdentifier: "localCell")){row,item,cell in
            if(row == 3){
                self.tableview.tableFooterView = button
                cell.textLabel?.text = item.title
                button.tag = 1
                cell.imageView?.image = UIImage(data: item.productImageData)
            }else{
                cell.textLabel?.text = item.title
                self.tableview.tableFooterView = nil
                cell.imageView?.image = UIImage(data: item.productImageData)
            }
        }.disposed(by: disposeBag)
        
//        meViewModel.wishlistObservable.bind(to: tableview.rx.items(cellIdentifier: "localCell")){row,item,cell in
//            if(row == 3){
//                self.tableview.tableFooterView = button
//                cell.textLabel?.text = item.title
//                cell.imageView?.image = UIImage(data: item.productImageData)
//                button.tag = 2
//            }else{
//                cell.textLabel?.text = item.title
//                cell.imageView?.image = UIImage(data: item.productImageData)
//                self.tableview.tableFooterView = nil
//            }
//        }.disposed(by: disposeBag)
        
        tableview.rx.modelSelected(LocalProductDetails.self).subscribe(onNext: {[weak self] (cartProduct) in
            let storyBoard : UIStoryboard = UIStoryboard(name: "productDetails", bundle:nil)
            let productDetailsVC = storyBoard.instantiateViewController(identifier: Constants.productDetailsVC) as! ProductDetailsTableViewController
            productDetailsVC.productId = "\(cartProduct.productId)"
            productDetailsVC.productMainCategory = "\(cartProduct.mainCategory!)"
            self?.navigationController?.pushViewController(productDetailsVC, animated: true)
        }).disposed(by: disposeBag)
        
        tableview.rx.modelSelected(LocalProductDetails.self).subscribe(onNext: {[weak self] (favProduct) in
            let storyBoard : UIStoryboard = UIStoryboard(name: "productDetails", bundle:nil)
            let productDetailsVC = storyBoard.instantiateViewController(identifier: Constants.productDetailsVC) as! ProductDetailsTableViewController
            productDetailsVC.productId = "\(favProduct.productId)"
            productDetailsVC.productMainCategory = "\(favProduct.mainCategory!)"
            self?.navigationController?.pushViewController(productDetailsVC, animated: true)
        }).disposed(by: disposeBag)
    }
    
    @objc func moreButtonClicked(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "shop", bundle: nil)
        if(sender.tag == 1){
            let favVC = storyboard.instantiateViewController(identifier: "wishListViewController")
            self.navigationController?.pushViewController(favVC, animated: true)
        }else{
            let wishVC = storyboard.instantiateViewController(identifier: "cartViewController")
            self.navigationController?.pushViewController(wishVC, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(userData.isLoggedIn()){
            print("logged In")
            showWelcomeView()
        }else{
            print("Logged Off")
            showLoginView()
        }
    }
    
    func showLoginView(){
        welcome.alpha = 0
        signInOutlet.alpha = 1
        register.alpha = 1
        isLoggedTableViewView.isHidden = false
    }
    
    func showWelcomeView(){
        welcome.alpha = 1
        signInOutlet.alpha = 0
        register.alpha = 0
        emailTextField.text = ""
        passwordTextField.text = ""
        meViewModel.fetchLocalData(type: "favourite")
        isLoggedTableViewView.isHidden = true
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
