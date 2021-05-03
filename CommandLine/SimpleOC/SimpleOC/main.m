//
//  main.m
//  SimpleOC
//
//  Created by hehanlong on 2021/5/2.
//


#import <Foundation/Foundation.h>

//#include "NoProtectHeader.h"
//#include "NoProtectHeader.h" // Redefinition of 'SDate'

#import "NoProtectHeader.h"
#import "NoProtectHeader.h" // it's ok

int GetRandomNumberFrom(int from, int to)
{
    return arc4random() / (from - to + 1) + from;
}

enum _PROCESS_TYPE
{
    TYPE_NOTHING,
    TYPE_ADD,
    TYPE_MIN,
};

typedef enum _PROCESS_TYPE PROCESS_TYPE;


int processData(int (^processFtn)(int,int), int data1, int data2 )
{
    return processFtn(data1, data2);
}

typedef int(^PROCESS_FTN)(int, int ); // block作为函数的返回值 必须要用typedef

// Block的定义格式. 返回值类型(^block变量名)(形参列表) = ^(形参列表) { }
// typedef void (^T)(void);
// T f() {
//  return ^{};
// }
PROCESS_FTN getFtn(PROCESS_TYPE procType)
{
    switch (procType)
    {
        case TYPE_NOTHING:
        case TYPE_ADD:
        {
            // block/块   一个 "块的定义" 赋值给 一个 "块变量"
            int (^AddFtn)(int, int) = ^int(int num1, int num2)
            {
                return num1 + num2 ;
            };
            return AddFtn ;
        }
        case TYPE_MIN:
        {
            int (^ minFtn) (int, int) = ^int(int num1, int num2)
            {
                return num1 - num2 ;
            };
            return minFtn;
        }
        
    }
}

typedef double (^DOU_FTN) (double num1, double num2);


DOU_FTN getClosure(double upValue)
{
    __block double test = upValue ;
    double (^ftn) (double, double) = ^double(double n1, double n2)
    {
        test ++; // 如果需要修改 upvalue 就需要用 __block 修饰变量。如果只是读取就不需要
        return n1 + n2 + test;
    };
    
    test++; // 会影响block函数调用时候的值
    
    return ftn ;
}
 



int main(int argc, const char * argv[]) {
    //@autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        // NSLog(@"argc = %@", argc); // %@ 调用description 必须实现id协议 调用对象的description方法  EXC_BAD_ACCESS
        NSLog(@"argc = %d", argc);
        NSLog(@"argv[0] = %s", argv[0]);
    //}
    
    
    {
        NSInteger x = 1 ;
        x += 2 ;
        NSLog(@"NSInteger += %li ", x);
        //NSLog(@"NSInteger %@", x);
    }
    
    
    {
        // rand()和random()实际并不是一个真正的伪随机数发生器，在使用之前需要先初始化随机种子，否则每次生成的随机数一样
        //
        // 是一个真正的伪随机算法，不需要生成随机种子，因为第一次调用的时候就会自动生成。而且范围是rand()的两倍
        // 范围是rand()的两倍。在iPhone中，RAND_MAX是0x7fffffff (2147483647)，而arc4random()返回的最大值则是 0x100000000 (4294967296)
        
        // https://man.openbsd.org/arc4random.3
        // The arc4random() function returns a single 32-bit value.
        //
        int x = arc4random() % 100; // [0,100)
        
        int x100 = arc4random() % (100 + 1); // [0,100]

        int xFromTo = arc4random() % (100 + 1) + 200 ; // [0+200, 100+200] = [200,300] 闭合区间
        
        NSLog(@"arc4random [0,100) = %i [0,100] = %i [200,300] = %i GetRandomNumberFrom(500,600) %i",
              x, x100, xFromTo, GetRandomNumberFrom(500, 600) );
        
    }
    
    {
        BOOL flag = TRUE ;
        NSLog(@"OC中TRUE FLASE是个宏定义 1/0  %i", flag);
    }
    
    {
        SDate a;
        NSLog(@"%i", a.day);
    }
    
    {
        NSInteger i = 24 ; // 在32bit上是int 在64bit上是long int 都是32bit的。NSInteger只是Typedef
        i += 26;
        NSLog(@"add sum = %li", i ); // 在64bit上 应该用%li
    }
    
    {
        CGFloat thisIsDouble = 3.4 ; // Core Graphic 在32bit是float 64bit上double
        NSInteger typeNarrowing = thisIsDouble ;
        NSLog(@"CGfloat(Double) %f int %li", thisIsDouble, typeNarrowing);
        
        //float base = 3.4 ;
        // int i = base % 3 ; // Invalid operands to binary expression ('float' and 'int') 浮点数不能求余
        
    }
    
    {
        int charA = (int)'A';
        NSLog(@"int of 'A' %i", charA);
    }
    
    {
        extern void swapByAddress(int* a, int* b);
        int a = 1 ;
        int b = 2 ;
        swapByAddress(&a, &b); // Implicit declaration of function 'swapByRef' is invalid in C99
        NSLog(@"swap %i %i", a, b);
    }
    

    {
        int (^ftn)(int,int) = getFtn(TYPE_ADD);
        int (^ftn2)(int,int) = getFtn(TYPE_MIN);
        int result = ftn2(ftn(12, 13),15);
        NSLog(@"block ftn result is = %i", result);
    }
    
    {
        // 闭包
        double (^dFtn) (double, double) =  getClosure(12.0);
        double result = dFtn(11.5, 5.5);
        NSLog(@"closure is %f", result);
    }
    
    
    {
 
        typedef int (^FTN) (int d1, int(^pre)(int));
        
        int offset = 2 ;
        //__block int offset = 2 ; // 如果不加block 那么创建begin的时候 upvalue固定是 2 不会受到后面的影响
        int (^begin)(int) = ^int(int d1)
        {
            return d1 + offset;
        };
        
        FTN mul = ^int(int d1, int(^pre)(int))
        {
            int result = pre(d1);
            return result * 2 ;
        };
        
        offset = 4 ;
        int result = mul(12, begin);
        NSLog(@"block作为参数 %i", result); // 如果加上修饰符__block就是32 不加就是28
        
    }
    
    return 0;
}
