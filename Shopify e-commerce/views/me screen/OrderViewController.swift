//
//  OrderViewController.swift
//  Shopify e-commerce
//
//  Created by Amr Muhammad on 6/16/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController, UITableViewDelegate,UITableViewDataSource{
    
    var orderID:Int!
    @IBOutlet weak var shippedToLabel: UILabel!
    @IBOutlet weak var orderIDLabel: UILabel!
    private var localManager:LocalManagerHelper!
    private var userData:UserData!
    private var ordersData:[Order]!
    @IBOutlet weak var orderTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localManager = LocalManagerHelper.localSharedInstance
        userData = UserData.sharedInstance
        orderIDLabel.text = "Order Id: \(orderID!)"
        shippedToLabel.text = "Shipped to: " + userData.getUserFromUserDefaults().firstName! + " " + userData.getUserFromUserDefaults().lastName!
        localManager.getAllOrdersByOrederId(orderId: orderID, completion: {[weak self] (orders) in
            self?.ordersData = orders ?? []
            self?.orderTableView.reloadData()
        })
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordersData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SingleOrderTableViewCell", for: indexPath) as! SingleOrderTableViewCell
        cell.itemImage.sd_setImage(with: URL(string: ordersData[indexPath.row].productImage), placeholderImage: UIImage(named: "placeholder"))
        cell.titleLabel.text = ordersData[indexPath.row].title
        cell.priceLabel.text = "Price: " + ordersData[indexPath.row].productPrice + " " + userData.getCurrency()
        cell.quantityLabel.text = "Quantity: " + ordersData[indexPath.row].quantity
        return cell
    }

}
