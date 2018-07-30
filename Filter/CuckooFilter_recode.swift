//
//  CuckooFilter_recode.swift
//  Filter
//
//  Created by 杨键 on 2018/7/30.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import Foundation
import CryptoSwift
import Surge

class CuckooFilter_recode: CuckooFilter {
    
    var slotSize: Int!{
        didSet{
            if slotSize != 1{
                //扩容
            }
        }
    }
    
    var fingerArray_recode: Array<Array<String>>
    
    override init(capacity: Int) {
        self.slotSize = 1
        self.fingerArray_recode = [[String]](repeating: [""], count: capacity)
        
        super.init(capacity: capacity)
        self.capacity = capacity
        //        for _ in 0...capacity - 1{
        //            let slot = [""]
        //            fingerArray.append(slot)
        //        }
    }
    
    //hash1 复用
    //hash2 复用
    //fingerPointer 复用
    
    //addElement 重写
    override func addElement(data: String) {
        let baseHash = hash(data: data)
            for index in 0...slotSize - 1 {
            if fingerArray_recode[baseHash][index] == ""{
                fingerArray_recode[baseHash][index] = fingerPointer(data: data)
                return
            }
            if index == slotSize - 1{
                addKickedElement(hash1: baseHash, fingerPoint: fingerPointer(data: data))
            }
        }
        return
    }
    
    //addKickedElement 重写
    override func addKickedElement(hash1: Int, fingerPoint: String) {
        let appendHash = hash_append(fingerPoint: fingerPoint, hash1: hash1)
        for index in 0...slotSize - 1 {
            if fingerArray_recode[appendHash][index] == ""{
                fingerArray_recode[appendHash][index] = fingerPoint
                //阈值
                self.threshold = 0
                return
            }
            if index == slotSize - 1 {
                addKickedElement(hash1: appendHash, fingerPoint: fingerArray![appendHash])
                self.threshold += 1
                if self.threshold > 7{
                    print("数据溢出")
                    return
                }
            }
        }
        return
    }
    
    //judgement
    func judgeElement_recode(data: String) -> (Bool, Int, Int) {
        let fingerpint = fingerPointer(data: data)
        let baseHash = hash(data: data)
        for index in 0...slotSize - 1{
            if fingerArray_recode[baseHash][index] == fingerpint{
                return (true,baseHash,index)
            }
        }
        let appendHash = hash_append(fingerPoint: fingerpint, hash1: baseHash)
        for index in 0...slotSize - 1{
            if fingerArray_recode[appendHash][index] == fingerpint{
                return (true,appendHash,index)
            }
        }
        return (false,-1,-1)
    }
    //delete 重写
    override func deleteElement(data: String) {
        let searchResult = judgeElement_recode(data: data)
        if searchResult.0{
            fingerArray_recode[searchResult.1][searchResult.2] = ""
        }
    }
    
    //append
    func append(oldSlotSize: Int) {
        var newFingerArray = Array<Array<String>>()
        for slot in fingerArray_recode{
            var newSlot = Array<String>()
            for index in 0...slotSize - 1{
                if index < oldSlotSize{
                    newSlot.append(slot[index])
                }else{
                    newSlot.append("")
                }
            }
            newFingerArray.append(newSlot)
        }
        fingerArray_recode = newFingerArray
    }
}






