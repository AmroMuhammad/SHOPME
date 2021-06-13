//
//  CategoryViewController.swift
//  Shopify e-commerce
//
//  Created by Amr Muhammad on 5/24/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CategoryViewController: UIViewController {
    @IBOutlet private weak var mainCategoryCollectionView: UICollectionView!
    @IBOutlet private weak var subCategoryCollectionView: UICollectionView!
    @IBOutlet private weak var productsCollectionView: UICollectionView!
    @IBOutlet private weak var noItemsView: UIView!
    @IBOutlet private weak var noConnectionImage: UIView!
    @IBOutlet private weak var rightNavBarView: RightNavBarView!
    
    private var categoryViewModel:CategoryViewModelContract!
    private var disposeBag:DisposeBag!
    private var mainCat:String = Constants.mainCategories[0]
    private var subCat:String = Constants.subCategories[0]
    private var activityView:UIActivityIndicatorView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //register cell nib file
        let mainCatNibCell = UINib(nibName: Constants.mainCatNibCelln, bundle: nil)
        mainCategoryCollectionView.register(mainCatNibCell, forCellWithReuseIdentifier: Constants.mainCatNibCelln)
        
        let subCatNibCell = UINib(nibName: Constants.subCatNibCell, bundle: nil)
        subCategoryCollectionView.register(subCatNibCell, forCellWithReuseIdentifier: Constants.subCatNibCell)
        
        let productNibCell = UINib(nibName: Constants.productNibCell, bundle: nil)
        productsCollectionView.register(productNibCell, forCellWithReuseIdentifier: Constants.productNibCell)
        
        //initialization
        activityView = UIActivityIndicatorView(style: .large)
        categoryViewModel = CategoryViewModel()
        disposeBag = DisposeBag()
        
        //swipe to refresh
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(_:)))
        swipe.direction = .down
        swipe.numberOfTouchesRequired = 1
        noConnectionImage.addGestureRecognizer(swipe)
        
        //setting delegates
        mainCategoryCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        subCategoryCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        productsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)


        //select first item at initialization
        let selectedIndexPath = IndexPath(item: 0, section: 0)

        //bindingData from viewModel
        categoryViewModel.mainCatDataObservable.bind(to: mainCategoryCollectionView.rx.items(cellIdentifier: Constants.mainCatNibCelln)){ [weak self] row,item,cell in
           let castedCell = cell as! MainCategoryCollectionViewCell
            castedCell.mainCategoryName.text = item
            self?.mainCategoryCollectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .top)
        }.disposed(by: disposeBag)
        
        categoryViewModel.subCatDataObservable.bind(to: subCategoryCollectionView.rx.items(cellIdentifier: Constants.subCatNibCell)){ [weak self] row,item,cell in
           let castedCell = cell as! SubCategoryCollectionViewCell
            castedCell.mainCategoryName.text = item
            self?.subCategoryCollectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .top)
        }.disposed(by: disposeBag)
        
        categoryViewModel.productDataObservable.bind(to: productsCollectionView.rx.items(cellIdentifier: Constants.productNibCell)){row,item,cell in
           let castedCell = cell as! ProductsCollectionViewCell
            castedCell.productObject = item
        }.disposed(by: disposeBag)
        
        categoryViewModel.quantutyObservable.bind(to: rightNavBarView.rx.quantity).disposed(by: disposeBag)
        
        //when item selected
        mainCategoryCollectionView.rx.modelSelected(String.self).subscribe(onNext: {[weak self] (value) in
            self?.subCategoryCollectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .top)
            self?.mainCat = value
            self?.subCat = Constants.subCategories[0]
            self?.categoryViewModel.fetchCatProducts(mainCat: self!.mainCat, subCat: self!.subCat)
        }).disposed(by: disposeBag)
        
        subCategoryCollectionView.rx.modelSelected(String.self).subscribe(onNext: {[weak self] (value) in
            self?.subCat = value
            self?.categoryViewModel.fetchCatProducts(mainCat: self!.mainCat, subCat: self!.subCat)
        }).disposed(by: disposeBag)

        productsCollectionView.rx.modelSelected(CategoryProduct.self).subscribe(onNext: {[weak self] (productItem) in
            let storyBoard : UIStoryboard = UIStoryboard(name: "productDetails", bundle:nil)
            let productDetailsVC = storyBoard.instantiateViewController(identifier: Constants.productDetailsVC) as! ProductDetailsTableViewController
            productDetailsVC.productId = "\(productItem.id)"
            productDetailsVC.productMainCategory = self?.mainCat
            self?.navigationController?.pushViewController(productDetailsVC, animated: true)
        }).disposed(by: disposeBag)
        
        //listen while getting data
        categoryViewModel.errorObservable.subscribe(onNext: {[weak self] (boolValue) in
            switch boolValue{
            case true:
                self?.hideLoading()
                self?.showToast(message: "Please swipe to refresh", font: UIFont(name: "HelveticaNeue-ThinItalic", size: 15) ?? UIFont())
                self?.noConnectionImage.isHidden = false
            case false:
                self?.noConnectionImage.isHidden = true
            }
            }).disposed(by: disposeBag)
        
        categoryViewModel.noItemsObservable.subscribe(onNext: {[weak self] (boolValue) in
            switch boolValue{
            case true:
                self?.noItemsView.isHidden = false
                print(".>>>>>>>>>>>>")
            case false:
                self?.noItemsView.isHidden = true
                print("<<<<<<<<<<<<<")
            }
            }).disposed(by: disposeBag)
        
        categoryViewModel.loadingObservable.subscribe(onNext: {[weak self] (value) in
            switch value{
            case true:
                self?.showLoading()
            case false:
                self?.hideLoading()
            }
        }).disposed(by: disposeBag)

        categoryViewModel.fetchData()
        categoryViewModel.fetchCatProducts(mainCat: mainCat, subCat: subCat)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        categoryViewModel.getCartQuantity()
    }
    
    @objc func handleSwipe(_ sender: UITapGestureRecognizer? = nil) {
        categoryViewModel.fetchCatProducts(mainCat: mainCat, subCat: subCat)
    }
    
    @IBAction func searchButtonClicked(_ sender: Any) {
        let searchViewController = storyboard?.instantiateViewController(identifier: Constants.searchViewController) as! SearchProductViewController
        searchViewController.productList = categoryViewModel.data
        navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    @IBAction func favButtonPressed(_ sender: Any) {
        if(UserData.sharedInstance.isLoggedIn()){
            let storyboard = UIStoryboard(name: "shop", bundle: nil)
            let wishVC = storyboard.instantiateViewController(identifier: "wishListViewController")
            self.navigationController?.pushViewController(wishVC, animated: true)
        }else{
            Support.notifyUser(title: "Error", body: "Kindly Login to be able to see Favourite List", context: self)
        }
        
    }
    
    @IBAction func cartButtonPressed(_ sender: Any) {
        if(UserData.sharedInstance.isLoggedIn()){
            let storyboard = UIStoryboard(name: "shop", bundle: nil)
            let favVC = storyboard.instantiateViewController(identifier: "cartViewController")
            self.navigationController?.pushViewController(favVC, animated: true)
        }else{
            Support.notifyUser(title: "Error", body: "Kindly Login to be able to see Cart", context: self)
        }
    }
    
}


extension CategoryViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if(collectionView.tag == 1){
            return CGSize(width: (self.view.frame.width)/3, height: 30)
        }else if(collectionView.tag == 2){
            return CGSize(width: 126, height: 30)
        }else{
            return CGSize(width: 128, height: 128)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}


extension CategoryViewController : BaseViewControllerContract{
    func showLoading() {
        activityView!.center = self.view.center
        self.view.addSubview(activityView!)
        activityView!.startAnimating()
    }
    
    func hideLoading() {
        activityView!.stopAnimating()
    }
    
    func showErrorMessage(errorMessage: String) {
        let alertController = UIAlertController(title: "Error", message: "An Error Occured", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel)
        { action -> Void in
            // Put your code here
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}
