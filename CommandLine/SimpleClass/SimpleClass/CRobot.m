#import "CRobot.h"

@implementation CRobot


// @property有两个对应的词，一个是@synthesize，一个是@dynamic。
// 如果@synthesize和@dynamic都没写，那么默认的就是@syntheszie var = _var;

// @synthesize 的作用:是为属性添加一个实例变量名，或者说别名。同时会为该属性生成 setter/getter 方法。
// 如果 @synthesize 省略不写,则自动生成对应属性的 setter 和 getter 方法,默认操作的成员变量是’_’+属性名
 
// 禁止@synthesize:如果某属性已经在某处实现了自己的 setter/getter
// 可以使用 @dynamic 来阻止 @synthesize 自动生成新的 setter/getter 覆盖
//
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


-(BOOL) pass
{
    return self->_testFlag;
}

-(void) setPass:(BOOL)pass
{
    NSLog(@"setPass(setter) %p, %i", self, pass);
    self->_testFlag = pass ;
}

@end
