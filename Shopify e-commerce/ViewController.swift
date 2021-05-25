//
//  ViewController.swift
//  Shopify e-commerce
//
//  Created by Amr Muhammad on 5/19/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        // Do any additional setup after loading the view.
        present( UIStoryboard(name: "meScreen", bundle: nil).instantiateViewController(withIdentifier: "MeViewController") as UIViewController, animated: true, completion: nil)
    }
}

