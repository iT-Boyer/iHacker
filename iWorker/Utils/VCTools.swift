//
//  UITools.swift
//  iWorker
//
//  Created by boyer on 2022/3/24.
//

import Foundation
import JHBase
import MBProgressHUD

class VCTools: UIViewController {
        
    static func toast(_ msg:String) {
        
        guard let topView = topVC?.view else {
            return
        }
        let hub = MBProgressHUD.showAdded(to: topView, animated: true)
        hub.mode = .text
        hub.detailsLabel.text = msg
        hub.offset = .init(x: 0, y: MBProgressMaxOffset)
        hub.hide(animated: true, afterDelay: 3)
    }
}
