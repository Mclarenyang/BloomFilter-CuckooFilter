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
        
        testBloom()
        testCuckoo()
        
    }
    
    func testBloom() {
        let elementsNum = 100
        let bloomFilter = BloomFilter(falsePositiveProbability: 0.001, expectedNumberOfElements: elementsNum)
        
        //create data
        var elements = [String]()
        for _ in 0..<100{
            elements.append(String(Int(arc4random() % 255) + 1))
        }
        
        var elementsTest = [String]()
        for _ in 0..<100{
            elementsTest.append(String(Int(arc4random() % 255) + 1))
        }
        
        print("----Bloom Test----")
        
        //test add
        for index in 0..<100{
            bloomFilter.addElement(data: elements[index])
        }
        print("添加完毕")
        
        //test judge
        var badNum = 0
        for index in 0..<100{
            if bloomFilter.judgeElement(data: elementsTest[index]){
                badNum += 1
                print("重复数据：\(elementsTest[index])")
            }
        }
        print("共有\(badNum)个重复数据")
        print("----Finish----")
    }
    
    func testCuckoo() {
        
        let cuckooFilter = CuckooFilter(capacity: 2000)
        let randomNum = 50
        
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
        
        for index in 0..<randomNum{
            cuckooFilter.addElement(data: elements[index])
        }
        print("添加完毕")
        
        var badNum = 0
        for index in 0..<randomNum{
            if cuckooFilter.judgeElement(data: elementsTest[index]).0{
                badNum += 1
                print("重复数据：\(elementsTest[index])")
            }
        }
        print("共有\(badNum)个重复数据")
        //print("最大踢出:\(cuckooFilter.maxThreshold)次")
        print("----Finish----")
    
    }
}

