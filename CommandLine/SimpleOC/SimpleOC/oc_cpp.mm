//
//  oc_cpp.m
//  SimpleOC
//
//  Created by hehanlong on 2021/5/2.
//

#import <Foundation/Foundation.h>



// .m 是 OC和C 混编
// .mm 是 OC和C++ 混编
void swapByRef(int& a, int& b) // 引用 只能在mm文件中使用/C++的语法
{
    int c = a;
    a = b ;
    b = c ;
}

// 导出C方法给 m文件使用
extern "C"
void swapByAddress(int* a, int* b)
{
    swapByRef(*a, *b);
}

