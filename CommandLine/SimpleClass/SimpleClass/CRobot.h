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

// 属性的本质
// @property = ivar + getter + setter
// 属性(property) 有两大概念：ivar(实例变量)、setter/getter(存取方法)

// 如果自己实现类似property功能，就要把实例变量名字定义为 _var  然后实现 -(type)var() 和 setVar(type) 两个函数
// 如果使用了属性的话，那么编译器就会自动编写访问属性所需的方法，此过程叫做“自动合成”(auto synthesis)，使用时直接通过"self.property"的方式使用


// 自动合成实现流程:

// OBJC_IVAR_$类名$属性名称 ：该属性的“偏移量” (offset)，这个偏移量是“硬编码” (hardcode)，表示该变量距离存放对象的内存区域的起始地址有多远。
// setter 与 getter 方法对应的实现函数
// ivar_list ：成员变量列表
// method_list ：方法列表
// prop_list ：属性列表

// 增加一个属性,系统都会在 ivar_list 中添加一个成员变量的描述,
// 在 method_list 中增加 setter 与 getter 方法的描述,
// 在属性列表中增加一个属性的描述,然后计算该属性在对象中的偏移量,然后给出 setter 与 getter 方法对应的实现,
// 在 setter 方法中从偏移量的位置开始赋值,在 getter 方法中从偏移量开始取值
// 为了能够读取正确字节数,系统对象偏移量的指针类型进行了类型强转.

// @property中有哪些属性关键字
// 原子性 --- nonatomic， atomic
// 读/写权限--- readwrite(读写) readonly(只读)
// 内存--- assign 赋值?? 、weak  弱引用 、string  字符串?? 、copy 拷贝 、unsafe_unretained 不引用???
// setter/getter方法名 getter=<函数名> setter=<函数名>
// 空 nonnull, null_resettable, nullable

// ARC模式下，如果不指定任何关键字，默认关键字包括
// 基本数据类型               atomic,readwrite,assign 赋值
// 普通Objective-C对象类型    atomic,readwrite,strong 强引用
 
// assign  一般用来修饰基本的数据类型，包括基础数据类型 （NSInteger，CGFloat）和C数据类型（int, float, double, char, 等等），为什么呢？
//         assign声明的属性是不会增加引用计数的

// retain：与assign相对，我们要解决对象被其他对象引用后释放造成的问题，就要用retain来声明。
//         retain声明后的对象会更改引用计数，那么每次被引用，引用计数都会+1，释放后就会-1

// strong: 就类似与retain了，叫强引用，会增加引用计数，类内部使用的属性一般都是strong修饰的，现在ARC已经基本替代了MRC，所以我们最常见的就是strong了

// copy：(NSCopying协议) 最常见到copy声明的应该是NSString。
//      copy与retain的区别在于retain的引用是拷贝指针地址，而copy是拷贝对象本身
//      也就是说retain是浅复制，copy是深复制，如果是浅复制，当修改对象值时，都会被修改，而深复制不会。
//      之所以在NSString这类有可变类型的对象上使用，是因为它们有可能和对应的可变类型如NSMutableString之间进行赋值操作，
//      为了防止内容被改变，使用copy去深复制一份。copy工作由copy方法执行，此属性只对那些实现了NSCopying协议的对象类型有效 。
 
// nonatomic
//      atomic，是原子性的访问。我们知道，在使用多线程时为了避免在写操作时同时进行写导致问题，经常会对要写的对象进行加锁
//      如果一个属性是由atomic修饰的，那么系统就会进行线程保护，防止多个写操作同时进行
//      如果不是进行多线程的写操作，就可以使用nonatomic，取消线程保护，提高性能

// weak：weak其实类似于assign，叫弱引用，也是不增加引用计数
//      IBOutlet、Delegate一般用的就是weak，这是因为它们会在类外部被调用，防止循环引用


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
-(void) moveToX:(int)x Y:(int)y;
//-(void) MoveToX:(int)x Y:(int)y; // 不在inteface中声明

-(void) noImplemetationMethon;

-(BOOL) pass;
-(void) setPass:(BOOL) flag;

-(NSString*) description ;

@end


#endif 
