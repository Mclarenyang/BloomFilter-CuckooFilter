//
//  ViewController.swift
//  Filter
//
//  Created by 杨键 on 2018/7/16.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let queue = DispatchQueue(label: "filter.mclarenyang", attributes: .concurrent)
        queue.async {
            //self.testBloom()
            //self.testCuckoo()
            self.testCuckoo_recode()
        }
        
    }
    
    func testBloom() {
        let elementsNum = 50
        let bloomFilter = BloomFilter(falsePositiveProbability: 0.001, expectedNumberOfElements: elementsNum)
        
        //create data
        let randomNum = 50
        var elements = [String]()
        for _ in 0..<randomNum{
            elements.append(String(Int(arc4random() % 255) + 1))
        }
        
        var elementsTest = [String]()
        for _ in 0..<randomNum{
            elementsTest.append(String(Int(arc4random() % 255) + 1))
        }
        
        print("----Bloom Test----")
        
        //test add
        let addStartTime = Date()
        for index in 0..<randomNum{
            bloomFilter.addElement(data: elements[index])
        }
        let addEndTime = Date()
        
        //test judge
        var badNum = 0
        let judgeStartTime = Date()
        for index in 0..<randomNum{
            if bloomFilter.judgeElement(data: elementsTest[index]){
                badNum += 1
                print("重复数据：\(elementsTest[index])")
            }
        }
        let judgeEndTime = Date()
        print("共有\(badNum)个重复数据")
        print("----Finish----")
        
        
        //性能数据
        timeTest(randomNum: randomNum ,addStartTime: addStartTime, addEndTime: addEndTime, judgeStartTime: judgeStartTime, judgeEndTime: judgeEndTime)
    }
    
    func testCuckoo() {
        
        let cuckooFilter = CuckooFilter(capacity:2000)
        let randomNum = 500
        
        //create data
        var elements = [String]()
        for _ in 0..<randomNum{
            elements.append(String(Int(arc4random() % 254) + 1))
        }
        
        var elementsTest = [String]()
        for _ in 0..<randomNum{
            elementsTest.append(String(Int(arc4random() % 254) + 1))
        }
        
        print("----Cuckoo test----")
        let addStartTime = Date()
        for index in 0..<randomNum{
            cuckooFilter.addElement(data: elements[index])
        }
        let addEndTime = Date()
        
        var badNum = 0
        let judgeStartTime = Date()
        for index in 0..<randomNum{
            if cuckooFilter.judgeElement(data: elementsTest[index]).0{
                badNum += 1
                print("重复数据：\(elementsTest[index])")
            }
        }
        let judgeEndTime = Date()
        print("共有\(badNum)个重复数据")
        print("----Finish----")
        
        //性能数据
        timeTest(randomNum: randomNum ,addStartTime: addStartTime, addEndTime: addEndTime, judgeStartTime: judgeStartTime, judgeEndTime: judgeEndTime)
    }
    
    func testCuckoo_recode() {
        
        let cuckooFilter = CuckooFilter_recode(capacity: 20)
        let randomNum = 100
        
        //create data
        var elements = [String]()
        for _ in 0..<randomNum{
            elements.append(String(Int(arc4random() % 254) + 1))
        }
        
        var elementsTest = [String]()
        for _ in 0..<randomNum{
            elementsTest.append(String(Int(arc4random() % 254) + 1))
        }
        
        print("----Cuckoo_recode test----")
        let addStartTime = Date()
        for index in 0..<randomNum{
            cuckooFilter.addElement(data: elements[index])
        }
        let addEndTime = Date()
        
        var badNum = 0
        let judgeStartTime = Date()
        for index in 0..<randomNum{
            if cuckooFilter.judgeElement_recode(data: elementsTest[index]).0{
                badNum += 1
                print("重复数据：\(elementsTest[index])")
            }
        }
        let judgeEndTime = Date()
        print("共有\(badNum)个重复数据")
        
        //删除
        let deleteNum = 5
        let deleteStartTime = Date()
        for _ in 0..<deleteNum {
            _ = cuckooFilter.deleteElement(data: elements[Int(arc4random() % UInt32(randomNum))])
        }
        let deleteEndTime = Date()
        
        print("----Finish----")
        
        //性能数据
        timeTest(randomNum: randomNum ,addStartTime: addStartTime, addEndTime: addEndTime, judgeStartTime: judgeStartTime, judgeEndTime: judgeEndTime)
        let deleteTimeDiscrepancy = deleteEndTime.timeIntervalSince1970 - deleteStartTime.timeIntervalSince1970
        let deleteTimeDiscrepancy_average = deleteTimeDiscrepancy / Double(deleteNum) * 1000
        print("删除平均：\(deleteTimeDiscrepancy_average)ms/element")
        
    }
    
    
    func timeTest(randomNum: Int, addStartTime: Date, addEndTime: Date, judgeStartTime: Date, judgeEndTime: Date){
        let addTimeDiscrepancy = addEndTime.timeIntervalSince1970 - addStartTime.timeIntervalSince1970
        let addTimeDiscrepancy_average = addTimeDiscrepancy / Double(randomNum) * 1000
        let judgeTimeDiscrepancy = judgeEndTime.timeIntervalSince1970 - judgeStartTime.timeIntervalSince1970
        let judgeTimeDiscrepancy_average = judgeTimeDiscrepancy / Double(randomNum) * 1000
        print("添加平均：\(addTimeDiscrepancy_average)ms/element")
        print("判断平均：<=\(judgeTimeDiscrepancy_average)ms/element")
    }

}

