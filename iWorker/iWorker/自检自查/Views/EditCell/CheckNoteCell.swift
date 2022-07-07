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
                textView.text = "此处填写\(mm.desc)"
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
        if textView.text == "此处填写\(mm.desc)" {
            textView.textColor = .k2F3856
            textView.text = nil
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        guard let mm = model else { return }
        let placeholder = "此处填写\(mm.desc)"
        if textView.text.isEmpty || textView.text == placeholder {
            textView.textColor = .k99A0B6
            textView.text = placeholder
            model?.note = ""
        }else{
            textView.textColor = .k2F3856
            model?.note = textView.text
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        actionHandler(model)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
