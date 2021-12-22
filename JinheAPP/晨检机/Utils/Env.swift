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
    stub(condition: isHost(host)||isHost(host2)) { request in
      // Stub it with our "wsresponse.json" stub file
        let urlStr = request.url?.path
        let fileName = urlStr!.lastPathComponent+".json"
        
        let stubReponse = HTTPStubsResponse(
            fileAtPath: OHPathForFile(fileName, JHMornInspecterController.self)!,
            statusCode: 200,
            headers: ["Content-Type":"application/json"]
        )
        // 模拟弱网
        stubReponse.requestTime(1, responseTime: 2)
        return stubReponse
    }
}
