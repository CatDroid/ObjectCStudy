//
//  Shape.m
//  ObjectCStudy
//
//  Created by hohanloong on 2020/10/11.
//

#import "Shape.h"


/*
 Cocoa是苹果公司为macOS所创建的原生面向对象的应用程序接口，是Mac OS X上五大API之一（其它四个是Carbon、POSIX、X11和Java）
 
 Cocoa应用程序一般在苹果公司的开发工具Xcode（前身为Project Builder）和Interface Builder上用Objective-C写成。
 不过，通过Java bridge、PasCocoa、PyObjC、CamelBones以及RubyCocoa等桥接技术，Java、Clozure CL、LispWorks、Object Pascal、Python、Perl、Ruby等其它工具或者语言也可以用来开发Cocoa应用。
 
 
 Cocoa环境的一个特点是它可以管理动态分配的内存。
 Cocoa中绝大部分类的基类都是NSObject，它实现了引用计数的内存管理模型。
 从NSObject继承的类可以响应retain和release消息，以增减其引用计数；
 也可以通过发送retainCount消息来获取其引用计数。一个以alloc，copy 或Objective-C 2.0中增加的new所创建的对象的引用计数为1；
 
 向对象发送retain消息会将计数加1，而发送release消息则会将计数减1。
 若对象的引用计数减少到了0，则它会被销毁。
 dealloc消息类似于C++中的析构函数，在对象被销毁之前可能会被调用，但系统不保证会发送该消息。
 
 
 Cocoa包含三个主要的Objective-C对象库，称为“框架”。
 
 “Foundation工具包”，或简称为“Foundation”
 
 “应用程序工具包”，或称AppKit（Application Kit）

 “用户界面工具包”，或称UIKit（User Interface Kit）
 
 */

@implementation Shape


/*
 Case.1 如果只声明一个属性a，不使用@synthesize实现  ------  编译器会使用_a作为属性的成员变量
          如果没有定义成员变量_a则会自动生成一个私有的成员变量_a；
          如果已经定义了成员变量_a则使用自定义的成员变量_a。
          !!!!注意：如果此时定义的成员变量不是_a而是a则此时会自动生成一个成员变量_a，它跟自定义成员变量a没有任何关系）!!!!
 

 Case.2 如果声明了一个属性a，使用@synthesize a进行实现，但是实现过程中没有指定使用的成员变量 ------  编译器会使用a作为属性的成员变量
 
          如果定义了成员变量a，则使用自定义成员变量；
          如果此时没有定义则会自动生成一个私有的成员变量a，
          !!!! 注意如果此时定义的是_a则它跟生成的a成员变量没有任何关系 !!!!
 
 Case.3  如果声明了一个属性a，使用@synthesize a=_a进行实现，这个过程已经指定了使用的成员变量  ----- 此时会使用指定的成员变量作为属性变量；
 
 */

// @synthesize _convex; // 在新版本中甚至甚至都不用通过@synthesize只声明就可以使用
@synthesize  renameProperty = _renameProperty ; // 指定实现此属性时使用哪个成员变量  有点像重命名

- (void) run
{
    NSLog(@"调用另外一个成员函数");
    [self onRun];
}


- (void) onRun
{
    NSLog(@"跑起来了");
}


- (bool) setName: (NSString*) name
{
    _name = name ;
    return true ;
}

- (NSString*) getName
{
    return _name ;
}


- (void) setId: (int) __id
{
    // 不能写成 self.id = __id ;会导致死循环 
    self->_id = __id ;
}


- (int) Id
{
    return _id ;
}


- (bool) setName: (NSString*) name AndId: (int) _id
{
    // 只是self不仅可以表示当前对象还可以表示类本身，也就是说它既可以用在静态方法中又可以用在动态方法中
    
    self->_name = name ;
    // self->_id = _id ;
    self.Id = _id ; // 这个实际是调用了setId方法
    
    return true ;
}

+ (void) staticMethonShowMessage: (NSString*) info
{
    NSLog(@"%@", info) ;
    NSLog(@"class self address %p", self); // 0x100008420 0x100008660 会有改变的
}

/*
 初始化函数
 
    便利初始化
        当一个类需要根据不同的情况来初始化数据成员时，就需要便利初始化函数，
        与init初始化不同的是，便利初始化函数有参数，参数个数可以有1到Ｎ个，Ｎ是类数据成员个数
    
    指定初始化函数
        在初始化函数中，参数最多的为指定初始化函数
 
    其它未被指定为指定初始化函数的初始化函数， 要调用“指定初始化函数”来实现
    对于该类的子类也是一样，只要重写或者直接使用父类的指定初始化函数
 */

- (id) init
{
    return [self initWithName:@"default" AndId:0];
}


- (id) initWithName: (NSString*) name AndId:(int) __id
{
    // 1.重写init方法一定要调用父类的init方法
    // 2.判读父类是否初始化成功，self值是否为nil，如果父类初始化成功，self则不为nil
    // 3.一定要返回self
    if (self = [super init]) { //super代表父类
        // 通过调用父类的方法给当前对象赋值，然后判断这个对象是否为nil
        self->_name = name ;
        self->_id = __id ;
        [self privateFunction];
    }
    
    // 因为初始化方法init返回值可能与alloc返回的对象不是同一个？
    // 基于类簇的初始化，因为init可以接受参数，
    // 在init内部有可能根据不同的参数来返回不同种类型的对象
    
    
    return self ;
}

// 没有在.h声明的方法 私有方法
- (bool) privateFunction
{
    NSLog(@"私有方法 is called, name = %@" , self->_name);
    return true;
}


+ (instancetype) createWithName: (NSString*) name AndId:(int) _id
{
    Shape* p = [[self alloc] initWithName:name  AndId:_id]; // 备注: 函数调用参数之间没有逗号 直接空格
    return p;
}


- (NSString*) description
{
    // 千万不要在description中打印输出self，因为当输出self时会调用该对象的description方法，如此一来就会造成死循环。
    return [NSString stringWithFormat:@"name %@ id %d", _name, _id];
}


- (void) dealloc
{
    NSLog(@"[~destructor] %@ %p ", self, self);
    /*
     
     这是因为ARC是iOS 5推出的新功能，全称叫 ARC(Automatic ReferenceCounting)。
     
     简单地说，就是代码中自动加入了retain/release，原先需要手动添加的用来处理内存管理的引用计数的代码可以自动地由编译器完成了。
     
     该机制在iOS 5/ Mac OS X 10.7 开始导入，利用 Xcode4.2可以使用该机制。
     
     简单地理解ARC，就是通过指定的语法，让编译器(LLVM3.0)在编译代码时，自动生成实例的引用计数管理部分代码。
     
     有一点，ARC并不是GC，它只是一种代码静态分析（StaticAnalyzer）工具。
     
     但它又不同于垃圾回收，ARC无法处理retaincycles 在ARC里，如果两个对象互相强引用（strong references）将导致它们永远不会被释放，甚至没有任何对象引用它们
     
     而对于苹果的垃圾回收，要么整个程序都使用，要么都不用。
     也就是说在app中的所有O-C代码，包括所有的苹果框架和所有的第3方库必须支持垃圾回收，才能使用垃圾回收。
     
     相反，ARC和非ARC代码可以在一个app中和平共处。这使得将项目可以零星地迁移到ARC

     
     */
    // [super dealloc];  // ARC forbids explicit message send of 'dealloc'
}

@end


/*
 
 类别 为现有类添加新方法的方式 目的
    1. 可以将类的实现分散到多个不同的文件或多个不同的框架中。
    2. 创建对私有方法的前向引用
    3. 向对象添加非正式协议
 
 委托
    在Ojbective-C中，实现委托是通过类别(或非正式协议)或者协议来实现
    
 非正式协议
    创建一个NSObject的类别， 称为创建一个非正式协议。
    为什么叫非正式协议呢? 也就是说可以实现，也可以不实现被委托的任务。
 
 正式协议
    与非正式协议比较而言，在Ojbective-C中，正式协议规定的所有方法必须实现
    在Ojbective-C2.0中，Apple又增加了两个关键字，协议中的方法也可以不完全实现，是哪个关键字见关键字部份的@optional,@required
 
 选择器
    选择器就是一个方法的名称。
    选择器是在Objective-C运行时使用的编码方式，以实现快速查找。
 
    可以使用@selector预编译指令，获取选择器@selector(方法名)。N
    SObject提供了一个方法respondsToSelector:的方法，来访问对象是否有该方法(响应该消息)
 
 */
