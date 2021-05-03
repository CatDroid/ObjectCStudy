#ifndef __CROBOT_HEADER__
#define __CROBOT_HEADER__

#import <Foundation/Foundation.h> 

@interface CRobot : NSObject 
{
    // @protected
	int _x ;
	int _y ;
    
@private
    bool _testFlag; // 实例变量
}

@property int _id;
@property NSString* _model;

-(instancetype)initId:(int)_id withModel:(NSString*)_model NS_DESIGNATED_INITIALIZER;

-(instancetype)initId:(int)_id ;

-(instancetype)init NS_UNAVAILABLE;

// 指定初始化方法 和 便利初始化方法:

// NS_DESIGNATED_INITIALIZER：用来将修饰的方法标记为指定构造器
// NS_UNAVAILABLE：禁止使用某个初始化方法

// 如果子类实现了NS_DESIGNATED_INITIALIZER修饰的指定初始化方法，没有使用NS_UNAVAILABLE修饰父类的初始化方法。=> 代表原来父类的初始化函数 还可以被外部调用
// 则需要在子类重写父类的指定初始化方法，并且在里面调用子类自己的指定初始化方法。
// 因为如果一个类的方法被 NS_DESIGNATED_INITIALIZED 修饰，则改方法变成指定构造方法，从父类继承来的指定构造方法则变成便利初始化方法 => 重写父类的初始化函数 成为便利函数
// 重写父类的指定初始化方法后，不能调用super相关的方法


// 避免使用new创建对象，从安全和设计角度来说我们应该对初始化所有属性，提高程序的健壮性和复用性。


-(void) goHome;

-(BOOL) pass;
-(void) setPass:(BOOL) flag;

@end


#endif 
