//
//  ColorSizeViewController.swift
//  Shopify e-commerce
//
//  Created by Ahmd Amr on 15/06/2021.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ColorSizeViewController: UIViewController, UICollectionViewDelegate {


    weak var senderVC: UIViewController!
    var productId: Int!
    var mainCategory: String?
    
    private var productDetailsViewModel: ProductDetailsViewModel!
    private var disposeBag: DisposeBag!
    private var activityView: UIActivityIndicatorView!
    
    private var selectedSize: String?
    private var selectedColor: UIColor?
    
    
    @IBOutlet weak var containerView: UIView!                           //remove this
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var colorsCollectionView: UICollectionView!
    
    @IBOutlet weak var sizesCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        productDetailsViewModel = ProductDetailsViewModel()
        disposeBag = DisposeBag()
        activityView = UIActivityIndicatorView(style: .large)
        
        containerView.layer.cornerRadius = 13
        
        imagesCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: Constants.imageCell)
        colorsCollectionView.register(ColorViewCollectionViewCell.self, forCellWithReuseIdentifier: Constants.colorCell)
        sizesCollectionView.register(SizeCollectionViewCell.self, forCellWithReuseIdentifier: Constants.sizeCell)
        
        imagesCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        colorsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        sizesCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        
//        setupGestureRecognizers()
        registerNibs()
        binding()
        subscribtion()
        
        productDetailsViewModel.getProductDetails(id: String(productId), mainCategory: mainCategory)
        
    }
    
//    func setupGestureRecognizers() {
//      let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognizer:)))
//      view.addGestureRecognizer(tapRecognizer)
//    }
//    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
//        dismiss(animated: true)
//    }

    
    
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    
    @IBAction func productDetailsPressed(_ sender: UIButton) {
        print("\n\n\nproductDetailsPressed\n\n")
        dismiss(animated: true) {
            print("\n\n\nCompletion\n\n")
            let storyBoard : UIStoryboard = UIStoryboard(name: "productDetails", bundle:nil)
            let productDetailsVC = storyBoard.instantiateViewController(identifier: Constants.productDetailsVC) as! ProductDetailsTableViewController
            productDetailsVC.productId = String(self.productId)
            productDetailsVC.productMainCategory = self.mainCategory
            self.senderVC.navigationController?.pushViewController(productDetailsVC, animated: true)
        }
    }
    
    
    @IBAction func addPressed(_ sender: UIButton) {
        productDetailsViewModel.addToCart(selectedSize:selectedSize, selectedColor: selectedColor)
        dismiss(animated: true)
    }
    
    

}

extension ColorSizeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = collectionView.frame.size
        
        switch collectionView.tag {
        case 1:
            return CGSize(width: size.width, height: (size.height))
        case 2:
            return CGSize(width: (size.width - 30) / 8, height: (size.height - 30) )
            
        default:
            return CGSize(width: (size.width - 30) / 4, height: (size.height - 30) )
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

extension ColorSizeViewController {
    private func registerNibs() {
        let imageNibCell = UINib(nibName: String(describing: ImageCollectionViewCell.self), bundle: nil)
        imagesCollectionView.register(imageNibCell, forCellWithReuseIdentifier: Constants.imageCell)
        let colorNibCell = UINib(nibName: String(describing: ColorViewCollectionViewCell.self), bundle: nil)
        colorsCollectionView.register(colorNibCell, forCellWithReuseIdentifier: Constants.colorCell)
        let sizeNibCell = UINib(nibName: String(describing: SizeCollectionViewCell.self), bundle: nil)
        sizesCollectionView.register(sizeNibCell, forCellWithReuseIdentifier: Constants.sizeCell)
    }
    
    private func binding() {
        productDetailsViewModel.sizesObservable.bind(to: sizesCollectionView.rx.items(cellIdentifier: Constants.sizeCell)){row, item, cell in
            let sizeCell = cell as! SizeCollectionViewCell
            sizeCell.productSize = item
        }.disposed(by: disposeBag)
        
        productDetailsViewModel.colorsObservable.bind(to: colorsCollectionView.rx.items(cellIdentifier: Constants.colorCell)){row, item, cell in
            let clrCell = cell as! ColorViewCollectionViewCell
            clrCell.productColor = item
        }.disposed(by: disposeBag)
        
        productDetailsViewModel.imagesObservable.bind(to: imagesCollectionView.rx.items(cellIdentifier: Constants.imageCell)){row, item, cell in
            let imgCell = cell as! ImageCollectionViewCell
            imgCell.productImgObj = item
        }.disposed(by: disposeBag)
        
        
        productDetailsViewModel.productPriceObservable.bind(to: priceLabel.rx.text).disposed(by: disposeBag)
        productDetailsViewModel.productTitleObservable.bind(to: productTitle.rx.text).disposed(by: disposeBag)
        productDetailsViewModel.currencyObservable.bind(to: currencyLabel.rx.text).disposed(by: disposeBag)
        
    }
    
    private func subscribtion() {
        //                          when user select
        sizesCollectionView.rx.modelSelected(String.self).subscribe(onNext: {[weak self] (value) in
            guard let self = self else {return}
            self.selectedSize = value
        }).disposed(by: disposeBag)
        
        colorsCollectionView.rx.modelSelected(UIColor.self).subscribe(onNext: {[weak self] (value) in
            guard let self = self else {return}
            self.selectedColor = value
        }).disposed(by: disposeBag)
        
        productDetailsViewModel.showLoadingObservable.subscribe(onNext: { [weak self] (resBool) in
            guard let self = self else {return}
            if resBool {
                self.showLoading()
            } else {
                self.hideLoading()
            }
        }).disposed(by: disposeBag)
        
        productDetailsViewModel.showErrorObservable.subscribe(onNext: { [weak self] (errArr) in
            guard let self = self else {return}
            self.showAlert(title: errArr[0], msg: errArr[1])
        }).disposed(by: disposeBag)
        
        productDetailsViewModel.showToastObservable.subscribe(onNext: { [weak self] (msg) in
            guard let self = self else {return}
            self.showToast(message: msg, font: UIFont(name: "HelveticaNeue-ThinItalic", size: 15) ?? UIFont())
            }).disposed(by: disposeBag)
        
//        productDetailsViewModel.connectivityObservable.subscribe(onNext: { [weak self] (resBool) in
//            guard let self = self else {return}
//            if resBool {
//                self.hideNoConnivtivityView()
//            } else {
//                self.showNoConnivtivityView()
//            }
//        }).disposed(by: disposeBag)
    }
    
    private func showAlert(title: String, msg: String){
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion:nil)
    }
    
    private func showLoading() {
        activityView!.center = self.view.center
        self.view.addSubview(activityView!)
        activityView!.startAnimating()
    }
    
    private func hideLoading() {
        activityView!.stopAnimating()
    }
    
}


