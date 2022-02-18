//
//  JHDeviceSharePreController.swift
//  iWorker
//
//  Created by boyer on 2022/2/18.
//

import UIKit
import JHBase
import WebKit
//分享预览页面
//webcore调用
class JHShareDevicePreController: JHBaseNavVC{
    var webUrl = "https://baidu.com"
    private var wbView:WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitle = "邀请好友"
        createView()
        //加载h5页面
        wbView.load(URLRequest(urlString: webUrl)!)
    }
    
    //TODO: webcore push 页面
    class func shareData(url:String) {
        let shareVC = JHShareDevicePreController()
        shareVC.webUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        topVC?.present(shareVC, animated: true, completion: nil)
    }
    
    //TODO: 截取图片分享
    @objc func shareVX() {
        let shareImg = clipScreen()
        
    }
    
    func clipScreen() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.wbView.size, true, UIScreen.main.scale)
        self.wbView.layer.render(in:UIGraphicsGetCurrentContext()!)
        let imageRet = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageRet!
    }
    
    func createView() {
        //分享按钮
        let shareBtn = UIButton()
        shareBtn.setImage(.init(named: "sharevx"), for: .normal)
        shareBtn.addTarget(self, action: #selector(shareVX), for: .touchDown)
        self.navBar.addSubview(shareBtn)
        
        let webView = WKWebView()
        wbView = webView
        self.view.addSubview(shareBtn)
        self.view.addSubview(webView)
        shareBtn.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.size.equalTo(CGSize.init(width: 22, height: 22))
            make.centerY.equalTo(self.navBar.titleLabel.snp.centerY)
        }
        
        webView.snp.makeConstraints { make in
            make.top.equalTo(self.navBar.snp.bottom)
            make.left.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
}
