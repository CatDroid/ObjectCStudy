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
        
        
    }
    return 0;
}
