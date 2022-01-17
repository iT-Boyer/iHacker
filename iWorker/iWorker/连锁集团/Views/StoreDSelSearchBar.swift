//
//  StoreDSelSearchBar.swift
//  iWorker
//
//  Created by boyer on 2022/1/12.
//

import UIKit
import MBProgressHUD

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
        var attr = AttributedString(placeholder)
        attr.foregroundColor = .init(hexString: "ABAAAA")
        attr.font = .systemFont(ofSize: 14)
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(attr)
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
        let txt = self.searchBar.text?.count
        guard let txt = self.searchBar.text else {
            let msg = "先输入\(placeholder)"
//            MBProgressHUD.show(msg)
            return
        }
        
        handlerBlock(txt)
        //释放第一响应者
        self.searchBar.resignFirstResponder()
    }
}
