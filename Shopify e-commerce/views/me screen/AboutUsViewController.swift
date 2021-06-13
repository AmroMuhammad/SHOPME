//
//  AboutUsViewController.swift
//  Shopify e-commerce
//
//  Created by Ayman Omara on 07/06/2021.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit
import WebKit
class AboutUsViewController: UIViewController{
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.isHidden = true
        }


    @IBAction func linkedInButtonClicked(_ sender: UIButton) {
        var myURL:URL!
        switch sender.tag {
        case 1:
            myURL = URL(string: "https://www.linkedin.com/in/ahmedamr77/")
            print("1")
        case 2:
            myURL = URL(string: "https://www.linkedin.com/in/amr-muhammad/")
        case 3:
            myURL = URL(string: "https://www.linkedin.com/in/ayman-omara/")
        default:
            myURL = URL(string: "https://www.linkedin.com/in/marwa-shanab/")
            
        }
        let myRequest = URLRequest(url: myURL!)
        webView.isHidden = false
        webView.load(myRequest)
    }
    
    @IBAction func githubButtonClicked(_ sender: UIButton) {
        var myURL:URL!
        switch sender.tag {
        case 1:
            myURL = URL(string: "https://github.com/AhmedAmr77")
            print("1")
        case 2:
            myURL = URL(string: "https://github.com/AmroMuhammad")
        case 3:
            myURL = URL(string: "https://github.com/AymanOmara")
        default:
            myURL = URL(string: "https://github.com/MarwaEbrahem")
            
        }
        let myRequest = URLRequest(url: myURL!)
        webView.isHidden = false
        webView.load(myRequest)
    }
    
}
