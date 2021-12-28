//
//  JNRequestTests.swift
//  iHacker
//
//  Created by boyer on 2021/12/21.
//  
//
import Foundation
import Quick
import Nimble
import JHBase
import OHHTTPStubs
import OHHTTPStubsSwift
import SwiftyJSON
@testable import iWorker
import XCTest
import Alamofire

class JNRequestTests: QuickSpec {
    override func spec() {
        describe("访问接口解析") {
            // 模拟数据接口
            var expectation:XCTestExpectation!
            beforeEach {
                installOHHTTPStubs()
                expectation = self.expectation(description: "token认证")
            }
            
            it("提交晨检拍照信息:SaveMorningCheckImg") {
                let urlStr = JHBaseDomain.fullURL(with: "api_host_ripx", path: "/api/MorningCheck/SaveMorningCheckImg")
                let request = JN.post(urlStr, parameters: [:])
                request.response { response in
                    //
                    let json = JSON(response.data!)
                    let success = json["IsSuccess"].boolValue
                    if success {
                        print("提交晨检拍照信息成功")
                    }else{
                        print("提交晨检拍照信息失败")
                    }
                    //在异步方法被测试的相关的回调中实现那个期望值
                    expectation.fulfill()
                }
                self.waitForExpectations(timeout: 20, handler: { error in
                    //
                    print("错误信息:\(String(describing: error?.localizedDescription))")
                })
            }
            
            it("晨检配置：GetMorningCheckSettingByStoreId") {
                let urlStr = JHBaseDomain.fullURL(with: "api_host_ripx", path: "/api/MorningCheck/GetMorningCheckSettingByStoreId")
                let request = JN.post(urlStr, parameters: [:])
                request.response { response in
                    //
                    let json = JSON(response.data!)
                    let success = json["IsSuccess"].boolValue
                    if success {
                        let stepCode:[String] = json["Content"]["StepCode"].rawValue as! [String]
                        print("配置：\(stepCode)")
                    }else{
                        print("响应失败")
                    }
                    //在异步方法被测试的相关的回调中实现那个期望值
                    expectation.fulfill()
                }
                self.waitForExpectations(timeout: 20, handler: { error in
                    //
                    print("错误信息:\(String(describing: error?.localizedDescription))")
                })
            }
        }
        
        describe("上传金和图片") {
            var serverUrl:String!
            var imageData:Data!
            var expectation:XCTestExpectation!
            var headers:HTTPHeaders!
            var params:[String:Data]!
            beforeEach {
                expectation = self.expectation(description: "上传成功")
                serverUrl = JHBaseDomain.fullURL(with: "api_host_upfileserver", path: "/Jinher.JAP.BaseApp.FileServer.SV.FileSV.svc/UploadMobileFile")
                let image = UIImage(named: "morncheckcamerabtn")
                imageData = image?.compressedData()
                headers = ["Authentication": "YgAhCMxEehT4N/DmhKkA/M0npN3KO0X8PMrNl17+hogw944GDGpzvypteMemdWb9nlzz7mk1jBa/0fpOtxeZUA==","Content-Type":"form/data"]
                
                let dics:[String:Any] = ["UploadFileName":"test.png",
                                             "IsClient":"1",
                                             "StartPosition":imageData.count/8,
                                             "FileSize":"1",
                                             "isFromMobilePhone":"1"
                ]
                
                params = createParameterDictionary(parameters: dics)
            }
            
            xit("上传图片接口联调") {
                let request = JN.upload(imageData!, url: serverUrl)
                request.response { response in
                    let json = JSON(response.data!)
                    print("返回值：\(json)")
                    //在异步方法被测试的相关的回调中实现那个期望值
                    expectation.fulfill()
                }
                self.waitForExpectations(timeout: timeout)
            }
            
            xit("AF框架上传金和服务器") {
                let expectation = self.expectation(description: "upload should complete")
                // When
                let request = AF.upload(imageData, to: serverUrl, method: .post, headers: headers).response { resp in
                    let json = JSON(resp.data!)
                    print("返回值：\(json)")
                    expectation.fulfill()
                }
                self.waitForExpectations(timeout: timeout)
            }
            
            fit("AF上传多内容方式") {
                
                AF.upload(multipartFormData: { multipartFormData in
                    // params相关入参，不影响图片正常上传
                    for (key, value) in params {
                        multipartFormData.append(value, withName: key)
                    }
                    if let data = imageData{
                        multipartFormData.append(data, withName: "FileDataFromPhone", fileName: "\(Date().timeIntervalSince1970).png", mimeType: "image/png")
                    }
                }, to: serverUrl, method: .post, headers: headers).responseJSON { response in
                    
//                    print(response)
                    
                    if let err = response.error{
                        print(err)
                        return
                    }
                    print("Succesfully uploaded")
                    
                    let json = response.data
                    
                    if (json != nil)
                    {
                        let jsonObject = JSON(json!)
                        print(jsonObject)
                        let filePath = jsonObject["FilePath"].string
                        let fileUrl = JHBaseDomain.fullURL(with: "api_host_upfileserver", path: "/Jinher.JAP.BaseApp.FileServer.UI/FileManage/GetFile?fileURL=\(filePath!)")
                        print("文件服务器路径：\(fileUrl)")
                    }
                    expectation.fulfill()
                }
                self.waitForExpectations(timeout: timeout)
            }
            
            func createParameterDictionary(parameters:[String:Any]) -> [String: Data]? {
                var params: [String: Data] = [:]
                for (key, value) in parameters {
                    if let temp = value as? String {
                        params[key] = temp.data(using: .utf8)!
                    }
                    if let temp = value as? Int {
                        params[key] = "\(temp)".data(using: .utf8)!
                    }
                    if let temp = value as? NSArray {
                        temp.forEach({ element in
                            let keyObj = key + "[]"
                            if let string = element as? String {
                                params[keyObj] = string.data(using: .utf8)!
                            } else
                            if let num = element as? Int {
                                params[keyObj] = "\(num)".data(using: .utf8)!
                            }
                        })
                    }
                }
                
                return params
            }
        }
    }
}
