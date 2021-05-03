#import "CRobot.h"

@implementation CRobot

-(instancetype)initId:(int)_id  withModel:(NSString*)model
{
    self = [super init]; // 需要显式调用父类的init
	self._id = _id ;
	self._model = model; // 对于属性 不用 ->  跟getter和setter计算属性一样 编译器自动产生get和set方法
    return self;
}

-(instancetype)initId:(int)_id
{
    //[self initId:_id withModel:@"default model"];
    // The result of a delegate init call must be immediately returned or assigned to 'self'
    self = [self initId:_id withModel:@"default model"]; // 调用本类的其他初始化函数 也要设置给init
    return self;
}

-(void) goHome
{
	self->_x = 0; // 如果是实例变量 要用 ->
	self->_y = 0;
	NSLog(@"goHome Done %i-%@", self._id, self._model);
}

@end
