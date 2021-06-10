//  RegisterViewController.swift
//  Shopify e-commerce
//  Created by Ayman Omara on 30/05/2021.
//  Copyright © 2021 ITI41. All rights reserved.
import UIKit
import RxCocoa
import RxSwift

class RegisterViewController: UIViewController {
    @IBOutlet private weak var city: UITextField!
    @IBOutlet private weak var country: UITextField!
    @IBOutlet private weak var firstName: UITextField!
    @IBOutlet private weak var lastName: UITextField!
    @IBOutlet private weak var email: UITextField!
    @IBOutlet private weak var phoneNumber: UITextField!
    @IBOutlet private weak var confPassword: UITextField!
    @IBOutlet private weak var password: UITextField!
    private var activityView:UIActivityIndicatorView!

    
    private var registerViewModel:RegisterViewModel!
    private var disposeBag:DisposeBag!
    //var userData = UserData.getInstance().userStatus().0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disposeBag = DisposeBag()
        activityView = UIActivityIndicatorView(style: .large)
        
        self.navigationController?.title = "Regestration"
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
            self.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
    }
    
    @IBAction func submit(_ sender: Any) {
        registerViewModel.validateRegisterdData(firstName: firstName.text!, lastName: lastName.text!, email: email.text!, phoneNumber: phoneNumber.text!, password: password.text!, confirmPassword: confPassword.text!, country: country.text!, city: city.text!)
    
//        if(userData != ""){
//            self.navigationController?.popViewController(animated: true)
//        }
    
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
