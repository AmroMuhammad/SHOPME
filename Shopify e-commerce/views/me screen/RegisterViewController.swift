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
        
        textFieldsEvents()
    }
    
    @IBAction func submit(_ sender: Any) {
//        registerViewModel.validateRegisterdData(firstName: firstName.text!, lastName: lastName.text!, email: email.text!, phoneNumber: phoneNumber.text!, password: password.text!, confirmPassword: confPassword.text!, country: country.text!, city: city.text!)
        
        if checkIfError() {
            registerViewModel.registerCustomer(customer: Customer(id: nil, email: email.text, firstName: firstName.text, lastName: lastName.text, phone: "+2"+phoneNumber.text!, tags: password.text, addresses: [Address(id: nil, customerID: nil, city: city.text, country: country.text, address1: address.text)]))
        } else {
            let alertController = UIAlertController(title: "", message: "Sorry, All fileds are required and valid!", preferredStyle: UIAlertController.Style.alert)
              alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                    print("Handle Cancel Logic here")
              }))
            self.present(alertController, animated: true, completion: nil)
        }

//        registerViewModel.validateRegisterdData(firstName: firstName.text!, lastName: lastName.text!, email: email.text!, phoneNumber: phoneNumber.text!, password: password.text!, confirmPassword: confPassword.text!, country: country.text!, city: city.text!,address: address.text!,pn: phoneNumber, context: self,fname: firstName,lname: lastName,em: email,count: country,cit: city,con:confPassword,p: password, addressTxtField: address)
        
    }
    
    func showLoading() {
        activityView!.center = self.view.center
        self.view.addSubview(activityView!)
        activityView!.startAnimating()
    }
    
    func hideLoading() {
        activityView!.stopAnimating()
    }
    
    func textFieldsEvents() {
        city.addTarget(self, action: #selector(updateError), for: .editingDidEnd)
        country.addTarget(self, action: #selector(updateError), for: .editingDidEnd)
        firstName.addTarget(self, action: #selector(updateError), for: .editingDidEnd)
        lastName.addTarget(self, action: #selector(updateError), for: .editingDidEnd)
        email.addTarget(self, action: #selector(updateError), for: .editingDidEnd)
        phoneNumber.addTarget(self, action: #selector(updateError), for: .editingDidEnd)
        confPassword.addTarget(self, action: #selector(updateError), for: .editingDidEnd)
        password.addTarget(self, action: #selector(updateError), for: .editingDidEnd)
        address.addTarget(self, action: #selector(updateError), for: .editingDidEnd)
    }
        
    func checkIfError() -> Bool {
        if firstName.error != nil || (firstName.text?.isEmpty)! {
            print("11111111")
            return false
        }
        if lastName.error != nil || ((lastName.text?.isEmpty)!) {
            return false
        }
        if email.error != nil || ((email.text?.isEmpty)!) {
            return false
        }
        if phoneNumber.error != nil || ((phoneNumber.text?.isEmpty)!) {
            return false
        }
        if password.error != nil || ((password.text?.isEmpty)!){
            return false
        }
        if confPassword.error != nil || ((confPassword.text?.isEmpty)!) {
            return false
        }
        if country.error != nil || ((country.text?.isEmpty)!) {
            print("qqqqqqqqq")
            return false
        }
        if city.error != nil || (city.text!.isEmpty) {
            print("gdfgfgxfg")
            return false
        }
        if address.error != nil || ((address.text?.isEmpty)!) {
            return false
        }
        return true
    }
    
    @objc func updateError(textField: TKFormTextField) {
        if(textField.text == ""){
            textField.error = "This field is required"
        } else {
            switch textField.tag {
            case 1:
                if !nameRegexCheck(text: textField.text!) {
                    textField.error = "Enter valid name"
                } else {
                    textField.error = nil
                }
            case 2:
                if !emailRegexCheck(text: textField.text!) {
                    textField.error = "Enter valid email"
                } else {
                    textField.error = nil
                }
            case 3:
                if !phoneNumRegexCheck(text: textField.text!) {
                    textField.error = "Enter valid number"
                } else {
                    textField.error = nil
                }
            case 4:
                if !passCheck(text: textField.text!) {
                    textField.error = "Enter valid password"
                } else {
                    textField.error = nil
                }
            case 5:
                if textField.text != password.text {
                    textField.error = "Passwords does NOT match"
                } else {
                    textField.error = nil
                }
            case 6:
//                if nameRegexCheck(text: textField.text!) {
//                    textField.error = "Enter valid name"
//                }
//                else {
                    textField.error = nil
//                }
                
            default:
                print("defaulttttttttttttt")
            }
        }
    }
    
    func nameRegexCheck(text:String)-> Bool{
        let range = NSRange(location: 0, length: text.utf16.count)
        let regex = try! NSRegularExpression(pattern: "[0-9]+")
        if(regex.firstMatch(in: text, options: [], range: range) != nil){
            return false
        }else{
            return true
        }
    }
    func phoneNumRegexCheck(text:String)->Bool{
        if(text.count != 11){
            return false
        }
        let range = NSRange(location: 0, length: text.utf16.count)
        let regex = try! NSRegularExpression(pattern: "[0-9]{11}$")
        if(regex.firstMatch(in: text, options: [], range: range) != nil){
            return true
        }else{
            return false
        }
    }
    
    func emailRegexCheck(text:String) -> Bool{
        let range = NSRange(location: 0, length: text.utf16.count)
        let regex = try! NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}")
        if(regex.firstMatch(in: text, options: [], range: range) != nil){
            return true
        }else{
            return false
        }
    }
    func passCheck(text:String) -> Bool{
        if text.count < 5 {
            return false
        }
        return true
    }
}
