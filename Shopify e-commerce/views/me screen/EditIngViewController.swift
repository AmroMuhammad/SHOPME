//
//  EditIngViewController.swift
//  Shopify e-commerce
//
//  Created by Ayman Omara on 08/06/2021.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EditIngViewController: UIViewController {
    
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var secondName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var countrry: UITextField!
    @IBOutlet weak var city: UITextField!
    private var disposeBag:DisposeBag!
    private var editViewModel:EditInfoViewModel!
    private var activityView:UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        disposeBag = DisposeBag()
        editViewModel = EditInfoViewModel()
        
        activityView = UIActivityIndicatorView(style: .large)
        
        editViewModel.errorObservable.subscribe(onNext: { (message,boolResult) in
        if(boolResult){
            Support.notifyUser(title: "Error", body: message, context: self)
        }
        }).disposed(by: disposeBag)
        
        editViewModel.loadingObservable.subscribe(onNext: {[weak self] (result) in
        switch result{
        case true:
            self?.showLoading()
        case false:
            self?.hideLoading()
        }
        }).disposed(by: disposeBag)
        
        editViewModel.dataObservable.subscribe(onNext: {[weak self] (customer) in
            self?.setData(customer: customer)
            },onCompleted: {
                self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        editViewModel.fetchData()
    }
    

    @IBAction func submit(_ sender: UIButton) {
        editViewModel.validateData(firstName: firstName.text!, lastName: secondName.text!, email: email.text!, phoneNumber: phoneNumber.text!, country: countrry.text!, city: city.text!)
        
    }
    
    func setData(customer:Customer){
        firstName.text = customer.firstName
        secondName.text = customer.lastName
        email.text = customer.email
        phoneNumber.text = String(describing: customer.phone?.dropFirst(2) ?? "")
        if(!customer.addresses!.isEmpty){
            countrry.text = customer.addresses?[0]?.country ?? ""
            city.text = customer.addresses?[0]?.city ?? ""
        }else{
            countrry.text = ""
            city.text = ""
        }
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
