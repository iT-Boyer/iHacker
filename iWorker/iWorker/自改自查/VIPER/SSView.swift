//
//  SSView.swift
//  iWorker
//
//  Created by boyer on 2022/7/14.
//
//

import UIKit
import Viperit

//MARK: - Public Interface Protocol
protocol SSViewInterface {
}

//MARK: SSView Class
final class SSView: UserInterface {
}

//MARK: - Public interface
extension SSView: SSViewInterface {
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension SSView {
    var presenter: SSPresenter {
        return _presenter as! SSPresenter
    }
    var displayData: SSDisplayData {
        return _displayData as! SSDisplayData
    }
}
