//
//  Circle.h
//  ObjectCStudy
//
//  Created by hehanlong on 2020/10/11.
//

#import "Shape.h"

NS_ASSUME_NONNULL_BEGIN

@interface Circle : Shape
{
    int _radius ;
}

/*
iOS 中定义属性时的atomic、nonatomic、copy、assign、strong、weak几个特性的区别  readwrite readonly

atomic  默认属性  只是保证setter/getter 完整
        atomic 只是保证了获取和设置这个属性是互斥的，但对于属性的值是个对象 对返回这个对象的读写是没有保护的
        Runtime objc-accessors.mm文件包含了属性设值、取值源码
        虽然设值、取值方法是原子操作，但不代表是线程安全
        atomic修饰的设值、取值方法使用了自旋锁，确保线程同步
 
 nonatomic 非默认属性  运行速度快
 
 
 copy
    是owner，不是reference（引用）。当对象可变时，可设置为copy，用于获取此时值的副本。
    新的对象引用计数为1，与原始对象引用计数无关，且原始对象引用计数不会改变。
    使用copy创建的新对象也是强引用，使用完成后需要负责释放该对象。
    copy特性可以减少对象对上下文的依赖。新对象、原始对象中任一对象的值改变不会影响另一对象的值。
    要想设置该对象的特性为copy，该对象必须遵守NSCopying协议，Foundation类默认实现了NSCopying协议，所以只需要为自定义的类实现该协议即可
    
    被定义有copy属性的对象必须要 符合NSCopying协议，必须实现-
    (id)copyWithZone:(NSZone *)zone 方法。
    对于像NSString,的确是这样
    但是如果copy的是一个NSArray呢?这时只是copy了指向array中相对应元素的指针.这便是所谓的"浅复制".


 retain
    当把某个对象赋值给该属性时，该属性原来所引用的对象的引用计数减1，被赋值对象的引用计数加1。
    在未启用ARC机制的的情况下，retain可以保证一个对象的引用计数大于1时，该对象不会被回收。启用ARC后一般较少使用retain

 assign
    该指示符号对属性只是简单的赋值，不更改引用计数。
    常用于NSInteger等OC基础类型，以及short、int、double、结构体等C数据类型，因为这些类型不存在被内存回收的问题
 
    // NSString 一般是copy
    // 基本类型 一般是assign
 
 strong
    默认属性。创建一个强引用的指针，引用对象引用计数加1。
    所有实例变量、局部变量默认都是strong
    strong特性表示两个对象内存地址相同（建立一个指针，进行指针拷贝），内容会一直保持相同，直到更改一方内存地址，或将其设置为nil
 
 weak
    当最后一个strong指针不再指向这个对象，这个对象就会被释放，此时，所有指向这个对象的weak指针都将被清空。
 
 readwrite
    默认属性
 
 readonly
    非默认属性 只有可读方法，也就是只有getter方法
 
 
 1、atomic是默认行为，assign是默认行为，readwrite是默认行为
 2、推荐做法是NSString用copy
 3、delegate用assign（且一定要用assign）
 4、非objc数据类型，比如int，float等基本数据类型用assign（默认就是assign）
 5、其它objc类型，比如NSArray，NSDate用retain。
 
 
 */
@property(nonatomic, assign   ) int radius ; // 基本数据类型 不能是 copy 和 strong 这两个必须是object type



- (id) initWithName:(NSString*)__name AndId:(int)__id AndRaduis:(int)__radius ;  

- (NSString*) description ;

@end

NS_ASSUME_NONNULL_END
