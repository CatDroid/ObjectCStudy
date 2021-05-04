//
//  main.m
//  SimpleClass
//
//  Created by hehanlong on 2021/5/3.
//

#import <Foundation/Foundation.h>
#import "CRobot.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        //CRobot* p0 = [[CRobot alloc] init]; // 'init' is unavailable  NS_UNAVAILABLE
        CRobot* p1 = [[CRobot alloc] initId:123];
        CRobot* p2 = [[CRobot alloc] initId:124 withModel:@"Model2"];
        
        [p1 goHome];
        [p2 goHome];
        
        NSLog(@"p1 is pass ? %i", p1.pass); // 计算属性 会使用实例变量存储
        
        p1.pass = true;
        p2.pass = true ;
        
        NSLog(@"p2(%@) is pass ? %i", p2, p2.pass);
        
        
        
    }
    return 0;
}
