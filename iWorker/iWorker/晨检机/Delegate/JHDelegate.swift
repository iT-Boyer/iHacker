//
//  JHDelegate.swift
//  JinheAPP
//
//  Created by boyer on 2021/12/21.
//

import Foundation

protocol JHMornUploadPhotoDelegate:NSObject{
    func afterUpload(_ imgmodel:[JHMornUploadModel], complated:Bool)
}

