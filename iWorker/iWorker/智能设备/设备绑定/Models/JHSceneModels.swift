//
//  JHDeviceSceneModel.swift
//  iWorker
//
//  Created by boyer on 2022/3/18.
//
import Foundation

// MARK: - JHDeviceSceneModel
class JHSceneModels:NSObject, Codable {
    var content: [JHSceneModel]?
    var message: String?
    var isSuccess: Bool?
    var code: String?
    var data: Bool?
    var detail: String?
    
    var storeId:String = ""
    var SN:String = ""
    
    init(storeId:String, SN:String) {
        self.storeId = storeId
        self.SN = SN
    }
}

// MARK: - Content
struct JHSceneModel: Codable {
    let iotSceneID: String
    let hardWareDeviceKey: Int
    let iotSceneBind: IOTSceneBind
    let iotClassifyNum: Int
    let iotDeviceTypeID, iotSceneName, iotSceneMonitorName: String

    enum CodingKeys: String, CodingKey {
        case iotSceneID = "IOTSceneId"
        case hardWareDeviceKey = "HardWareDeviceKey"
        case iotSceneBind = "IOTSceneBind"
        case iotClassifyNum = "IOTClassifyNum"
        case iotDeviceTypeID = "IOTDeviceTypeId"
        case iotSceneName = "IOTSceneName"
        case iotSceneMonitorName = "IOTSceneMonitorName"
    }
}

// MARK: - IOTSceneBind
struct IOTSceneBind: Codable {
    let iotSceneThresholds: [IOTSceneThreshold]
    let iotSceneWorkTimes: [IOTSceneWorkTime]

    enum CodingKeys: String, CodingKey {
        case iotSceneThresholds = "IOTSceneThresholds"
        case iotSceneWorkTimes = "IOTSceneWorkTimes"
    }
}

// MARK: - IOTSceneThreshold
struct IOTSceneThreshold: Codable {
    let hardWareDeviceKey, minValue: Int
    let maxValue: Double
    let defaultDelayedValue, defaultOpenValue, defaultOpenValueOperate, defaultMinDuration: Int
    let defaultMinComplete: Int
    let deviceUnit, deviceUnitDesc: String
    let deviceNumberType: Int
    let deviceNumberPrecision: String
    let deviceNormalValue: Int

    enum CodingKeys: String, CodingKey {
        case hardWareDeviceKey = "HardWareDeviceKey"
        case minValue = "MinValue"
        case maxValue = "MaxValue"
        case defaultDelayedValue = "DefaultDelayedValue"
        case defaultOpenValue = "DefaultOpenValue"
        case defaultOpenValueOperate = "DefaultOpenValueOperate"
        case defaultMinDuration = "DefaultMinDuration"
        case defaultMinComplete = "DefaultMinComplete"
        case deviceUnit = "DeviceUnit"
        case deviceUnitDesc = "DeviceUnitDesc"
        case deviceNumberType = "DeviceNumberType"
        case deviceNumberPrecision = "DeviceNumberPrecision"
        case deviceNormalValue = "DeviceNormalValue"
    }
}

// MARK: - IOTSceneWorkTime
struct IOTSceneWorkTime: Codable {
    let startTime, endTime: String

    enum CodingKeys: String, CodingKey {
        case startTime = "StartTime"
        case endTime = "EndTime"
    }
}
