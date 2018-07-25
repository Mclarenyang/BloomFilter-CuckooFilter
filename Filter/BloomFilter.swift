//
//  BloomFilter.swift
//  Filter
//
//  Created by 杨键 on 2018/7/16.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import Foundation
import CryptoSwift
import Surge

class BloomFilter {
    
    var bitSetSize: Int?
    var bitSet: [Bit]?
    var k: Int?     //numbers of hash func
    var numberOfAddedElements: Int = 0
    
    //使用误判率及数据总量init
    init(falsePositiveProbability: Double, expectedNumberOfElements: Int) {
        self.k = Int(Surge.ceil(-(Surge.log(falsePositiveProbability) / M_LN2)))
        let m = Int(Surge.ceil(-Surge.log2(falsePositiveProbability) / M_LN2 / M_LN2)) * expectedNumberOfElements
        //let m = Int(Surge.ceil(-Surge.log2(falsePositiveProbability) / M_LN2 / M_LN2))
        self.bitSetSize = m * expectedNumberOfElements
        self.bitSet = [Bit](repeating: Bit.zero, count: bitSetSize!)
    }
    
    //hash （data/String）->  /salt/ array<hashValue> ---> bitse(hash % bitSetSize)
    public func hash(data: String, hashNum: Int) -> [Int]{
        var result = [Int]()
        
        for i in 0..<hashNum{
            do{
                var digest = MD5()
                _ = try digest.update(withBytes: [UInt8((data as NSString).intValue) , UInt8(i)])
                let hashValue = try digest.finish().toHexString()
                
                //String 截断转换
                var hashResult = 0
                for index in 0..<4{
                    let indexHead = hashValue.index(hashValue.startIndex, offsetBy: index * 4)
                    let indexBottom = hashValue.index(hashValue.startIndex, offsetBy: index * 4 + 8)
                    hashResult |= Int(hashValue[indexHead..<indexBottom], radix: 16)!
                }
                result.append(hashResult)
            }catch {
                print("error:\(error)")
            }
        }
        return result
    }
    
    //addElement
    public func addElement(data: String){
        for hashValue in hash(data: data, hashNum: self.k!) {
            self.bitSet![abs(hashValue % self.bitSetSize!)] = Bit.one
        }
        self.numberOfAddedElements += 1
    }
    
    //judgeElement -> bool
    public func judgeElement(data: String) -> Bool{
        let whatTheValue = hash(data: data, hashNum: self.k!)
        for hashValue in whatTheValue {
            if self.bitSet![abs(hashValue % self.bitSetSize!)] == Bit.zero{
                return false
            }
        }
        return true
    }
    
}
