//
//  JHDeviceSharePreController.swift
//  iWorker
//
//  Created by boyer on 2022/2/18.
//

import UIKit
import JHBase
import WebKit
import MBProgressHUD
//分享预览页面
//webcore调用
class JHShareDevicePreController: JHBaseNavVC{
    var webUrl = "https://testripx.iuoooo.com/ui/moblie/#/InviterShare?appId=3952cf92-9d2a-4d57-b09a-dd090e1033c3&curChangeOrg=798dd0d8-fbaf-4161-b1a2-92a801470412&storeId=37824963-732f-4084-9867-f33cb79ddd31&userId=13414a6d-7f76-4793-8c1b-57ed4f2353fe"
    private var wbView:WKWebView!
    private lazy var hud:MBProgressHUD = {
        MBProgressHUD.showAdded(to: view, animated: true)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitle = "邀请好友"
        createView()

        hud.show(animated: true)
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
        shareBtn.backgroundColor = .initWithHex("FC9023")
        let fontPath = Bundle.main.path(forResource: "优设标题黑", ofType: "TTF")
        shareBtn.titleLabel?.font = customFont(fontPath!, size: 20)
        shareBtn.setTitle("发送邀请", for: .normal)
        shareBtn.addTarget(self, action: #selector(shareVX), for: .touchDown)
        
        let webView = WKWebView()
        wbView = webView
        webView.navigationDelegate = self
        self.view.addSubview(webView)
        self.view.addSubview(shareBtn)
        webView.snp.makeConstraints { make in
            make.top.equalTo(self.navBar.snp.bottom)
            make.left.centerX.equalToSuperview()
            make.bottom.equalTo(shareBtn.snp.top)
        }
        shareBtn.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.left.bottom.centerX.equalToSuperview()
        }
    }
    
    //MARK: 加载字体
    
    /// 加载otf字体文件，显示字体样式
    ///
    /// - Parameters:
    ///   - path: otf文件路径
    ///   - size: 字体大小
    /// - Returns: 返回font字体
    func customFont(_ path:String, size:CGFloat) -> UIFont {
        let fontUrl = URL.init(fileURLWithPath: path)
        let fontDataProvider = CGDataProvider.init(url: fontUrl as CFURL)
        let fontRef = CGFont.init(fontDataProvider!)
        CTFontManagerRegisterGraphicsFont(fontRef!, nil)
        let fontName = fontRef?.postScriptName
        let font = UIFont.init(name: fontName! as String, size: size)
        return font!
    }
}

extension JHShareDevicePreController:WKNavigationDelegate{
    
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    // 网页加载完成
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        /*
         主意：这个方法是当网页的内容全部显示（网页内的所有图片必须都正常显示）的时候调用（不是出现的时候就调用），，否则不显示，或则部分显示时这个方法就不调用。
         */
        hud.hide(animated: true)
    }
    // 页面加载失败时调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
    
}
