//
//  Shape.h
//  ObjectCStudy
//
//  Created by hohanloong on 2020/10/11
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 基本上所有关键字都是以@开头
/*
 类的定义和声明 @interface @implementation @end
 
 访问修饰符    @public @protected @private
    @private   私有成员，只有当前类可以访问；
    @protected 受保护成员，只有当前类或子类可以访问（如果没有添加任何修饰则默认为@protected）；
    @public    公共成员，所有类均可访问；
    @package   在框架内是公共的，但是框架外是私有的
 
 异常  @try @catch  @throw @finall
 
    @protecal @optionl @required @class

    @property @synthesize @dynamic

    self super id cmd  _block _strong _week
 
    @selector
 
 
 */
// .h：类的声明文件，用于声明成员变量、方法。类的声明使用关键字@interface和@end
//     NSObject，这是ObjC的基类，所有的类最终都继承于这个类（但是需要注意ObjC中的基类或者根类并不只有一个，例如NSProxy也是ObjC的基类）


@interface Shape : NSObject {
    
    /*
         成员变量必须包含在大括号中
         注意成员变量不声明任何关键字的话是默认可访问性@Protected
         注意在ObjC中不管是自定义的类还是系统类对象都必须是一个指针
     */
    
    @public
    NSString* _name ; //在ObjC中推荐成员变量名以_开头
    int _id ;
    NSString* _isPrivateString ;
    
    @private
    bool _isPrivateFlag ;
    
    @private
    bool _convex ;
    
}

// 在ObjC中方法分为静态方法和动态方法两种
//
// 动态方法就是对象的方法
// 静态方法就是类方法
//
// 如果没有在.h中声明直接在.m中定义则该方法是私有方法
// 在.h中声明的所有方法作用域都是public类型，不能更改

// oc方法中任何类型都必须用小括号()括注
// oc方法中的小括号():括注数据类型
- (void) run;

- (void) onRun;

- (bool) setName: (NSString*) name;

- (NSString*) getName ;  // 没有参数 不用写: 或者()

// 在ObjC中属性的实现方式其实类似于Java中属性定义，通过对应的setter和getter方法进行实现
// ObjC中gettter方法通常使用变量名，而不加“get”。
//
// 声明 _id 的setter、getter方法 , 使用的时候就可以 self.id 或者 instance.id  不用->

- (void) setId: (int) __id ;
- (int) Id ;

// 类型需要放到()中，而且参数前必须使用冒号，并且此时冒号是方法名的一部分
// 一个冒号:对应一个参数，而且冒号:也是方法名的一部分
// 其中andId可以省略不写，当然为了保证方法名更有意义建议书写时加上

- (bool) setName: (NSString*) name AndId: (int) _id ;  // 名字相当于 setNameAndId  // setName: AndId:方法是一个动态方法

// 在ObjC中可以通过声明@property，同时通过@synthesize自动生成getter、setter方法
// 在新版本中甚至甚至都不用通过@synthesize只声明就可以使用

@property bool _convex;

@property NSString* renameProperty ;  //  通过 @synthesize 指定实现此属性时使用哪个成员变量,并生成新的成员属性

// 编译器指令
// 告诉Xcode编译器，要在编辑器窗格顶部的方法和函数弹出菜单中将代码分隔开
// #pragma mark – 的“-”后面不能有空格
#pragma mark –------------ --- 

+ (void) staticMethonShowMessage: (NSString*) info ;

// init继承于NSObject这个根类，所有的子类可以不用重写这个实例方法函数
// 自定义构造函数，一般以init开头

- (id) init ; // 这样使得自己的程序更具有兼容性。如果没有对这样的继承而来的方法进行重写，可能会导致别人使用了没有被正确初始化的对象


#pragma mark 构造函数 返回类型是(id)
// 构造函数 跟普通函数类似  不过需要调用super init 和 返回类型是id
- (id) initWithName: (NSString*) name AndId:(int) _id ; //  可以把构造函数名字看成 initWithName:AndId:
// id是指向Objective-C类对象的指针，它可以声明为任何类对象的指针
// 当在Objective-C中使用id时，编译器会假定你知道，id指向哪个类的对象
// 与void*是不同的是，void*编译器不知道也不假定指向任何类型的指针。


// 自定义构造方法固然可以简化代码，但是在使用时还要手动申请内存，在ObjC中一般我们通过定义一个静态方法来解决这个问题

+ (instancetype) createWithName: (NSString*) name AndId:(int) _id ;

// instancetype 和 id的区别
// 关联返回类型的方法 :  会返回一个方法所在类类型的对象
//      类方法中，以alloc或new开头
//      实例方法中，以autorelease，init，retain或self开头
// 否则 属于 非关联返回类型的方法
//
// instancetype的作用，就是使那些非关联返回类型的方法返回所在类的类型
// 能够确定对象的类型，能够帮助编译器更好的为我们定位代码书写问题
//
// 如果使用id，返回的是id类型，编译器不知道id类型的对象是否实现哪些方法


// java中叫做toString()）用于打印一个对象的信息，在ObjC中这个方法叫description

- (NSString*) description ;


// 析构函数
- (void) dealloc;
 
@end




NS_ASSUME_NONNULL_END
