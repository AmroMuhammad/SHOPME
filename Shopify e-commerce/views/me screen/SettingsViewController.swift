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
    
    @IBAction func wantToLogIn(_ sender: UIButton) {
        signInOutlet.alpha = 1
        
    }
    @IBOutlet weak var signInOutlet: UIView!
    var isLoged = false;
    var isWhishList = true;
    var userName = "Ayman";
    var whishListArray = ["whishListArray","whishListArray","whishListArray","whishListArray"]
    var bagArray = ["bag1","bag1","bag1","bag1","bag1",]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "Settings"
        let api = ShopifyAPI.shared
        api.getCustomers { (result) in
            switch(result){
            case .success(let response):
                let customers = response
                print("in success")
                print(customers?.customers)
                
            case .failure(_):
                print("error")
            }
            
        
            
        }
        
        tableview.delegate = self
        tableview.dataSource = self
        self.changeTableDataSource()
        signInOutlet.alpha = 0
        
        
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
    
    
    //MARK:- Check if user is logdin or not and show message
    /* func welcome()->Void{
     if isLoged {
     let alert = UIAlertController(title: "Welcome", message: "Welcome Back\(userName)", preferredStyle: UIAlertController.Style.alert)
     alert.addAction(UIAlertAction(title: "Welcome", style: UIAlertAction.Style.default, handler: nil))
     self.present(alert, animated: true, completion: nil)
     }
     else{
     let alert = UIAlertController(title: "Login", message: "Log IN", preferredStyle: UIAlertController.Style.alert)
     alert.addAction(UIAlertAction(title: "Log In", style: UIAlertAction.Style.default, handler: {action in
     print("My actoin");
     let loginVC = self.storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
     self.present(loginVC, animated: true, completion: nil)
     
     // self.navigationController?.pushViewController(loginVC, animated: true);
     
     }))
     alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
     self.present(alert, animated: true, completion: nil)
     
     }s
     
     
     }*/
    //    func table()->Void{
    //        //        tableview.rx.
    //    }
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
