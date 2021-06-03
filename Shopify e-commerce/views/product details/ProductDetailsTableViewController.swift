//
//  ProductDetailsTableViewController.swift
//  Shopify e-commerce
//
//  Created by Ahmd Amr on 31/05/2021.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit

class ProductDetailsTableViewController: UITableViewController {

    var proDetObs: Product? {
        didSet{
            print("\n\nprpObs START\n\n")
            print((oldValue?.id ?? 70707) as Int)
            print("VC => id => \(proDetObs?.id ?? 707)")
            print("\n\nprpObs END\n\n")
        }
    }
    
    var viewModel: ProductDetailsViewModel!
    
    var productId: String!
    
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    
    @IBOutlet weak var pageController: UIPageControl!
    
     let arr = ["1", "2", "3", "1", "2", "3", "1", "2", "3", "1", "2", "3"]
    
    
    @IBOutlet weak var productNameLabel: UILabel!
    
    
    @IBOutlet weak var colorsCollectionView: UICollectionView!
    
    let arrClr = [UIColor.red, UIColor.green, UIColor.black, UIColor.blue, UIColor.purple]
    let arrClrNames = ["red", "green", "black", "blue", "purple"]
      
    
    @IBOutlet weak var sizeCollectionView: UICollectionView!
    
    let arrSizes = ["S", "M", "L", "XL", "XXL"]
    
    @IBOutlet weak var cityNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        productId = "6687367364806"
        viewModel = ProductDetailsViewModel(cont: self)
        viewModel.getProductDetails(id: productId)
        
        
//        navigationController?.title = "Bean Bag"
        
        
        sliderCollectionView.delegate = self
        sliderCollectionView.dataSource = self
        
        pageController.numberOfPages = arr.count
        
        
        
        //                              Product Label
        productNameLabel.text = "Bin Baggy - product Label"
        productNameLabel.sizeToFit()
        
        
        colorsCollectionView.delegate = self
        colorsCollectionView.dataSource = self
        
        let nibCell = UINib(nibName: String(describing: ColorViewCollectionViewCell.self), bundle: nil)
        colorsCollectionView.register(nibCell, forCellWithReuseIdentifier: "ColorViewCollectionViewCell")
        
        sizeCollectionView.delegate = self
        sizeCollectionView.dataSource = self
        
        cityNameLabel.text = "Sina"
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20)) // width: 20, height: 20  are useless
        
        if (section == 1) {
            headerView.backgroundColor = UIColor.clear
            let headerVi = HeaderView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 75))
            headerVi.priceLabel.text = "777.77"
            headerVi.priceLabel.sizeToFit()
            headerVi.currencyLabel.text = "EG"
            headerVi.currencyLabel.sizeToFit()
            headerVi.ratingView.settings.fillMode = .half
            headerVi.ratingView.rating = 3.5
            headerVi.ratingView.settings.starSize = Double(tableView.frame.width) / 12.5
            headerVi.ratingView.settings.updateOnTouch = false
            headerVi.reviewsLabel.text = "\(5) reviews"
            headerVi.reviewsLabel.sizeToFit()
            headerView.addSubview(headerVi)
            
        } else {
            headerView.backgroundColor = UIColor.green
        }
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            switch section {
            case 0:
                return CGFloat.leastNonzeroMagnitude
    //        case 1:
    //            return 25.0
            default:
                return 65.0
            }
        }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        switch section {
//        case 0:
//            return nil
//        case 1:
//            return "Bean Bag"
//        default:
//            return "Shipping to cairo"
//        }
//    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                return view.frame.height * 0.2
            } else {
                return productNameLabel.bounds.height + 25
            }
            
        case 1:
            var val: CGFloat = 0.0
            switch indexPath.row  {
            case 0,2:
                val = 50.0
            case 1:
                val = 70.0
            case 3:
                val = 50.0
            default:
                val = 70.0 //CGFloat.leastNonzeroMagnitude
            }
            return val
        default:
            return 10.0
        }
    }

}


extension ProductDetailsTableViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var size = 1 // change it ZERO. later
        switch collectionView.tag {
        case 1:
            size = arr.count
        case 2:
            size = arrClr.count
        case 3:
            size = arrSizes.count
        default:
            size = 3 //// change it ZERO. later
        }

        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell: UICollectionViewCell!
        
        switch collectionView.tag {
        case 1:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
            
            if let vc = cell.viewWithTag(1) as? UIImageView {
                vc.image = UIImage(named: arr[indexPath.row])
            }
//            if let ab = cell.viewWithTag(2) as? UIPageControl {
//                ab.currentPage = indexPath.row
//            }
//            print(indexPath.row)
            pageController.currentPage = indexPath.row
        case 2:
            let clrCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorViewCollectionViewCell", for: indexPath) as! ColorViewCollectionViewCell
//            clrCell.lbl.text = arrClrNames[indexPath.row]
            clrCell.lbl.backgroundColor = arrClr[indexPath.row]

            /*   when select color -- in didSelectRowAt
            clrCell.lbl.layer.borderWidth = 3.0
            clrCell.lbl.layer.borderColor = UIColor.blue.cgColor
            */
            
            cell = clrCell
        case 3:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sizeCell", for: indexPath)
            
            if let vc = cell.viewWithTag(1) as? UILabel {
                vc.text = arrSizes[indexPath.row]
            }
        default:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath) as! ColorCollectionViewCell  //// change it ZERO. later
        }
        
        return cell
    }
    
}



extension ProductDetailsTableViewController: UICollectionViewDelegateFlowLayout {
    
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//
//        switch collectionView.tag {
//        case 1:
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        default:
//            return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = collectionView.bounds.size
//        colorCircleView.layer.cornerRadius = colorCircleView.frame.size.width/2
//        colorCircleView.clipsToBounds = true
//
//        colorCircleView.layer.borderColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
//        colorCircleView.layer.borderWidth = 5.0
        
        switch collectionView.tag {
        case 1:
            return CGSize(width: size.width, height: (size.width - 30) / 3)
            
        default:
            return CGSize(width: (size.width - 30) / 4, height: (size.width - 30) / 3)
        }
//        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        switch collectionView.tag {
        case 1:
            return 0.0
        default:
            return 15.0
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0.0
//
//    }
    
}
