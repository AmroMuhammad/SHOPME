//  RegisterViewController.swift
//  Shopify e-commerce
//  Created by Ayman Omara on 30/05/2021.
//  Copyright © 2021 ITI41. All rights reserved.
import UIKit
import RxCocoa
import RxSwift
import TKFormTextField

class RegisterViewController: UIViewController {
    
    
    @IBAction func firstNameEnd(_ sender: Any) {
        if(firstName.text == ""){
            firstName.error = "all fields are required"
        }
        else if(!registerViewModel.nameRegexCheck(text: firstName.text!)){
            firstName.error = "inavlid name"
        }
        else{
            firstName.error = nil
        }
    }
    
    
    @IBAction func lastNameEnd(_ sender: Any) {
        if(lastName.text == ""){
            lastName.error = "all fields are required"
        }
        else if(!registerViewModel.nameRegexCheck(text: lastName.text!)){
            lastName.error = "inavlid name"
        }
        else{
            lastName.error = nil
        }
    }
    
    
    
    @IBAction func emailEnd(_ sender: Any) {
        if(email.text == ""){
            email.error = "all fields are required"
        }
        else if(!registerViewModel.emailRegexCheck(text: email.text!)){
            email.error = "inavlid email"
        }
        else{
            email.error = nil
        }

    }
    
    
    
    @IBAction func phoneNumberEnd(_ sender: Any) {
        if(phoneNumber.text == ""){
            phoneNumber.error = "all fields are required"
        }
        else if(!registerViewModel.phoneNumRegexCheck(text: phoneNumber.text!)){
            phoneNumber.error = "inavlid phone Number"
        }
        else{
            phoneNumber.error = nil
        }
    }
    
    @IBAction func passwordEnd(_ sender: Any) {
        if(password.text == ""){
            password.error = "all fields are required"
        }
        else{
            password.error = nil
        }
    }
    
    
    @IBAction func cofPasswordEnd(_ sender: Any) {
        if(confPassword.text == ""){
            confPassword.error = "all fields are required"
        }
        else if(password.text! != confPassword.text!){
            confPassword.error = "The Two password is not identical"
        }
        else{
            confPassword.error = nil
        }
    }
    
    
    @IBAction func countryEditingChange(_ sender: Any) {
        if(country.text == ""){
            country.error = "all fields are required"
        }
        else if(!registerViewModel.nameRegexCheck(text: country.text!)){
            country.error = "invalid country name"
        }
        else{
            country.error = nil
        }
    }

    
    
    @IBAction func cityEndChange(_ sender: Any) {
        if(city.text == ""){
            city.error = "all fields are required"
        }
        else if(!registerViewModel.nameRegexCheck(text: city.text!)){
            city.error = "invalid city name"
        }
        else{
            city.error = nil
        }

    }
    
    
    @IBAction func addressChanage(_ sender: Any) {
        if(address.text == ""){
            address.error = "all fields are required"
        }  else{
            address.error = nil
        }
    }
    
    
    
    
    @IBOutlet private weak var city: TKFormTextField!
    @IBOutlet private weak var country: TKFormTextField!
    @IBOutlet private weak var firstName: TKFormTextField!
    @IBOutlet private weak var lastName: TKFormTextField!
    @IBOutlet private weak var email: TKFormTextField!
    @IBOutlet private weak var phoneNumber: TKFormTextField!
    @IBOutlet private weak var confPassword: TKFormTextField!
    @IBOutlet private weak var password: TKFormTextField!
    @IBOutlet weak var address: TKFormTextField!
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

//        registerViewModel.errorObservable.subscribe(onNext: { (message,boolResult) in
//            if(boolResult){
//                Support.notifyUser(title: "Error", body: message, context: self)
//            }
//            }).disposed(by: disposeBag)
        
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
        if(firstName.text == ""){
            firstName.error = "all fields are required"
            
        }
       if(lastName.text == ""){
            lastName.error = "all fields are required"
            
        }
        if(city.text == ""){
            city.error = "all fields are required"
            
        }
        if(country.text == ""){
            country.error = "all fields are required"
           
        }
        if(password.text == ""){
            password.error = "all fields are required"
           
        }
        if(confPassword.text == ""){
            confPassword.error = "all fields are required"
           
        }
        if(email.text == ""){
            email.error = "all fields are required"
           
        }
        if(phoneNumber.text == ""){
            phoneNumber.error = "all fields are required"
           
        }
        if(address.text == ""){
            address.error = "all fields are required"
           
        }
        registerViewModel.validateRegisterdData(firstName: firstName.text!, lastName: lastName.text!, email: email.text!, phoneNumber: phoneNumber.text!, password: password.text!, confirmPassword: confPassword.text!, country: country.text!, city: city.text!,address: address.text!)
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
