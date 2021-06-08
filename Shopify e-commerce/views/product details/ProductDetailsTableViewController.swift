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
    
    var selectedSizeIndex: IndexPath = IndexPath(item: 0, section: 0)
    var selectedColorIndex: Int = 0
    
    var selectedSize: String?
    var selectedColor: UIColor?
    
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var colorsCollectionView: UICollectionView!
    @IBOutlet weak var sizeCollectionView: UICollectionView!

    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var ratingViewContainer: CosmosView!
    @IBOutlet weak var cityNameLabel: UILabel!

    
    private var imagesSubject = PublishSubject<[ProductDetailsImage]>()


    @IBOutlet weak var favoriteButtonOutlet: UIButton!
    @IBOutlet weak var addToCartButtonOutlet: UIButton! // change text clr to green if added??
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Bean Bag"
        
        productDetailsViewModel = ProductDetailsViewModel()
        disposeBag = DisposeBag()
        
        
        sliderCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        colorsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        sizeCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        
        let imageNibCell = UINib(nibName: String(describing: ImageCollectionViewCell.self), bundle: nil)
        sliderCollectionView.register(imageNibCell, forCellWithReuseIdentifier: Constants.imageCell)
        let colorNibCell = UINib(nibName: String(describing: ColorViewCollectionViewCell.self), bundle: nil)
        colorsCollectionView.register(colorNibCell, forCellWithReuseIdentifier: Constants.colorCell)
        let sizeNibCell = UINib(nibName: String(describing: SizeCollectionViewCell.self), bundle: nil)
        sizeCollectionView.register(sizeNibCell, forCellWithReuseIdentifier: Constants.sizeCell)
        
        //----------------------------------------------------------------------------------------------------
        productDetailsViewModel.sizesObservable.bind(to: sizeCollectionView.rx.items(cellIdentifier: Constants.sizeCell)){row, item, cell in
            let sizeCell = cell as! SizeCollectionViewCell
            sizeCell.productSize = item
        }.disposed(by: disposeBag)
        
        productDetailsViewModel.colorsObservable.bind(to: colorsCollectionView.rx.items(cellIdentifier: Constants.colorCell)){row, item, cell in
            let clrCell = cell as! ColorViewCollectionViewCell
            clrCell.productColor = item
        }.disposed(by: disposeBag)
        
        productDetailsViewModel.imagesObservable.bind { (images) in     // number of colors
            self.imagesSubject.onNext(images)
            self.pageController.numberOfPages = images.count
        }.disposed(by: disposeBag)
        imagesSubject.bind(to: sliderCollectionView.rx.items(cellIdentifier: Constants.imageCell)){row, item, cell in
            let imgCell = cell as! ImageCollectionViewCell
            imgCell.productImgObj = item
        }.disposed(by: disposeBag)
        
        productDetailsViewModel.productPriceObservable.bind { (price) in
            self.priceLabel.text = price
        }.disposed(by: disposeBag)
        
        productDetailsViewModel.productTitleObservable.bind { (name) in
            self.productNameLabel.text = name
        }.disposed(by: disposeBag)
        
        
        //----------------------selected item----------------------
        
//        colorsCollectionView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
//            let cell = self?.colorsCollectionView.cellForItem(at: indexPath) as? ColorViewCollectionViewCell
//            cell?.selectedCell()
//            self?.selectedColor = UIColor(cgColor: cell?.productColor.cgColor ?? UIColor.white.cgColor)
//            print("selected Color => \(String(describing: self?.selectedColor))")
//        }).disposed(by: disposeBag)
        
//        colorsCollectionView.rx.modelSelected(UIColor.self).subscribe(onNext: {[weak self] (color) in
//            print("selected Color => \(color)")
//            self?.selectedColor = color
//        }).disposed(by: disposeBag)
        
       
//        sizeCollectionView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
////            var cell = self?.sizeCollectionView.cellForItem(at: self?.selectedSizeIndex ?? IndexPath(item: 0, section: 0)) as? SizeCollectionViewCell
//            cell?.
//            print("unselect Size => \(String(describing: cell?.productSize))")
//            print("unselect index \(self?.selectedSizeIndex)")
//            cell = self?.sizeCollectionView.cellForItem(at: indexPath) as? SizeCollectionViewCell
//            self?.selectedSizeIndex = indexPath
//            cell?.selectedCell()
//            self?.selectedSize = cell?.productSize
//            print("select index \(indexPath)")
//            print("selected Size => \(String(describing: self?.selectedSize))")
//        }).disposed(by: disposeBag)
        
//        sizeCollectionView.rx.modelSelected(String.self).subscribe(onNext: {[weak self] (size) in
//            print("selected Size => \(size)")
//            self?.selectedSize = size
//        }).disposed(by: disposeBag)
        sizeCollectionView.rx.modelSelected(String.self).subscribe(onNext: {[weak self] (value) in
//            self?.subCat = value
//            self?.categoryViewModel.fetchCatProducts(mainCat: self!.mainCat, subCat: self!.subCat)
            print("VALUE modelSelected => \(value)")
        }).disposed(by: disposeBag)
        
        
        ratingViewInit()
        
        productDetailsViewModel.getProductDetails(id: productId)
        
        currencyLabel.text = "EGP"      // productDetailsViewModel.getCurrency()
        cityNameLabel.text = "Balteem"  // productDetailsViewModel.getDeliverCity()
        
        
        productDetailsViewModel.favoriteProductsObservable.subscribe(onNext: { (favArr) in
            print("VC sunscribe on favvvv arr count => \(favArr.count)")
            for item in favArr {
                print("VC sunscribe on favvvv -- id => \(item.productId)")
            }
        }).disposed(by: disposeBag)
    }
    
//    func getData(){
//        let res = productDetailsViewModel.getFromFavorite()
//
//        pricyyyLabeltest.text = res.0?.variants?[0].price
//        if let resDAt = res.1 {
//            if  resDAt.isEmpty {
//                print("\n\n\nres.1.isEMPTYYYYYYYYYYYYY\n\n")
//            } else {
//                imgyyyTest.image = UIImage(data: resDAt)
//            }
//        } else {
//            print("\n\n\nresDATAA   EMPTYYYYYYYYYYYYY\n\n")
//        }     
//    }
    
    func ratingViewInit(){
        ratingViewContainer.settings.fillMode = .half
        ratingViewContainer.rating = 3.5
        ratingViewContainer.settings.starSize = Double(tableView.frame.width) / 17
        ratingViewContainer.settings.updateOnTouch = false
        ratingViewContainer.text = "(\(507))"
        ratingViewContainer.settings.textMargin = 7.0
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        print("\n\n\nHEEEEY\n")
        if sender.tag == 0 {
            print("Fav Pressed tag = 0")
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        
            productDetailsViewModel.addTofavorite()
            
            sender.tag = 1
            
        } else {
            print("Fav Pressed tag = 1")
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
            
            productDetailsViewModel.removefromFavorite(productId: productId)
            
            sender.tag = 0
        }
        print("\n\n\nBYEEEE\n")
    }
    
    @IBAction func addToCartButtonPressed(_ sender: UIButton) {
        
        print("\n\n\nHEEEEY\n")
        if sender.tag == 0 {
            print("Cart Pressed tag = 0")
            
            productDetailsViewModel.addToCart(selectedSize: selectedSize, selectedColor: selectedColor)
            
            sender.tag = 1
            
        } else {
            print("Cart Pressed tag = 1")
            
            productDetailsViewModel.removefromCart(productId: productId)
            
            sender.tag = 0
        }
        print("\n\n\nBYEEEE\n")
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
