//  RegisterViewController.swift
//  Shopify e-commerce
//  Created by Ayman Omara on 30/05/2021.
//  Copyright © 2021 ITI41. All rights reserved.
import UIKit
import RxCocoa
import RxSwift
import TKFormTextField

class RegisterViewController: UIViewController {
    @IBOutlet private weak var city: TKFormTextField!
    @IBOutlet private weak var country: TKFormTextField!
    @IBOutlet private weak var firstName: TKFormTextField!
    @IBOutlet private weak var lastName: TKFormTextField!
    @IBOutlet private weak var email: TKFormTextField!
    @IBOutlet private weak var phoneNumber: TKFormTextField!
    @IBOutlet private weak var confPassword: TKFormTextField!
    @IBOutlet private weak var password: TKFormTextField!
    private var activityView:UIActivityIndicatorView!

    
    private var registerViewModel:RegisterViewModel!
    private var disposeBag:DisposeBag!
    //var userData = UserData.getInstance().userStatus().0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disposeBag = DisposeBag()
        activityView = UIActivityIndicatorView(style: .large)
        
        self.title = "Regestration"
        registerViewModel = RegisterViewModel()

        registerViewModel.errorObservable.subscribe(onNext: { (message,boolResult) in
            if(boolResult){
                Support.notifyUser(title: "Error", body: message, context: self)
            }
            }).disposed(by: disposeBag)
        
        registerViewModel.loadingObservable.subscribe(onNext: {[weak self] (result) in
            switch result{
            case true:
                self?.showLoading()
            case false:
                self?.hideLoading()
            }
            }).disposed(by: disposeBag)
        
        registerViewModel.doneObservable.subscribe(onCompleted: {
            print(UserData.sharedInstance.getUserFromUserDefaults())
            print(UserData.sharedInstance.isLoggedIn())
            self.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }
    
    @IBAction func submit(_ sender: Any) {
//        registerViewModel.validateRegisterdData(firstName: firstName.text!, lastName: lastName.text!, email: email.text!, phoneNumber: phoneNumber.text!, password: password.text!, confirmPassword: confPassword.text!, country: country.text!, city: city.text!)
    
        registerViewModel.validateRegisterdData(firstName: firstName.text!, lastName: lastName.text!, email: email.text!, phoneNumber: phoneNumber.text!, password: password.text!, confirmPassword: confPassword.text!, country: country.text!, city: city.text!,pn: phoneNumber, context: self,fname: firstName,lname: lastName,em: email,count: country,cit: city,con:confPassword,p: password)
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
