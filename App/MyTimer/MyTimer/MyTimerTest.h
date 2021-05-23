//
//  MyTimerTest.h
//  MyTimer
//
//  Created by hehanlong on 2021/5/23.
//

#ifndef MyTimerTest_h
#define MyTimerTest_h

#import <Foundation/Foundation.h>

@interface MyTimerTest : NSObject
{
@private
    int _id ;
@public
    float x ;
    float y ;
}

-(instancetype) init NS_UNAVAILABLE;
-(instancetype) initWithId:(int)_id  withX:(int)_x withY:(int)_y ;
-(void) dealloc ;
-(void) timerAction:(NSTimer*) timer ;
-(NSString*) description ;

@end


#endif /* MyTimerTest_h */
