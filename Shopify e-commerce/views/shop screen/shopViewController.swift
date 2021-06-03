//
//  shopViewController.swift
//  Shopify e-commerce
//
//  Created by marwa on 5/25/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage
class shopViewController: UIViewController {
    var shopProductViewModel : shopViewModelType!
    private let disposeBag = DisposeBag()
    var indecator : UIActivityIndicatorView?
    @IBOutlet weak var shopCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var gifimage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    var categories = ["Women" , "Men" , "Kids"]
    override func viewDidLoad() {
        super.viewDidLoad()
       
               
        let gifURL : String = "https://media.giphy.com/media/3o6EhTpmOMApdn87cI/giphy.gif"
        gifimage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        gifimage.sd_setImage(with: URL(string: gifURL), placeholderImage: UIImage(named: "1"))
        shopProductViewModel = shopViewModel()
        searchBar.rx.text.orEmpty.debug().distinctUntilChanged().bind(to: shopProductViewModel.searchValue).disposed(by: disposeBag)
        shopProductViewModel.loadingDriver.drive(onNext: { [weak self](loadVal) in
             print("\(loadVal)")
            
            if(loadVal == true){
                self!.shopCollectionView.isHidden = true
                self!.indecator = UIActivityIndicatorView(style: .large)
                self!.indecator!.center = self!.shopCollectionView.center
                self!.indecator!.startAnimating()
                self!.view.addSubview(self!.indecator!)
            }
            else{
                self!.shopCollectionView.isHidden = false
                self!.indecator!.stopAnimating()
                self!.indecator!.isHidden = true
            }
            }).disposed(by: disposeBag)
         shopProductViewModel.dataDrive.drive(onNext: {[weak self] (val) in
            self!.indecator!.stopAnimating()
            self!.indecator!.isHidden = true
            self!.shopCollectionView.delegate = nil
            self!.shopCollectionView.dataSource = nil
            Observable.just(val).bind(to: self!.shopCollectionView.rx.items(cellIdentifier: "shopCollectionViewCell")){row,item,cell in
                (cell as? shopCollectionViewCell)?.shopImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
                (cell as? shopCollectionViewCell)?.shopImg.sd_setImage(with: URL(string:item.image.src) , placeholderImage: UIImage(named: "1"))
                (cell as? shopCollectionViewCell)?.vendor.text = item.vendor
                (cell as? shopCollectionViewCell)?.layer.cornerRadius = 50
                cell.layer.borderWidth = 0.0
                (cell as? shopCollectionViewCell)?.layer.shadowColor = UIColor.gray.cgColor
                cell.layer.shadowOffset = CGSize(width: 0, height: 0)
                cell.layer.shadowRadius = 5.0
                cell.layer.shadowOpacity = 1
                cell.layer.masksToBounds = true
            }.disposed(by: self!.disposeBag)
         }).disposed(by: disposeBag)
       

         shopProductViewModel.errorDriver.drive(onNext: { (errorVal) in
             print("\(errorVal)")
         }).disposed(by: disposeBag)
        
        shopProductViewModel.fetchWomenData()
        // Do any additional setup after loading the view.
        let observable = Observable<[String]>.just(["Women","Men","Kids"]);
          
          observable.bind(to: collectionView.rx.items(cellIdentifier: "CollectionViewCell")){[weak self]
            row , item , cell in (cell as? allProductCollectionViewCell)?.categoryName.text = item
           
                if let cell = self!.collectionView.cellForItem(at: [0,0]) as? allProductCollectionViewCell {
                    cell.categoryCellImage.backgroundColor =  UIColor.black
                }
            
          }.disposed(by: disposeBag)
          
          collectionView.rx.itemSelected.subscribe{[weak self](IndexPath) in
            var cell1Color = UIColor.white
            var cell2Color = UIColor.white
            var cell3Color = UIColor.white
            if IndexPath.element![1] == 0{
                cell1Color = UIColor.black
                self!.shopProductViewModel.fetchWomenData()
               
            }
           else if IndexPath.element![1] == 1{
                cell2Color = UIColor.black
                self!.shopProductViewModel.fetchMenData()
                
            }
           else if IndexPath.element![1] == 2{
                cell3Color = UIColor.black
                self!.shopProductViewModel.fetchKidsData()
               
            }
            if let cell = self!.collectionView.cellForItem(at: [0,0]) as? allProductCollectionViewCell {
                cell.categoryCellImage.backgroundColor = cell1Color
            }
            if let cell = self!.collectionView.cellForItem(at: [0,1]) as? allProductCollectionViewCell {
                cell.categoryCellImage.backgroundColor = cell2Color
            }
            if let cell = self!.collectionView.cellForItem(at: [0,2]) as? allProductCollectionViewCell {
               cell.categoryCellImage.backgroundColor = cell3Color
            }
            
            print("\(IndexPath.element!)")
          }.disposed(by: disposeBag)
        
//        collectionView.rx.modelSelected(String.self).subscribe{(val) in
//                   print("\(val.element!)")
//
//        //    self.cellView.backgroundColor = .red
//               }.disposed(by: disposeBag)
//
   }


}
extension shopViewController : UICollectionViewDelegateFlowLayout {
   
    
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
//    {
//
//            return CGSize(width: (self.view.frame.width)/3, height: 30)
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(3 - 1))
            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(3))
            return CGSize(width: size, height: size)
    }

}


