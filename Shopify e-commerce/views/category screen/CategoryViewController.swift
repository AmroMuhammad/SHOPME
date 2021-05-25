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
    @IBOutlet weak var subCategoryCollectionView: UICollectionView!

    private var categoryViewModel:CategoryViewModel!
    private var disposeBag:DisposeBag!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //register cell nib file
        let mainCatNibCell = UINib(nibName: Constants.mainCatNibCelln, bundle: nil)
        mainCategoryCollectionView.register(mainCatNibCell, forCellWithReuseIdentifier: Constants.mainCatNibCelln)
        
        let subCatNibCell = UINib(nibName: Constants.subCatNibCell, bundle: nil)
        subCategoryCollectionView.register(subCatNibCell, forCellWithReuseIdentifier: Constants.subCatNibCell)
        
        //initialization
        categoryViewModel = CategoryViewModel()
        disposeBag = DisposeBag()
        
        //setting delegates
        mainCategoryCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        subCategoryCollectionView.rx.setDelegate(self).disposed(by: disposeBag)

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
        
        //when item selected
        mainCategoryCollectionView.rx.itemSelected.subscribe(onNext: {[weak self] (indexpath) in
            self?.testTExt.text = self?.mainCategories[indexpath.row]
            self?.subCategoryCollectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .top)
            }).disposed(by: disposeBag)
        
        subCategoryCollectionView.rx.itemSelected.subscribe(onNext: {[weak self] (indexpath) in
            self?.testTExt.text = self!.mainCategories[indexpath.row]+self!.mainCategories[indexpath.row]
        }).disposed(by: disposeBag)


        categoryViewModel.fetchData()
    }
    
}


extension CategoryViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if(collectionView.tag == 1){
            return CGSize(width: (self.view.frame.width)/3, height: 30)
        }else{
            return CGSize(width: 126, height: 30)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
