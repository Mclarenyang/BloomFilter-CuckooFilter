//
//  BloomFilter.hpp
//  BloomFilterByCxx
//
//  Created by 杨键 on 2018/7/25.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

#ifndef BloomFilter_hpp
#define BloomFilter_hpp

#include <stdio.h>
#include <cmath>
#include <boost/dynamic_bitset.hpp>
#include <stdlib.h>
#include <string>
#include "md5.hpp"

using namespace std;

class Bloomfilter{
private:
    int bitSetSize;
    boost::dynamic_bitset<> bitset;
    int k;
    int numberOFAddedElements;
    int * bloomHash(string data, int hashNum);
    
public:
    Bloomfilter(double falsePositiveProbability, int expectedNumberOfElements);
    int addElemwnt(string data);
    bool judgeElement(string data);
};

Bloomfilter::Bloomfilter(double falsePositiveProbability, int expectedNumberOfElements){
    this->k = ceil(-(log(falsePositiveProbability) / M_LN2));
    const int m = ceil(-(log2(falsePositiveProbability) / M_LN2 / M_LN2));
    this->bitSetSize = m * expectedNumberOfElements;
    //初始化bit数组大小
    this->bitset.resize(bitSetSize);
}

int * Bloomfilter::bloomHash(string data, int hashNum){
    
    int result[hashNum];
    
    MD5 digest;
    for (int hashTime = 0; hashTime < hashNum; hashTime++) {
        digest.update(&data, hashTime);
        
        const string hashValue = digest.toString();
        int hashResult = 0;
        for (int index = 0; index < 4; index++) {
            string strtocharx = hashValue.substr(index, index * 4 + 8);
            hashResult |= strtol(strtocharx.c_str(), NULL, 16);
        }
        result[hashTime] = hashResult;
    }
    //消除警告
    #pragma clang diagnostic ignored "-Wreturn-stack-address"
    return result;
}

int Bloomfilter::addElemwnt(string data){
    int * hashResult = bloomHash(data, this->k);
    for(int index = 0; index < this->k; index++){
        this->bitset.set(abs(hashResult[index] % this->bitSetSize));
    }
    this->numberOFAddedElements += 1;
    return 0;
}

bool Bloomfilter::judgeElement(string data){
    int * whatTheValue = bloomHash(data, this->k);
    for (int index = 0; index < this->k; index++) {
        if (this->bitset[abs(whatTheValue[index] % this->bitSetSize)] == 0){
            return false;
        }
    }
    return true;
}

#endif /* BloomFilter_hpp */
