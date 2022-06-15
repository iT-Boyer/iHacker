//
//  StoreDSelSearchBar.swift
//  iWorker
//
//  Created by boyer on 2022/1/12.
//

import UIKit
import MBProgressHUD
import SwifterSwift

class StoreDSelSearchBar: UIView {
    
    var handlerBlock:((String)->())
    var clearBlock:(()->())
    var placeholder:String!
    
    init(with placeholder:String,handler:@escaping (String)->(),clear:@escaping ()->()) {
        handlerBlock = handler
        clearBlock = clear
        super.init(frame: CGRect.zero)
        self.placeholder = placeholder
        clearType()
        self.isUserInteractionEnabled = true
        self.backgroundColor = .init(red:240/255.0, green:240/255.0, blue:240/255.0, alpha:1.0)
        self.layer.cornerRadius = 15
        
        self.addSubview(self.searchBar)
        self.searchBar.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalTo(-8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.setImage(.init(named: "searchhicon"), for: .search, state: .normal)
        searchBar.setImage(.init(named: "clearricon"), for: .clear, state: .normal)
        return searchBar
    }()
    
    func clearType()
    {
        if #available(iOS 13, *) {
            setSearchBarForiOS13()
        }else{
            setSearchBarForiOS12()
        }
    }
    
    func setSearchBarForiOS12() {
        for subView:UIView in self.searchBar.subviews {
            for secondLevSubView in subView.subviews {
                if secondLevSubView.isKind(of: UITextField.self) {
                    if let field = secondLevSubView as? UITextField{
                        field.backgroundColor = .clear
                        field.layer.masksToBounds = true
                        field.layer.cornerRadius = 20
                        field.font = .systemFont(ofSize: 14)
                        field.textColor = .k2F3856
                        field.setValue(UIColor.k000000, forKeyPath: "_placeholderLabel.textColor")
                        field.setValue(UIFont.systemFont(ofSize: 12), forKeyPath: "_placeholderLabel.font")
                    }
                    break
                }
            }
        }
        searchBar.subviews.first?.subviews.first?.removeFromSuperview()
    }
    func setSearchBarForiOS13() {
        for subView:UIView in self.searchBar.subviews {
            for secondLevSubView in subView.subviews {
                if secondLevSubView.isKind(of: UIImageView.self) {
                    secondLevSubView.alpha = 0.0
                    break
                }
            }
        }
        searchBar.barTintColor = .clear
        searchBar.tintColor = .init(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1.0)
        var attr:NSAttributedString!
        if #available(iOS 15, *) {
            var attrNew = AttributedString(placeholder)
            attrNew.foregroundColor = .init(hexString: "ABAAAA")
            attrNew.font = .systemFont(ofSize: 14)
            attr = NSAttributedString(attrNew)
        } else {
            // Fallback on earlier versions
            let attrNew: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 14),
                                                        .foregroundColor: UIColor(hexString: "ABAAAA")!]
            attr = NSAttributedString.init(string: placeholder, attributes: attrNew)
        }
        searchBar.searchTextField.attributedPlaceholder = attr
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.searchTextField.background = nil
    }
}

extension StoreDSelSearchBar:UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        startSearch()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            clearBlock()
        }
    }
    
    func startSearch() {
        let txt = self.searchBar.text ?? ""
        if txt.count == 0 {
            let msg = "先输入\(placeholder ?? "搜索内容")"
//            MBProgressHUD.displayError(msg)
            return
        }
        handlerBlock(txt)
        //释放第一响应者
        self.searchBar.resignFirstResponder()
    }
}
