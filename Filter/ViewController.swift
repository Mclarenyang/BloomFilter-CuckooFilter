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
        for index in 0..<randomNum{
            bloomFilter.addElement(data: elements[index])
        }
        print("-添加完毕-")
        
        //test judge
        var badNum = 0
        for index in 0..<randomNum{
            if bloomFilter.judgeElement(data: elementsTest[index]){
                badNum += 1
                print("重复数据：\(elementsTest[index])")
            }
        }
        print("共有\(badNum)个重复数据")
        print("----Finish----")
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
        
        for index in 0..<randomNum{
            cuckooFilter.addElement(data: elements[index])
        }
        print("-添加完毕-")
        
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
    
    func testCuckoo_recode() {
        
        let cuckooFilter = CuckooFilter_recode(capacity: 10)
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
        
        for index in 0..<randomNum{
            cuckooFilter.addElement(data: elements[index])
        }
        print("添加完毕")
        
        var badNum = 0
        for index in 0..<randomNum{
            if cuckooFilter.judgeElement_recode(data: elementsTest[index]).0{
                badNum += 1
                print("重复数据：\(elementsTest[index])")
            }
        }
        print("共有\(badNum)个重复数据")
        print("----Finish----")
        
    }
}

