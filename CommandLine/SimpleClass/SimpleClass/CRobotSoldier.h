#ifndef CROBOT_SOLDIER_HEADER 
#define CROBOT_SOLDIER_HEADER

#import "CRobot.h"

@interface CRobotSoldier:CRobot

-(instancetype) initId:(int)_id withModel:(NSString *)_model;

-(void) moveToX:(int)x Y:(int)y;


@end


#endif
