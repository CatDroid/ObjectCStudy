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

-(id) copyWithZone:(NSZone*) zone
{
    CRobotSoldier* deepClone = [[CRobotSoldier alloc] initId:__LINE__ withModel:@(__func__)];
    deepClone->_x = self->_x ;
    deepClone->_y = self->_y ;
    //deepClone->_testFlag = self->_testFlag; private
    NSString* old = [deepClone._model copy] ;
    
    // deepClone._model = [deepClone._model stringByAppendingString:self._model];
    
    deepClone._model = [NSString stringWithFormat:@"%@;%@", deepClone._model, self._model];
    
    return deepClone;
  
}

@end

