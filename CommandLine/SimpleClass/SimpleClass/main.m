//
//  main.m
//  SimpleClass
//
//  Created by hehanlong on 2021/5/3.
//

#import <Foundation/Foundation.h>
#import "CRobot.h"
#import "CRobotSoldier.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        //CRobot* p0 = [[CRobot alloc] init]; // 'init' is unavailable  NS_UNAVAILABLE
        CRobot* p1 = [[CRobot alloc] initId:123];
        CRobot* p2 = [[CRobot alloc] initId:124 withModel:@"Model-2"];
        
        [p1 goHome];
        [p2 goHome];
        
        NSLog(@"p1 is pass ? %i", p1.pass); // 计算属性 会使用实例变量存储
        
        p1.pass = true;
        p2.pass = true ;
        
        NSLog(@"p2(%@) is pass ? %i", p2, p2.pass);
        
        // 不可见 编译时候错误
        // [p1 MoveToX:12 Y:13]; // No visible  如果函数只是在implementation中声明和定义 默认是私有的
        
        // 没有实现 运行时候崩溃
        //[p1 noImplemetationMethon]; // unrecognized selector sent to instance
        
        CRobotSoldier* cs1 = [[CRobotSoldier alloc] initId:125 withModel:@"Model-3"]; // Unknown receiver 'CRobotSoilder';
        [cs1 goHome];
        [cs1 moveToX:-666 Y:-888];
        
        
        
    }
    return 0;
}
