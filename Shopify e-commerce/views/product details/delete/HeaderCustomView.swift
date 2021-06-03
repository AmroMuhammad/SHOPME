//
//  HeaderCustomView.swift
//  Shopify e-commerce
//
//  Created by Ahmd Amr on 01/06/2021.
//  Copyright © 2021 ITI41. All rights reserved.
//

// NibLoadingView.swift
import UIKit

/* Usage:
- Subclass your UIView from NibLoadView to automatically load an Xib with the same name as your class
- Set the class name to File's Owner in the Xib file
*/

@IBDesignable
class NibLoadingView: UIView {

    @IBOutlet weak var view: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }

    private func nibSetup() {
        backgroundColor = .black

        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true

        addSubview(view)
    }

    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
//        let nib = UINib(nibName: String(type(of: self)), bundle: bundle)
        let nib = UINib(nibName: String(describing: self), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView

        return nibView
    }

}
