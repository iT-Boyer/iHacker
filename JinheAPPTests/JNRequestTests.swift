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
@testable import JinheAPP
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
            
            xit("提交晨检拍照信息:SaveMorningCheckImg") {
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
            
            xit("晨检配置：GetMorningCheckSettingByStoreId") {
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
            beforeEach {
                expectation = self.expectation(description: "上传成功")
                serverUrl = JHBaseDomain.fullURL(with: "api_host_upfileserver", path: "/Jinher.JAP.BaseApp.FileServer.SV.FileSV.svc/UploadMobileFile")
                let image = UIImage(named: "mornchecktouxiang")
                imageData = image?.compressedData()
                headers = ["Authentication": "YgAhCMxEehT4N/DmhKkA/M0npN3KO0X8PMrNl17+hogw944GDGpzvypteMemdWb9nlzz7mk1jBa/0fpOtxeZUA==","Content-Type":"form/data"]
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
            
            fit("AF框架上传金和服务器") {
                let expectation = self.expectation(description: "upload should complete")
                // When
                let request = AF.upload(imageData, to: serverUrl, method: .post, headers: headers).response { resp in
                    let json = JSON(resp.data!)
                    print("返回值：\(json)")
                    expectation.fulfill()
                }
                

                self.waitForExpectations(timeout: timeout)
            }
            
            it("AF上传多内容方式") {
                
                let request = AF.upload(multipartFormData: { multipartFormData in
                    multipartFormData.append("test.png", withName: "UploadFileName")
                    multipartFormData.append(true, withName: "IsClient")
                    multipartFormData.append(0, withName: "StartPosition")
                    multipartFormData.append(imageData.length/8, withName: "FileSize")
                    multipartFormData.append(true, withName: "isFromMobilePhone")
                    multipartFormData.append(imageData, withName: "FileDataFromPhone", fileName: "test.png", mimeType: "image/png")
                }, to: serverUrl, method: .post, headers: headers)
                
                request.response { response in
                    //
                }
                
            }
        }
    }
}
