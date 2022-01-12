//
//  StoreDSelSearchBar.swift
//  iWorker
//
//  Created by boyer on 2022/1/12.
//

import UIKit

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
    
}

extension StoreDSelSearchBar:UITextFieldDelegate
{
    
}
