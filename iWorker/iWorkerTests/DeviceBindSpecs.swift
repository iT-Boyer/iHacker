//
//  DeviceBindSpecs.swift
//  iWorker
//
//  Created by boyer on 2022/3/22.
//  
//

import Quick
import Nimble
import JHBase
import SwiftyJSON
@testable import iWorker

// 设备场景
// 绑定设备
// 删除设备

class DeviceBindSpecs: QuickSpec {
    override func spec() {
        describe("解析接口数据") {
            
            beforeEach {
                installOHHTTPStubs()
            }
            
            it("设备场景") {
                waitUntil(timeout: .seconds(5)) { done in
                    let urlStr = JHBaseDomain.fullURL(with: "api_host_ripx", path: "/IOTDeviceScene/GetIOTDeviceSceneList")
                    let requestDic = ["StoreId":"storeId", "SN": "SN"]
                    let request = JN.post(urlStr, parameters: requestDic, headers: nil)
                    request.response { resp in
                        guard let data = resp.data else { return }
                        let json = JSON(data)
                        let result = json["IsSuccess"].boolValue
                        if result {
                            let scene:JHSceneModels = JHSceneModels.parsed(data: data)
                            print("\(scene.message)")
                        }else{
                            
                        }
                        done()
                    }
                }
            }
            
        }
    }
}
