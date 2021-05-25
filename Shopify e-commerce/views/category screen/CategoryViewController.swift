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
    let mainCategories = ["Men","Women","Kids"]
    @IBOutlet weak var testTExt: UILabel!
    @IBOutlet private weak var mainCategoryCollectionView: UICollectionView!
    private var categoryViewModel:CategoryViewModel!
    private var disposeBag:DisposeBag!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //register cell nib file
        let nibCell = UINib(nibName: "MainCategoryCollectionViewCell", bundle: nil)
        mainCategoryCollectionView.register(nibCell, forCellWithReuseIdentifier: "MainCategoryCollectionViewCell")
        
        categoryViewModel = CategoryViewModel()
        disposeBag = DisposeBag()
        
        mainCategoryCollectionView.rx.setDelegate(self).disposed(by: disposeBag)

        //select first item at initialization
        let selectedIndexPath = IndexPath(item: 0, section: 0)

        categoryViewModel.dataObservable.bind(to: mainCategoryCollectionView.rx.items(cellIdentifier: "MainCategoryCollectionViewCell")){ [weak self] row,item,cell in
           let castedCell = cell as! MainCategoryCollectionViewCell
            castedCell.mainCategoryName.text = item
            self?.mainCategoryCollectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .top)
        }.disposed(by: disposeBag)
        
        mainCategoryCollectionView.rx.itemSelected.subscribe(onNext: { (indexpath) in
            self.testTExt.text = self.mainCategories[indexpath.row]
            }).disposed(by: disposeBag)

        categoryViewModel.fetchData()
    }
    
}


extension CategoryViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: (self.view.frame.width)/3, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
