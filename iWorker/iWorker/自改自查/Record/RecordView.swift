//
//  RecordView.swift
//  iWorker
//
//  Created by boyer on 2022/7/17.
//
//

import UIKit
import Viperit

//MARK: - Public Interface Protocol
protocol RecordViewInterface {
}

//MARK: RecordView Class
final class RecordView: UserInterface {
}

//MARK: - Public interface
extension RecordView: RecordViewInterface {
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension RecordView {
    var presenter: RecordPresenter {
        return _presenter as! RecordPresenter
    }
    var displayData: RecordDisplayData {
        return _displayData as! RecordDisplayData
    }
}
