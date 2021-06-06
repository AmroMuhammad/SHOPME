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
    @IBOutlet weak var gifBtnOutlet: UIButton!
    @IBOutlet weak var shopCollectionView: UICollectionView!
    @IBOutlet weak var ads: UILabel!
    @IBOutlet weak var connectionImg: UIImageView!
    @IBOutlet weak var gifimage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    var categories = ["Women" , "Men" , "Kids"] // edit this after merge
    var selectedIndex = 0
    var selectedIndexPath = IndexPath(item: 0, section: 0)
    var indicatorView = UIView()
    let indicatorHeight : CGFloat = 5
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shopProductViewModel = shopViewModel()

        shopProductViewModel.discountCodeDrive.drive(onNext: { (discountCodeVal) in
            self.ads.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            self.ads.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.ads.text = "USE CODE: \(discountCodeVal[0].code)"
            }).disposed(by: disposeBag)

        // MARK: - Load function
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
        // END
        
        // MARK: - Display data
        
         shopProductViewModel.dataDrive.drive(onNext: {[weak self] (val) in
            self!.indecator!.stopAnimating()
            self!.indecator!.isHidden = true
            self!.shopCollectionView.delegate = nil
            self!.shopCollectionView.dataSource = nil
            Observable.just(val).bind(to: self!.shopCollectionView.rx.items(cellIdentifier: Constants.shopCell)){row,item,cell in
                (cell as? shopCollectionViewCell)?.cellProduct = item
                cell.layer.cornerRadius = 30
                cell.layer.borderWidth = 0.0
                cell.layer.shadowColor = UIColor.gray.cgColor
                cell.layer.shadowOffset = CGSize(width: 0, height: 0)
                cell.layer.shadowRadius = 5.0
                cell.layer.shadowOpacity = 1
                cell.layer.masksToBounds = true
            }.disposed(by: self!.disposeBag)
         }).disposed(by: disposeBag)
       //end
        
       // MARK: - Error
        
         shopProductViewModel.errorDriver.drive(onNext: { [weak self](errorVal) in
             print("\(errorVal)")
            self!.showAlert(msg: errorVal)
            
         }).disposed(by: disposeBag)
        // end
        
        //MARK: - internet connection
        
        shopProductViewModel.connectivityDriver.drive(onNext: { [weak self](result) in
            if(result){
                self!.connectionImg.isHidden = false
                print("no internet connection")
                self!.showAlert(msg: "No Internet Connection")
            }
            else{
                 self!.connectionImg.isHidden = true
            }
            }).disposed(by: disposeBag)
        
        //end
        
       //MARK: - menu bar
       collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .centeredVertically)
       indicatorView.backgroundColor = .black
       indicatorView.frame = CGRect(x: collectionView.bounds.minX, y: collectionView.bounds.maxY - indicatorHeight, width: collectionView.bounds.width / CGFloat(categories.count), height: indicatorHeight)
       collectionView.addSubview(indicatorView)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        leftSwipe.direction = .left
        self.view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
        
        //end
       shopProductViewModel.fetchWomenData()
        
        shopCollectionView.rx.modelSelected(Product.self).subscribe(onNext: {[weak self] (productItem) in
            let storyBoard : UIStoryboard = UIStoryboard(name: "productDetails", bundle:nil)
            let productDetailsVC = storyBoard.instantiateViewController(identifier: Constants.productDetailsVC) as! ProductDetailsTableViewController
            productDetailsVC.productId = "\(productItem.id)"
            self?.navigationController?.pushViewController(productDetailsVC, animated: true)
        }).disposed(by: disposeBag)
        
   }
    @IBAction func wishListBtn(_ sender: Any) {
           let wishListViewController = storyboard?.instantiateViewController(identifier: Constants.wishListVC) as! wishListViewController
           navigationController?.pushViewController(wishListViewController, animated: true)
       }
       
       @IBAction func cartBtn(_ sender: Any) {
           let cartViewController = storyboard?.instantiateViewController(identifier: Constants.cartVC) as! CardViewController
           navigationController?.pushViewController(cartViewController, animated: true)
       }
       
       @IBAction func searchBtn(_ sender: Any) {
            let storyBoard : UIStoryboard = UIStoryboard(name: "category", bundle:nil)
            let searchViewController = storyBoard.instantiateViewController(identifier: Constants.searchViewController) as! SearchProductViewController
            // searchViewController.productList = categoryViewModel.data
            navigationController?.pushViewController(searchViewController, animated: true)
       }

    
    
    @IBAction func gifBtn(_ sender: Any) {
        gifBtnOutlet.isHidden = true
        var gifURL = ""
        
        if(selectedIndex == 0){
            gifURL = Constants.womenGif
        }
        else if(selectedIndex == 1){
            gifURL  = Constants.menGif
        }else{
            gifURL = Constants.kidsGif
        }
        
        gifimage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        gifimage.sd_setImage(with: URL(string: gifURL), placeholderImage: UIImage(named: "1"))
        shopProductViewModel.fetchDiscountCodeData()
        
    }
    
    @objc func swipeAction(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            if selectedIndex < categories.count - 1 {
                selectedIndex += 1
            }
        } else {
            if selectedIndex > 0 {
                selectedIndex -= 1
            }
        }
        
        selectedIndexPath = IndexPath(item: selectedIndex, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .centeredVertically)
        applyChanges(index: selectedIndex)
    }
    
    func changeIndecatorViewPosition(){
           let desiredX = (collectionView.bounds.width / CGFloat(categories.count)) * CGFloat(selectedIndex)
           
           UIView.animate(withDuration: 0.3) {
                self.indicatorView.frame = CGRect(x: desiredX, y: self.collectionView.bounds.maxY - self.indicatorHeight, width: self.collectionView.bounds.width / CGFloat(self.categories.count), height: self.indicatorHeight)
           }
       }
    
    func tapIsSelected(imgName : String) {
         gifimage.image = UIImage(named: imgName)!
         gifBtnOutlet.isHidden = false
         self.ads.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
         self.ads.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
         self.ads.text = "Ads"
    }
    
    func showAlert(msg : String){
        let alertController = UIAlertController(title: "Error", message: msg , preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel)
        { action -> Void in })
        self.present(alertController, animated: true, completion: nil)
    }
    
    func applyChanges(index : Int){
        if(index == 0){
            self.shopProductViewModel.fetchWomenData()
            tapIsSelected(imgName: "giphy")
        }else if(index == 1){
            tapIsSelected(imgName: "giphy-4")
            self.shopProductViewModel.fetchMenData()
        }else {
           tapIsSelected(imgName: "giphy-6")
           self.shopProductViewModel.fetchKidsData()
        }
        selectedIndex = index
        changeIndecatorViewPosition()
    }

}

extension shopViewController :  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return categories.count
      }


      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.menuCell , for: indexPath) as! allProductCollectionViewCell
        cell.setupCell(text: categories[indexPath.row])
          return cell
      }

      
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          return CGSize(width: self.view.frame.width / CGFloat(categories.count), height: collectionView.bounds.height)
      }
      
      
      func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        applyChanges(index: indexPath.row)
      }
}

