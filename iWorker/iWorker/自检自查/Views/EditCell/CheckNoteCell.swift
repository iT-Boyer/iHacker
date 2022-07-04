//
//  CheckNoteCell.swift
//  iWorker
//
//  Created by boyer on 2022/7/1.
//

import UIKit

class CheckNoteCell: CheckEditBaseCell {

    override var model: CheckEditCellVM?{
        willSet{
            guard let mm = newValue else { return }
            if !mm.note.isEmpty {
                textView.text = mm.note
                textView.textColor = .k2F3856
            }else{
                textView.textColor = .k99A0B6
                textView.text = "此处填写\(mm.desc ?? "备注")"
            }
        }
    }
    
    override func updateUI() {
        iconView.image = .init(named: "Inspect备注")
        actionView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.left.top.bottom.right.equalToSuperview()
        }
    }
    
    lazy var textView: UITextView = {
        let tv = UITextView()
        tv.delegate = self
        return tv
    }()
}

extension CheckNoteCell:UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard let mm = model else { return }
        if textView.text == "此处填写\(mm.desc ?? "备注")" {
            textView.textColor = .k2F3856
            textView.text = nil
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        guard var mm = model else { return }
        if !textView.text.isEmpty{
            textView.textColor = .k2F3856
            mm.note = textView.text
            actionHandler(mm)
        }else{
            textView.textColor = .k99A0B6
            textView.text = "此处填写\(mm.desc ?? "备注")"
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
