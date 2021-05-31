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
        CRobot* p1 = [[CRobot alloc] initId:__LINE__];
        CRobot* p2 = [[CRobot alloc] initId:__LINE__ withModel:@(__func__)];
        
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
        
        CRobotSoldier* cs1 = [[CRobotSoldier alloc] initId:__LINE__ withModel:@(__func__)]; // Unknown receiver 'CRobotSoilder';
        [cs1 goHome];
        [cs1 moveToX:-666 Y:-888];
        
        if ([cs1 conformsToProtocol:@protocol(CRobotProtocol)])
        {
            // 如果声明了协议 但是没有真正实现协议 运行报错
            // 'NSInvalidArgumentException',
            // reason: '-[CRobotSoldier recoveryToX:Y:]: unrecognized selector sent to instance 0x103204c70'
            NSLog(@"conformsToProtocol YES");
            if ([cs1 respondsToSelector:@selector(recoveryToX:Y:)])
            {
                // 判断协议的方法是否实现还是用 respondsToSelector
                [cs1 recoveryToX:-1 Y:-1];
                NSLog(@"implement noImplementProtocolMethod? %s" , [cs1 respondsToSelector:@selector(noImplementProtocolMethod)]?"YES":"NO");
            }
            else
            {
                NSLog(@"respondsToSelector NO");
            }
        }
        else
        {
            NSLog(@"conformsToProtocol NO");
        }
        
        // 判断协议中的方法是否实现
        if ([cs1 respondsToSelector:@selector(fire)])
        {
            [cs1 performSelector:@selector(fire)];
        }
        else
        {
            NSLog(@"respondsToSelector NO");
        }
      
        {
            CRobotSoldier* cCopy1 = [cs1 copy];
            NSLog(@">>>>> origin %@", cs1);
            NSLog(@">>>>> copied %@", cCopy1);
        }
        
        extern void secondary();
        secondary();
        
        extern void third();
        third();
        
        extern void typeEncode();
        typeEncode();
        
    }
    return 0;
}
