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


@end
