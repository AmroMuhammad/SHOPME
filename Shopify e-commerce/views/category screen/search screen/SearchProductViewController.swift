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

class SearchProductViewController: UIViewController {
    
    var productList:[CategoryProduct]!
    var searchViewModel:SearchViewModel!
    
    private var searchBar:UISearchBar!
    @IBOutlet private weak var searchCollectionVIew: UICollectionView!
    private var disposeBag:DisposeBag!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //register cell nib file
        let productNibCell = UINib(nibName: Constants.productNibCell, bundle: nil)
        searchCollectionVIew.register(productNibCell, forCellWithReuseIdentifier: Constants.productNibCell)
        
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
        
        searchViewModel.fetchData()
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
