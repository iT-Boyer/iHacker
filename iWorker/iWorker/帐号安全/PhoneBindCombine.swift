//
//  PhoneBindCombine.swift
//  iWorker
//
//  Created by boyer on 2022/6/6.
//

import Foundation
import Combine
import UIKit

class PhoneBindCombine: PhoneBindBaseVC {
    
    //发布者
    // 方式1:
    @Published var tel:String?
    @Published var code:String?
    // 方式2:
    var validatedTel:AnyPublisher<String?,Never>?
    var readyToSubmit:AnyPublisher<(String, String)?,Never>?
    
    //订阅者：必须属性引用，否则无法监听发布者的数据
    var telSubscriber: AnyCancellable?
    var codeSubscriber: AnyCancellable?
    
    //定时器 订阅模式
    var timerSubscriber: AnyCancellable?
    var timerPublisher = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    var myBackgroundQueue: DispatchQueue = .init(label: "myBackgroundQueue")
    
    var cancellableSet: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        combineAction()
        combineTwoPublisher()
        readyToSubmit!.map { $0 != nil}
                      .receive(on: RunLoop.main)
                      .assign(to: \.isEnabled, on: submmitBtn)
                      .store(in: &cancellableSet)
    }
    
    override func changeTel(tf: UITextField) {
        tel = tf.text
        timerPublisher.upstream.connect().cancel()
    }
    
    override func changeCode(tf: UITextField) {
        code = tf.text
    }
    override func submmit() {
        
    }
    override func codeAction() {
        var count = 120
        codeBtn.isEnabled = false
        //必须属性引用，否则正常倒计时
        timerSubscriber = timerPublisher.print("倒计时").sink {[weak self] receivedTimeStamp in
            guard let weakSelf = self else { return }
            if count == 0{
                weakSelf.codeBtn.isEnabled = true
                //取消定时器
                weakSelf.timerPublisher.upstream.connect().cancel()
            }
            count -= 1
            weakSelf.codeBtn.setTitle("重新获取(\(count))", for: .disabled)
        }
    }
}

extension PhoneBindCombine{
    
    // CombineLatest 使用关联多个订阅者的方式刷新UI
    func combineTwoPublisher() {
        validatedTel = $tel.map { tel in
            guard let telValue = tel ,telValue.count == 11 else{
                DispatchQueue.main.async {
                    self.codeBtn.isEnabled = false
                }
                return nil
            }
            DispatchQueue.main.async {
                self.codeBtn.isEnabled = true
            }
            return tel
        }.eraseToAnyPublisher()
        
        guard let validate1 = validatedTel else { return }
        readyToSubmit = Publishers.CombineLatest(validate1, $code).map{tel,code in
            guard let telValue = tel,let codeValue = code, codeValue.count == 6 else {return nil}
            return (telValue, codeValue)
        }.eraseToAnyPublisher()
    }
    
    // Combine 订阅者独立响应链刷新UI
    func combineAction() {
        telSubscriber = $tel
            .throttle(for: 0.5, scheduler: myBackgroundQueue, latest: true)
            .removeDuplicates()
            .print("手机绑定管道") // debugging output for pipeline
            .map { tel -> Bool in
                guard let telValue = tel ,telValue.count == 11 else{
                    return false
                }
                return true
            }
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: codeBtn)
        
        codeSubscriber = $code
            .throttle(for: 0.5, scheduler: myBackgroundQueue, latest: true)
            .removeDuplicates()
            .print("验证码管道")
            .map { code -> Bool in
                guard let telValue = self.tel ,telValue.count == 11 else{
                    return false
                }
                
                guard let codeValue = self.code ,codeValue.count == 6 else{
                    return false
                }
                
                return true
            }
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: submmitBtn)
    }
}
