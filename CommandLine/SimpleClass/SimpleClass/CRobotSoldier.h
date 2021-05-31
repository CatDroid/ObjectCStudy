#ifndef CROBOT_SOLDIER_HEADER 
#define CROBOT_SOLDIER_HEADER

#import "CRobot.h"
#import "CRobotProtocol.h"

@interface CRobotSoldier:CRobot <CRobotProtocol, NSCopying>

-(instancetype) initId:(int)_id withModel:(NSString *)_model;

-(void) moveToX:(int)x Y:(int)y;

-(id) copyWithZone:(NSZone*) zone;

@end


#endif
