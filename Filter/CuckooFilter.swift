//
//  CuckooFilter.swift
//  Filter
//
//  Created by 杨键 on 2018/7/17.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import Foundation
import CryptoSwift
import Surge

class CuckooFilter {
    
    var capacity:Int?
    var threshold = 0
    //var maxThreshold = 0
    var fingerArray: [String]!
    
    init(capacity:Int) {
        self.capacity = capacity
        fingerArray = [String](repeating: "", count: capacity)
    }
    
    //hash1 key -> hash1(key) = 存放的数组index
    public func hash(data: String) -> Int{
        
        let hashValue = data.md5()
        //String 截断转换
        var hashResult = 0
        for index in 0..<4{
            let indexHead = hashValue.index(hashValue.startIndex, offsetBy: index * 4)
            let indexBottom = hashValue.index(hashValue.startIndex, offsetBy: index * 4 + 8)
            hashResult += Int(hashValue[indexHead..<indexBottom], radix: 16)!
        }
        let dataLocation = abs(hashResult % self.capacity!)
        return dataLocation
    }
    //hashFP key -> fingerPrint
    public func fingerPointer(data: String) -> String{
        return data.sha1()
    }
    
    //反向求hash2 hash1(fingerPrint) xor hash1(key)
    public func hash_append(fingerPoint: String, hash1: Int) -> Int{
        let dataLocation = (hash(data: fingerPoint) ^ hash1) % self.capacity!
        return dataLocation
    }
    
    //addElement
    public func addElement(data: String){
        let baseHash = hash(data: data)
        if fingerArray![baseHash] != "" {
            addKickedElement(hash1: baseHash, fingerPoint: fingerPointer(data: data))
        }else{
            fingerArray![baseHash] = fingerPointer(data: data)
        }
    }
    
    //addKickedElement
    public func addKickedElement(hash1:Int, fingerPoint:String){
        let appendHash = hash_append(fingerPoint: fingerPoint, hash1: hash1)
        if fingerArray![appendHash] != "" {
            addKickedElement(hash1: appendHash, fingerPoint: fingerArray![appendHash])
            self.threshold += 1 //可以在这里判断扩容
            if self.threshold > 7{
                print("数据溢出")
                return
            }
        }else{
            self.threshold = 0
        }
        fingerArray![appendHash] = fingerPoint
        
    }
    
    //judgeElement
    public func judgeElement(data:String) -> (Bool,Int){
        let fingerpint = fingerPointer(data: data)
        let baseHash = hash(data: data)
        if fingerArray![baseHash] == fingerpint {
            return (true,baseHash)
        }else{
            let appendHash = hash_append(fingerPoint: fingerpint, hash1: baseHash)
            if fingerArray![appendHash] == fingerpint {
                return (true,appendHash)
            }
        }
        return (false,-1)
    }
    
    //delete
    public func deleteElement(data: String){
        let searchResult = judgeElement(data: data)
        if searchResult.0{
            fingerArray![searchResult.1] = ""
        }
    }
}
