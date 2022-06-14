//
//  ArraySpecs.swift
//  iWorker
//
//  Created by boyer on 2022/6/14.
//  
//

import Quick
import Nimble
@testable import iWorker

class ArraySpecs: QuickSpec {
    
    override func spec() {
        describe("数据元素交换") {
            
            beforeEach {
                
            }
            it("交换数据元素位置") {
                var simpleArray = [1,2,3,4,5]
                // 交换
                //        dataArray.exchangeObject(at: sourceIndexPath.row, withObjectAt: destinationIndexPath.row)
                //        swap(&dataArray[sourceIndexPath.row], &dataArray[destinationIndexPath.row])
                simpleArray.swapAt(1, 4)
                print(simpleArray)
            }
            
            it("移动数组元素到指定位置") {
                var simpleArray = [1,2,3,4,5]
                simpleArray.move(fromOffsets: IndexSet.init(integer: 0), toOffset: 5)
                print(simpleArray)
            }
        }
    }
}
