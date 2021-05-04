#ifndef CROBOT_SOLDIER_SELFDESTRUCT_HEADER
#define CROBOT_SOLDIER_SELFDESTRUCT_HEADER

#import "CRobotSoldier.h"

// 分类Category 不修改原类  不使用继承 扩展原来类的功能
@interface CRobotSoldier(CRobotSoldierSelfDestruct)

-(void)selfDestruct;

@end


#endif 
