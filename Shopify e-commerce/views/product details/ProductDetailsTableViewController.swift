//
//  ProductDetailsTableViewController.swift
//  Shopify e-commerce
//
//  Created by Ahmd Amr on 31/05/2021.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage
import Cosmos

class ProductDetailsTableViewController: UITableViewController {

    private var productDetailsViewModel: ProductDetailsViewModel!
    private var disposeBag: DisposeBag!
    
    var productId: String!
    var productMainCategory: String?
    
    private var selectedSize: String?
    private var selectedColor: UIColor?
    
    private var imagesSubject = PublishSubject<[ProductDetailsImage]>()
    
    @IBOutlet weak private var sliderCollectionView: UICollectionView!
    @IBOutlet weak private var pageController: UIPageControl!
    @IBOutlet weak private var colorsCollectionView: UICollectionView!
    @IBOutlet weak private var sizeCollectionView: UICollectionView!
    
    @IBOutlet weak private var productNameLabel: UILabel!
    @IBOutlet weak private var priceLabel: UILabel!
    @IBOutlet weak private var currencyLabel: UILabel!
    @IBOutlet weak private var ratingViewContainer: CosmosView!
    @IBOutlet weak private var cityNameLabel: UILabel!
    @IBOutlet weak private var descriptionTextView: UITextView!
    
    @IBOutlet weak private var cartRightNavBar: RightNavBarView!

    @IBOutlet weak private var favoriteButtonOutlet: UIButton!
    @IBOutlet weak private var addToCartButtonOutlet: UIButton! // change text clr to green if added??
    
        override func viewDidLoad() {
        super.viewDidLoad()
        
        productDetailsViewModel = ProductDetailsViewModel()
        disposeBag = DisposeBag()
        
        sliderCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        colorsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        sizeCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
            
        registerNibs()
        binding()
        subscribtion()
        ratingViewInit()
        descriptionTextViewInit()
   
        productDetailsViewModel.getProductDetails(id: productId, mainCategory: productMainCategory)
        productDetailsViewModel.getLocalData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        productDetailsViewModel.getCartQuantity()
    }

    
    @IBAction func navToCart(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "shop", bundle: nil)
        let cartVC = storyBoard.instantiateViewController(withIdentifier: Constants.cartVC) as! CardViewController
        navigationController?.pushViewController(cartVC, animated: true)
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        if sender.tag == 0 {
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            productDetailsViewModel.addTofavorite()
            sender.tag = 1
        } else {
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
            productDetailsViewModel.removefromFavorite(productId: productId)
            sender.tag = 0
        }
    }
    
    @IBAction func addToCartButtonPressed(_ sender: UIButton) {
        if selectedColor == nil {
            showAlert(title: "Missing", msg: "Please, select color!")
            return
        }
        if selectedSize == nil {
            showAlert(title: "Missing", msg: "Please, select size!")
            return
        }
        if sender.tag == 0 {
            productDetailsViewModel.addToCart(selectedSize: selectedSize, selectedColor: selectedColor)
            sender.setTitle("ADDED TO CART", for: .normal)
            sender.tag = 1
            productDetailsViewModel.getCartQuantity()
        } else {
            showAlert(title: "Info", msg: "This product is alraedy added before!")
        }
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                return view.frame.height * 0.5
            } else if indexPath.row == 3 {
                return  view.frame.height * 0.15
            } else {
                return productNameLabel.bounds.height + 25
            }
            
        case 1:
            var val: CGFloat = 0.0
            switch indexPath.row  {
            case 0,2:
                val = 30.0
            case 1,3:
                val = 50.0
            default:
                val = 50.0 //CGFloat.leastNonzeroMagnitude
            }
            return val
        default:
            return 10.0
        }
    }

}


// MARK: - Collectio view Flow Layout
extension ProductDetailsTableViewController: UICollectionViewDelegateFlowLayout {
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageController.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = collectionView.frame.size
        
        switch collectionView.tag {
        case 1:
            return CGSize(width: size.width, height: (size.height))
        case 2:
            return CGSize(width: (size.width - 30) / 8, height: (size.width - 30) / 10)
            
        default:
            return CGSize(width: (size.width - 30) / 4, height: (size.width - 30) / 8)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        switch collectionView.tag {
        case 1:
            return 0.0
        default:
            return 15.0
        }
    }
}

// MARK: - Controller Functions
extension ProductDetailsTableViewController {
    
    private func registerNibs() {
        let imageNibCell = UINib(nibName: String(describing: ImageCollectionViewCell.self), bundle: nil)
        sliderCollectionView.register(imageNibCell, forCellWithReuseIdentifier: Constants.imageCell)
        let colorNibCell = UINib(nibName: String(describing: ColorViewCollectionViewCell.self), bundle: nil)
        colorsCollectionView.register(colorNibCell, forCellWithReuseIdentifier: Constants.colorCell)
        let sizeNibCell = UINib(nibName: String(describing: SizeCollectionViewCell.self), bundle: nil)
        sizeCollectionView.register(sizeNibCell, forCellWithReuseIdentifier: Constants.sizeCell)
    }
    
    private func binding() {
        productDetailsViewModel.sizesObservable.bind(to: sizeCollectionView.rx.items(cellIdentifier: Constants.sizeCell)){row, item, cell in
            let sizeCell = cell as! SizeCollectionViewCell
            sizeCell.productSize = item
        }.disposed(by: disposeBag)
        
        productDetailsViewModel.colorsObservable.bind(to: colorsCollectionView.rx.items(cellIdentifier: Constants.colorCell)){row, item, cell in
            let clrCell = cell as! ColorViewCollectionViewCell
            clrCell.productColor = item
        }.disposed(by: disposeBag)
        
        imagesSubject.bind(to: sliderCollectionView.rx.items(cellIdentifier: Constants.imageCell)){row, item, cell in
            let imgCell = cell as! ImageCollectionViewCell
            imgCell.productImgObj = item
        }.disposed(by: disposeBag)
        
        productDetailsViewModel.productPriceObservable.bind(to: priceLabel.rx.text).disposed(by: disposeBag)
        productDetailsViewModel.productTitleObservable.bind(to: productNameLabel.rx.text).disposed(by: disposeBag)
        productDetailsViewModel.productDescriptionObservable.bind(to: descriptionTextView.rx.text).disposed(by: disposeBag)
        productDetailsViewModel.quantutyObservable.bind(to: cartRightNavBar.rx.quantity).disposed(by: disposeBag)
        productDetailsViewModel.currencyObservable.bind(to: currencyLabel.rx.text).disposed(by: disposeBag)
        productDetailsViewModel.userCityObservable.bind(to: cityNameLabel.rx.text).disposed(by: disposeBag)

    }
    
    private func subscribtion() {
        //                          when user select
        sizeCollectionView.rx.modelSelected(String.self).subscribe(onNext: {[weak self] (value) in
            guard let self = self else {return}
            self.selectedSize = value
        }).disposed(by: disposeBag)
        
        colorsCollectionView.rx.modelSelected(UIColor.self).subscribe(onNext: {[weak self] (value) in
            guard let self = self else {return}
            self.selectedColor = value
        }).disposed(by: disposeBag)
        
        //-------------------------------------------------------------------------------------------
        productDetailsViewModel.productVendorObservable.subscribe(onNext: { [weak self] (vendor) in
            guard let self = self else {return}
            self.title = vendor
        }).disposed(by: disposeBag)
        
        productDetailsViewModel.imagesObservable.subscribe(onNext: { [weak self] (imagesArr) in
            guard let self = self else {return}
            self.imagesSubject.onNext(imagesArr)
            self.pageController.numberOfPages = imagesArr.count
        }).disposed(by: disposeBag)
        
        productDetailsViewModel.checkProductInFavoriteObservable.subscribe(onNext: { [weak self] (resBool) in
            guard let self = self else {return}
            if resBool {
                self.favoriteButtonOutlet.tag = 1
                self.favoriteButtonOutlet.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
        }).disposed(by: disposeBag)
        
        productDetailsViewModel.checkProductInCartObservable.subscribe(onNext: {  [weak self] (resBool) in
            guard let self = self else {return}
            if resBool {
                self.addToCartButtonOutlet.tag = 1
                self.addToCartButtonOutlet.setTitle("ADDED TO CART", for: .normal)
            }
        }).disposed(by: disposeBag)
    }
    
    private func descriptionTextViewInit() {
//        descriptionTextView.translatesAutoresizingMaskIntoConstraints = true
        descriptionTextView.sizeToFit()
    }
    
    private func ratingViewInit(){
        ratingViewContainer.settings.fillMode = .half
        ratingViewContainer.rating = 3.5
        ratingViewContainer.settings.starSize = Double(tableView.frame.width) / 17
        ratingViewContainer.settings.updateOnTouch = false
        ratingViewContainer.text = "(\(507))"
        ratingViewContainer.settings.textMargin = 7.0
    }
    
    func showAlert(title: String, msg: String){
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
        }))
        self.present(alertController, animated: true, completion:nil)
    }
}
