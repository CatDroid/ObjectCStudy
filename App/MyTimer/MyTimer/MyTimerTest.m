//
//  MyTimerTest.m
//  MyTimer
//
//  Created by hehanlong on 2021/5/23.
//

#import <Foundation/Foundation.h>

#import "MyTimerTest.h"

@implementation MyTimerTest

-(instancetype) initWithId:(int) _id withX:(int)_x withY:(int)_y
{
    self = [super init];
    if (self) {
        self->_id = _id;
        self->x = _x;
        self->y = _y;
    } else {
        NSLog(@"MyTimerTest super init fail");
    }
    return self;
}

-(void) dealloc
{
    NSLog(@"instance %@ has been dealloced!", self);
    // [super dealloc];
}

-(void) timerAction:(NSTimer*) timer
{
    NSLog(@"Hi, Timer Action for instance %@", self);
}

-(NSString*) description
{
    return [NSString stringWithFormat:@"%d,(%f,%f)", self->_id, self->x, self->y];
}

@end
