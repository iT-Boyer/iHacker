//
//  Jinhe_env.swift
//  JinheAPP
//
//  Created by boyer on 2021/12/22.
//

import Foundation
import OHHTTPStubs
import OHHTTPStubsSwift
import JHBase
// 模拟数据
func installOHHTTPStubs(){
    let host = JHBaseDomain.domain(for: "api_host_ebc")
    let host2 = JHBaseDomain.domain(for: "api_host_ripx")
    let host3 = JHBaseDomain.domain(for: "api_host_patrol")
    let host4 = JHBaseDomain.domain(for: "api_host_imv")
    stub(condition: isHost(host)
                    || isHost(host2)
                    || isHost(host3)
                    || isHost(host4))
    { request in
      // Stub it with our "wsresponse.json" stub file
        let urlStr = request.url?.path
        let fileName = urlStr!.lastPathComponent+".json"
        let filePath = OHPathForFile(fileName, JHMornInspecterController.self)!
        let stubReponse = HTTPStubsResponse(
            fileAtPath: filePath,
            statusCode: 200,
            headers: ["Content-Type":"application/json"]
        )
        // 模拟弱网
        stubReponse.requestTime(1, responseTime: 2)
        return stubReponse
    }
}
