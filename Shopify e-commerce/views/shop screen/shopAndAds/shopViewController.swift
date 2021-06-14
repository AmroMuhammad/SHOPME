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
    let refreshControl = UIRefreshControl()
    @IBOutlet weak var gifBtnOutlet: UIButton!
    @IBOutlet weak var shopCollectionView: UICollectionView!
    @IBOutlet weak var ads: UILabel!
    @IBOutlet weak var connectionImg: UIImageView!
    @IBOutlet weak var gifimage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cartRightNavBar: RightNavBarView!
    @IBOutlet weak var discountOffer: UILabel!
    @IBOutlet weak var subDiscountOffer: UILabel!
    var categories = ["Women" , "Men" , "Kids"] // edit this after merge
    var selectedIndex = 0
    var selectedIndexPath = IndexPath(item: 0, section: 0)
    var indicatorView = UIView()
    let indicatorHeight : CGFloat = 5
    var currency : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        connectionImg.isUserInteractionEnabled = true

        indecator = UIActivityIndicatorView(style: .large)
        shopProductViewModel = shopViewModel()
        
        shopProductViewModel.quantutyObservable.subscribe(onNext: { [weak self] (quant) in
            self?.cartRightNavBar.quantity = "\(quant)"
        }).disposed(by: disposeBag)

       // collectionView.delegate = self
        let mainCatNibCell = UINib(nibName: Constants.menuCell, bundle: nil)
        collectionView.register(mainCatNibCell, forCellWithReuseIdentifier: Constants.menuCell)
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        //swipe to refresh
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipe(_:)))
        swipe.direction = .down
        connectionImg.addGestureRecognizer(swipe)

          shopProductViewModel.discountCodeDrive.drive(onNext: {[weak self] (discountCodeVal) in
            var  i : Int?
            self!.ads.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            self!.ads.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            if(self!.selectedIndex == 0){
                i = 2
            }
            else if (self!.selectedIndex == 2){
                i = 0
            }
            else{
                i = self!.selectedIndex
            }
            self!.ads.text = "USE CODE: \(discountCodeVal[i!].code)"
            }).disposed(by: disposeBag)

        // MARK: - Load function
        shopProductViewModel.loadingDriver.drive(onNext: { [weak self](loadVal) in
             print("\(loadVal)")
          switch loadVal{
            case true:
                self!.shopCollectionView.isHidden = true
                self!.indecator!.center = self!.shopCollectionView.center
                self!.indecator!.startAnimating()
                self!.view.addSubview(self!.indecator!)
            case false:
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
                  cell.layer.borderWidth = 1
                  cell.layer.borderColor = UIColor.gray.cgColor
                  cell.layer.cornerRadius = 20
//                  cell.layer.shadowOffset = CGSize(width: 0, height: 0)
//                  cell.layer.shadowRadius = 2.0
//                  cell.layer.shadowOpacity = 0.5
                  cell.layer.masksToBounds = true
            }.disposed(by: self!.disposeBag)
         }).disposed(by: disposeBag)
       //end
        
        
        Observable.just(categories).bind(to: collectionView.rx.items(cellIdentifier: Constants.menuCell)){row,item,cell in
            (cell as? mainCategoriesCollectionViewCell )?.categoryName.text = item
         }.disposed(by: disposeBag)
        
        collectionView.rx.itemSelected.subscribe{[weak self](IndexPath) in
            self!.applyChanges(index: IndexPath.element![1])
        }.disposed(by: disposeBag)

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
            productDetailsVC.productMainCategory = self?.categories[self?.selectedIndex ?? 0]
            self?.navigationController?.pushViewController(productDetailsVC, animated: true)
        }).disposed(by: disposeBag)
        
   }
    override func viewWillAppear(_ animated: Bool) {
        shopProductViewModel.getCartQuantity()
        currency = UserDefaults.standard.string(forKey: Constants.currencyUserDefaults)
        subDiscountOffer.text = "Order 2 " + currency! + "+"
        discountOffer.text = currency! + "10 OFF"
    }
    
    @objc func swipe(_ sender: UISwipeGestureRecognizer) {
        connectionImg.isHidden = true
        if(selectedIndex == 0){
            shopProductViewModel.fetchWomenData()
        }else if(selectedIndex == 1){
            shopProductViewModel.fetchMenData()
        }else{
            shopProductViewModel.fetchKidsData()
        }

    }
    @IBAction func wishListBtn(_ sender: Any) {
        if(UserData.sharedInstance.isLoggedIn()){
            let storyboard = UIStoryboard(name: "shop", bundle: nil)
            let wishVC = storyboard.instantiateViewController(identifier: "wishListViewController")
            self.navigationController?.pushViewController(wishVC, animated: true)
        }else{
            Support.notifyUser(title: "Error", body: "Kindly Login to be able to see Favourite List", context: self)
        }
    }
    
    @IBAction func cartBtn(_ sender: Any) {
        if(UserData.sharedInstance.isLoggedIn()){
            let storyboard = UIStoryboard(name: "shop", bundle: nil)
            let favVC = storyboard.instantiateViewController(identifier: "cartViewController")
            self.navigationController?.pushViewController(favVC, animated: true)
        }else{
            Support.notifyUser(title: "Error", body: "Kindly Login to be able to see Cart", context: self)
        }
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
        
        let defaults = UserDefaults.standard
       
        if(selectedIndex == 0){
            gifURL = Constants.womenGif
            defaults.set(true, forKey: "Women")
        }
        else if(selectedIndex == 1){
            gifURL  = Constants.menGif
            defaults.set(true, forKey: "Men")
        }else{
            gifURL = Constants.kidsGif
            defaults.set(true, forKey: "Kids")
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
                self.indicatorView.frame = CGRect(x: desiredX, y: self.collectionView.bounds.maxY - self.indicatorHeight, width: self.collectionView.frame.width / CGFloat(self.categories.count), height: self.indicatorHeight)
           }
       }
    
    func tapIsSelected(imgName : String) {
         gifimage.image = UIImage(named: imgName)!
         gifBtnOutlet.isHidden = false
         self.ads.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
         self.ads.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
         self.ads.text = "Click on ads to get code"
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

extension shopViewController :  UICollectionViewDelegateFlowLayout {

      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
            if(collectionView.tag == 1){
                return CGSize(width: (self.collectionView.frame.width)/3, height: 30)
            }else{
                return CGSize(width: 128, height: 128)
            }
        }
    
}

