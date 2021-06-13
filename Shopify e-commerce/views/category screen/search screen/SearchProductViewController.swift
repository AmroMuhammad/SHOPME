//
//  SearchProductViewController.swift
//  Shopify e-commerce
//
//  Created by Amr Muhammad on 6/1/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import DropDown

class SearchProductViewController: UIViewController {
    
    var productList:[CategoryProduct]!
    var searchViewModel:SearchViewModel!
    
    private var searchBar:UISearchBar!
    @IBOutlet private weak var searchCollectionVIew: UICollectionView!
    @IBOutlet private weak var sortButton: UIBarButtonItem!
    @IBOutlet private weak var filterButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    private var disposeBag:DisposeBag!
    private var sortDropDown:DropDown!
    private var filterDropDown:DropDown!
    @IBOutlet private weak var noInternetView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //register cell nib file
        let productNibCell = UINib(nibName: Constants.productNibCell, bundle: nil)
        searchCollectionVIew.register(productNibCell, forCellWithReuseIdentifier: Constants.productNibCell)
        
        //initialize dropList
        sortDropDown = DropDown()
        filterDropDown = DropDown()
        sortDropDown.anchorView = sortButton
        filterDropDown.anchorView = filterButton
        sortDropDown.dataSource = Constants.sortList
        filterDropDown.dataSource = Constants.filterList
        sortDropDown.direction = .bottom
        filterDropDown.direction = .bottom
        sortDropDown.bottomOffset = CGPoint(x: 0, y:toolbar.frame.height)
        filterDropDown.bottomOffset = CGPoint(x: 0, y:toolbar.frame.height)

        
        //add search bar to navigation bar
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20))
        searchBar.placeholder = "Search Item"
        let rightNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.rightBarButtonItem = rightNavBarButton
        
        searchViewModel = SearchViewModel()
        disposeBag = DisposeBag()

        searchCollectionVIew.rx.setDelegate(self).disposed(by: disposeBag)

        searchBar.rx.text
        .orEmpty.distinctUntilChanged().bind(to: searchViewModel.searchValue).disposed(by: disposeBag)
        
        searchViewModel.dataObservable.bind(to: searchCollectionVIew.rx.items(cellIdentifier: Constants.productNibCell)){row,item,cell in
           let castedCell = cell as! ProductsCollectionViewCell
            castedCell.allProductObject = item
        }.disposed(by: disposeBag)
        
        searchCollectionVIew.rx.modelSelected(SearchProduct.self).subscribe(onNext: {[weak self] (productItem) in
            let storyBoard : UIStoryboard = UIStoryboard(name: "productDetails", bundle:nil)
            let productDetailsVC = storyBoard.instantiateViewController(identifier: Constants.productDetailsVC) as! ProductDetailsTableViewController
            productDetailsVC.productId = "\(productItem.id)"
            productDetailsVC.productMainCategory = "Men"
            self?.navigationController?.pushViewController(productDetailsVC, animated: true)
        }).disposed(by: disposeBag)
        
        searchViewModel.errorObservable.subscribe(onNext: {[weak self] (boolValue) in
            switch boolValue{
            case true:
                self?.noInternetView.isHidden = false
            case false:
                self?.noInternetView.isHidden = true
            }
            }).disposed(by: disposeBag)
        
        searchViewModel.fetchData()
        
        //dropList actions
        sortDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.searchViewModel.sortData(index: index)
        }
        
        filterDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.searchViewModel.filterData(word: item)

        }
    }
    
    @IBAction func clearButtonClicked(_ sender: Any) {
        searchViewModel.clearData()
        searchBar.text = ""
    }
    
    @IBAction func sortButtonClicked(_ sender: Any) {
        sortDropDown.show()
    }
    
    @IBAction func filterButtonClicked(_ sender: Any) {
        filterDropDown.show()
    }
}

extension SearchProductViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 128, height: 128)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
