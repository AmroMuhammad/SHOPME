//
//  ProductDetailsViewController.swift
//  Shopify e-commerce
//
//  Created by Ahmd Amr on 24/05/2021.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit

class ProductDetailsViewController: UIViewController {

    @IBOutlet weak var collectionViewSlider: UICollectionView!
    
    @IBOutlet weak var pageController: UIPageControl!
    
    @IBOutlet weak var favoriteBtnOutlet: UIButton!
    @IBOutlet weak var cartBtnOutlet: UIButton!
    
    @IBOutlet weak var sizeContainerView: UIView!
    @IBOutlet weak var priceContainerView: UIView!
    @IBOutlet weak var heightPriceContainerView: NSLayoutConstraint!
    
    
    @IBOutlet weak var colorCollectionView: UICollectionView!
    
    let arr = ["1", "2", "3", "1", "2", "3", "1", "2", "3", "1", "2", "3"]
    
    @IBOutlet weak var lbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let nibCell = UINib(nibName: String(describing: ColorCollectionViewCell.self), bundle: nil)
        colorCollectionView.register(nibCell, forCellWithReuseIdentifier: "ColorCollectionViewCell")
//        
        
        collectionViewSlider.collectionViewLayout.invalidateLayout()
        pageController.numberOfPages = arr.count
        // Do any additional setup after loading the view.
        
//        lbl.text = "dsnadjnasdsnadjnasdsnadjnasdsnadjnasdsnadjnasdsnadjnasdsnadjnasdsnadjnasdsnadjnasdsnadjnasdsnadjnasdsnadjnasdsnadjnasdsnadjnasdsnadjnasdsnadjnasdsnadjnasdsnadjnasdsnadjnasdsnadjnasdsnadjnasdsnadjnasdsnadjnasdsnadjnasdsnadjnasdsnadjnasdsnadjnasdsnadjnasdsnadjnas"
    }
    
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        print("\n\n\nHEEEEY\n")
        if sender.tag == 0 {
            print("Fav Pressed tag = 0")
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        
            //            sender.image?.withTintColor(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
            sender.tag = 1
            
        } else {
            print("Fav Pressed tag = 1")
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
            
            sender.tag = 0
        }
        print("\n\n\nBYEEEE\n")
    }
    
    @IBAction func cartBtnPressed(_ sender: UIButton) {
        if sender.tag == 0 {
            print("Fav Pressed tag = 0")
            sender.setImage(UIImage(systemName: "cart.fill"), for: .normal)
        
            sender.tintColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            sender.tag = 1
            
        } else {
            print("Fav Pressed tag = 1")
            sender.setImage(UIImage(systemName: "cart.badge.plus"), for: .normal)
            sender.tintColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
            sender.tag = 0
        }
    }
    
}

extension ProductDetailsViewController {
    func hideView() {
        let newConstraint = heightPriceContainerView.constraintWithMultiplier(0.0001)
        view.removeConstraint(heightPriceContainerView)
        view.addConstraint(newConstraint)
        view.layoutIfNeeded()
        heightPriceContainerView = newConstraint
    }
}


extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}

//extension UIView {
//
//    func visiblity(gone: Bool, dimension: CGFloat = 0.0, attribute: NSLayoutConstraint.Attribute = .height) -> Void {
//        if let constraint = (self.constraints.filter{$0.firstAttribute == attribute}.first) {
//            constraint.constant = gone ? 0.0 : dimension
//            self.layoutIfNeeded()
//            self.isHidden = gone
//        }
//    }
//}

//extension UIView {
//
//    enum Visibility: String {
//        case visible = "visible"
//        case invisible = "invisible"
//        case gone = "gone"
//    }
//
//    var visibility: Visibility {
//        get {
//            let constraint = (self.constraints.filter{$0.firstAttribute == .height && $0.constant == 0}.first)
//            if let constraint = constraint, constraint.isActive {
//                return .gone
//            } else {
//                return self.isHidden ? .invisible : .visible
//            }
//        }
//        set {
//            if self.visibility != newValue {
//                self.setVisibility(newValue)
//            }
//        }
//    }
//
//    @IBInspectable
//    var visibilityState: String {
//        get {
//            return self.visibility.rawValue
//        }
//        set {
//            let _visibility = Visibility(rawValue: newValue)!
//            self.visibility = _visibility
//        }
//    }
//
//    private func setVisibility(_ visibility: Visibility) {
//        let constraints = self.constraints.filter({$0.firstAttribute == .height && $0.constant == 0 && $0.secondItem == nil && ($0.firstItem as? UIView) == self})
//        let constraint = (constraints.first)
//
//        switch visibility {
//        case .visible:
//            constraint?.isActive = false
//            self.isHidden = false
//            break
//        case .invisible:
//            constraint?.isActive = false
//            self.isHidden = true
//            break
//        case .gone:
//            self.isHidden = true
//            if let constraint = constraint {
//                constraint.isActive = true
//                print("if let")
//            } else {
//                print("else let")
//                let constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: , attribute: .height, multiplier: 1, constant: 0)
//                // constraint.priority = UILayoutPriority(rawValue: 999)
//                self.addConstraint(constraint)
//                constraint.isActive = true
//            }
//            self.setNeedsLayout()
//            self.setNeedsUpdateConstraints()
//        }
//    }
//}


extension ProductDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()
        
        if collectionView == collectionViewSlider {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
            
            if let vc = cell.viewWithTag(1) as? UIImageView {
                vc.image = UIImage(named: arr[indexPath.row])
            }
            //        if let ab = cell.viewWithTag(1) as? UIPageControl {
            //            ab.currentPage = indexPath.row
            //        }
            pageController.currentPage = indexPath.row
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCollectionViewCell", for: indexPath) as! ColorCollectionViewCell
//            if let vc = cell.viewWithTag(1) as? UIView {
//                vc.image = UIImage(named: arr[indexPath.row])
//            }
//            colorCircleView.layer.cornerRadius = colorCircleView.frame.size.width/2
//            colorCircleView.clipsToBounds = true
//
//            colorCircleView.layer.borderColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
//            colorCircleView.layer.borderWidth = 5.0

        }
        
        
        
        return cell
    }
    
    
}


extension ProductDetailsViewController: UICollectionViewDelegateFlowLayout {
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let layout = collectionViewSlider.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemWidth = view.bounds.width / 3.0
            let itemHeight = layout.itemSize.height
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            layout.invalidateLayout()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = collectionView.bounds.size
//        colorCircleView.layer.cornerRadius = colorCircleView.frame.size.width/2
//        colorCircleView.clipsToBounds = true
//
//        colorCircleView.layer.borderColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
//        colorCircleView.layer.borderWidth = 5.0
        return CGSize(width: size.width, height: (size.width - 30) / 3)
//        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
        
    }
}
