//
//  UpdatePwdCombineVC.swift
//  iWorker
//
//  Created by boyer on 2022/6/6.
//

import Foundation
import UIKit
import Combine

class UpdatePwdCombineVC: JHNewLoginSetPswViewController {
    
    // 发布者
    @Published var newPwd:String?
    @Published var tryPwd:String?
    // 订阅者
    var invatedPwd:AnyPublisher<String?,Never>{
        return $newPwd.map { pwd in
            guard let value = pwd, value.count > 5 else {
//                VCTools.toast("密码长度必须大于5")
                return nil
            }
            return value
        }.eraseToAnyPublisher()
    }
    
    var readyToSubmit:AnyPublisher<(String, String)?, Never>{
        return Publishers.CombineLatest($newPwd, $tryPwd).map { pwd,trypwd in
            guard let pwdValue = pwd, let tryValue = trypwd, pwdValue == tryValue else{return nil}
            return (pwdValue, tryValue)
        }.eraseToAnyPublisher()
    }
    
    var cancelAbles:Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readyToSubmit.map{$0 != nil}
                     .receive(on: RunLoop.main)
                     .assign(to: \.isEnabled, on: submmitBtn)
                     .store(in: &cancelAbles)
    }
    
    
    
    override func newpwd(tf: UITextField) {
        newPwd = tf.text
    }
    
    override func trypwd(tf: UITextField) {
        tryPwd = tf.text
    }
}
