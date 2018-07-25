//
//  main.cpp
//  BloomFilterByCxx
//
//  Created by 杨键 on 2018/7/25.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

#include <iostream>
#include <cstdio>
#include <bitset>
#include <cstdlib>
#include <cmath>
#include <vector>
#include <cstring>
#include "md5.hpp"
#include "BloomFilter.hpp"


using namespace std;
using std::bitset;

typedef unsigned int uint;
#define N 1<<20

int larray[] = {5, 7, 11, 13, 31, 37, 61};
class BloomFilter
{
public:
    BloomFilter(int m, int n):m_m(m), m_n(n)
    {
        m_k = ceil((m/n) * log(2));
    }
    virtual ~BloomFilter()
    {}
    
    uint RSHash(const char *str, int seed);
    void SetKey(const char* str);
    int VaryExist(const char* str);
    
private:
    int m_k, m_m, m_n; //k:number of the hash functions //m:the size of bitset //n:number of strings to hash (k = [m/n]*ln2)
    bitset<N> bit;
};


uint BloomFilter::RSHash(const char *str, int seed)
{
    //unsigned int b = 378551;
    uint a = 63689;
    uint hash = 0;
    
    while (*str)
    {
        hash = hash * a + (*str++);
        a *= seed;
    }
    
    return (hash & 0x7FFFFFFF);
}

void BloomFilter::SetKey(const char* str)
{
    int *p = new int[m_k+1];
    memset(p, 0, sizeof(p)/sizeof(int));
    for(int i=0;i<m_k;++i)
    {
        p[i] = static_cast<int>(RSHash(str, larray[i]))%1000000;
    }
    
    for(int j=0;j<m_k; ++j)
    {
        bit[p[j]] = 1;
    }
    delete[] p;
}

int BloomFilter::VaryExist(const char* str)
{
    int res = 1;
    int *p = new int[m_k+1];
    memset(p, 0, sizeof(p)/sizeof(int));
    for(int i=0;i<m_k;++i)
    {
        p[i] = static_cast<int>(RSHash(str, larray[i]))%1000000;
    }
    
    for(int j=0;j<m_k;++j)
    {
        res &= bit[p[j]];
        if(!res)
        {
            delete[] p;
            return 0;
        }
    }
    delete[] p;
    return 1;
}

int main(int argc, const char * argv[]) {
//    BloomFilter bf(5, 2);
//    string str = "hahahehe";
//    string str2 = "sdfasfa";
//    bf.SetKey(str.c_str());
//    int res = bf.VaryExist(str.c_str());
//
//    if(res)
//        cout << "exist" << endl;
//    else
//        cout << "not exist" << endl;
//
//    //bf.SetKey(str2.c_str());
//    res = bf.VaryExist(str2.c_str());
//    if(res)
//        cout << "exist" << endl;
//    else
//        cout << "not exist" << endl;
    
    const string testStr = "test_str";
    const int hashNum = 5;
    
    MD5 digest;
    for (int hashTime = 0; hashTime < hashNum; hashTime++) {
        digest.update(&testStr, hashTime);
        
        cout << &"time:" [ hashTime ] << endl;
        cout << digest.toString() << endl;
    }
    
    
    return 0;
}









