//
//  StoreRecordView.swift
//  iWorker
//
//  Created by boyer on 2022/7/20.
//
//

import UIKit
import Viperit

//MARK: StoreRecordView Class
final class StoreRecordView: ReformBaseNavVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = "某个门店"
        
    }
    
    override func createView() {
        super.createView()
        
    }
}

//MARK: - StoreRecordView API
extension StoreRecordView: StoreRecordViewApi {
}

// MARK: - StoreRecordView Viper Components API
private extension StoreRecordView {
    var presenter: StoreRecordPresenterApi {
        return _presenter as! StoreRecordPresenterApi
    }
    var displayData: StoreRecordDisplayData {
        return _displayData as! StoreRecordDisplayData
    }
}
