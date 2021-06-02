//
//  SearchViewModel.swift
//  Shopify e-commerce
//
//  Created by Amr Muhammad on 6/2/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel{
    var dataObservable: Observable<[CategoryProduct]>
    var data:[CategoryProduct]!
    var searchValue : BehaviorRelay<String> = BehaviorRelay(value: "")
    
    private lazy var searchValueObservable:Observable<String> = searchValue.asObservable()
    private var disposeBag = DisposeBag()
    private var datasubject = PublishSubject<[CategoryProduct]>()

 
    init(data:[CategoryProduct]) {
        self.data = data
        dataObservable = datasubject.asObservable()
        searchValueObservable.subscribe(onNext: {[weak self] (value) in
        print("value is \(value)")
        let filteredData = self?.data?.filter({ (product) -> Bool in
            product.title.lowercased().prefix(value.count) == value.lowercased()
        })
        self?.datasubject.onNext(filteredData ?? [])
        }).disposed(by: disposeBag)
    }
    
    func fetchData(){
        datasubject.onNext(data)
    }
    
}
