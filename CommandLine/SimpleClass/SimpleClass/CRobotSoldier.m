#import "CRobotSoldier.h"

@implementation CRobotSoldier


-(instancetype)initId:(int)_id withModel:(NSString*)_model
{
    self = [super initId:_id withModel:_model];
    return self ;
}


-(void) moveToX:(int)x Y:(int)y
{
    [super moveToX:x Y:y];  // the selector 'MoveToX:Y:'
    //[super MoveToX:y Y:y]; // 只在implementation中声明和定义 都是私有的
    NSLog(@"CRobotSoldier MoveToX:Y:");
}

// 即使不实现 也不会编译错误
-(void) fire
{
    NSLog(@"[%@] [CRobotProtocol] fire ", self);
}

-(void) recoveryToX:(int)x Y:(int)y
{
    self->_x = x ;
    self->_y = y ;
    NSLog(@"[%@] [CRobotProtocol] recoveryToX ", self);
}

@end

