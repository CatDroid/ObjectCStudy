#import "CBonicle.h"

@implementation CBonicle

-(instancetype)initWithName:(NSString *)name
{
    self = [super init];
    self.name = [name copy];
    //self.position.x = 0; // Expression is not assignable
    //self.position.y = 0; // @property(nonatomic, readonly) UIAccelerationValue x; 只读属性
    self.position = CGPointMake(0, 0);
    self.life = 100;
    return self ;
}


-(void) fire
{
	NSLog(@"fire [%@]%@ ", self, self.name);
}

-(void) encodeWithCoder:(NSCoder*)aCoder
{
	[aCoder encodeObject:self.name forKey:@"CBonicle_name"];
	//[aCoder encodePoint:self.position forKey:@"CBonicle_position"];
    [aCoder encodeCGPoint:self.position forKey:@"CBonicle_position"];
	[aCoder encodeInt:self.life forKey:@"CBonicle_life"];
}

-(id) initWithCoder:(NSCoder*)aDecoder
{
	self.position = [aDecoder decodeCGPointForKey:@"CBonicle_position"];
	self.name = [aDecoder decodeObjectForKey:@"CBonicle_name"];
    self.life = [aDecoder decodeIntForKey:@"CBonicle_life"];
    return self;
}

-(void) dealloc
{
    NSLog(@"this is CBonicle dealloc function");
    //[super dealloc]; // ARC不需要这个  会自动先调用子的，再自动调用父类的
    
     
        /*
         简单地说，就是代码中自动加入了retain/release，原先需要手动添加的用来处理内存管理的引用计数的代码可以自动地由编译器完成了
         
         该机制在iOS 5/ Mac OS X 10.7 开始导入，利用 Xcode4.2可以使用该机制。
         
         简单地理解ARC，就是通过指定的语法，让编译器(LLVM3.0)在编译代码时，自动生成实例的引用计数管理部分代码。
         
         有一点，ARC并不是GC，它只是一种代码静态分析（StaticAnalyzer）工具
         
         */

        
    
    
}

@end
