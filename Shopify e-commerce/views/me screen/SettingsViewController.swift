//
//  SettingsViewController.swift
//  Shopify e-commerce
//
//  Created by Ayman Omara on 25/05/2021.
//  Copyright © 2021 ITI41. All rights reserved.

import UIKit

class SettingsViewController: UIViewController {
    
    var isLoged = false;
    var isWhishList = true;
    var userName = "Ayman";
    var whishListArray = ["whishListArray","whishListArray","whishListArray","whishListArray"]
    var bagArray = ["bag1","bag1","bag1","bag1","bag1",]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "Settings"
        tableview.delegate = self
        tableview.dataSource = self
        
    }
    
    @IBAction func segmentControl(_ sender: Any) {
        switch (sender as AnyObject).selectedSegmentIndex
        {
        case 0:
            isWhishList = true;
            tableview.reloadData()
            print("case 0")
            self.welcome()
            
        case 1:
            isWhishList = false;
            tableview.reloadData()
            print("case 1")
        default:
            break
        }
    }
    @IBOutlet weak var tableview: UITableView!
    
    //MARK:- Check if user is logdin or not and show message
    func welcome()->Void{
        if isLoged {
            let alert = UIAlertController(title: "Welcome", message: "Welcome Back\(userName)", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Welcome", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "Login", message: "Log IN", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Log In", style: UIAlertAction.Style.default, handler: {action in
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
    }
}
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
        tableview.reloadData()
    }
}
