//
//  Circle.m
//  ObjectCStudy
//
//  Created by hehanlong on 2020/10/11.
//

#import "Circle.h"

@implementation Circle



- (id) initWithName:(NSString*)__name AndId:(int)__id AndRaduis:(int)__radius
{
    self = [super initWithName:__name AndId:__id];
    if (self != nil) {
        self->_radius = __radius ;
    }
    
    return self;
}


- (NSString*) description
{
    NSString* parent = [super description];
    return [parent stringByAppendingFormat:@"radius = %d", self->_radius];
}


@end
