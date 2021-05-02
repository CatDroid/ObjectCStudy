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
    return 0;
}
