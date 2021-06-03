//
//  HeaderView.swift
//  Shopify e-commerce
//
//  Created by Ahmd Amr on 01/06/2021.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit
import Cosmos

class HeaderView: UIView {


    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var currencyLabel: UILabel!
    
    @IBOutlet weak var ratingView: CosmosView!
    
    @IBOutlet weak var reviewsLabel: UILabel!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit(){
        let viewFromXib = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
}
