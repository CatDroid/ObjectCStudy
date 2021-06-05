//
//  EnhanceGlowFilter.h
//  MyFirstGame
//
//  Created by hehanlong on 2021/6/5.
//

#import <CoreImage/CoreImage.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EnhanceGlowFilter : CIFilter

@property (strong, nonatomic) UIColor *glowColor; // 初始化可以通过 _glowColor设置这个值
@property (strong, nonatomic) CIImage* inputImage;
@property (strong, nonatomic) NSNumber* inputRadius;
@property (strong, nonatomic) CIVector* inputCenter; // CGVector是struct不能用strong strong必须是对象
@property (strong, nonatomic) CIImage* outputImage;
/*
    在oc中 属性就是给一个类的成员变量提供封装
    通过声明属性，我们可以很简单的为一个成员变量定义其是否是只读的还是读写的，是否是原子操作的等等特性，
    也就是说如果说封装是为成员变量套了一层壳的话，那么 @property关键字做的事情就是“预定义这层壳是个什么样子的壳”
    然后通过 @sythesize关键字“生成真正的壳”并把这个壳套在实际的成员变量上（如果没有定义这个成员变量该关键字也可以自动生成对应的成员变量）
    当然这层壳包括了自动生成的 get set 方法。
 
    在最开始的时候，我们在代码中写了@property对应的就要写一个@sythesize，
    在苹果使用了 LLVM 作为编译器以后，如果我们没有写 @sythesize
    编译器就会为我们自动的生成一个 @sythesize property = _property。
    这个特性叫做Auto property synthesize。自动属性合成
 
    当我们想覆盖父类的属性并做一些修改的时候，Auto property synthesize这个特性就有点不知道该干嘛了，这个时候他选择不跑出来为我们干活，
    所以编译器就不会自动生成@sythesize property = _property，
    但是子类总得有个壳啊，人家都有@property了，怎么办？直接拿过来父类的壳复制一份不管三七二十一套在子类的成员变量身上。
    注意，有些情况下这会产生运行时的 crash
 
    比如 属性同名 并且父类是readonly 子类是writeread
 
    OC 中 会有提示
    Auto property synthesis will not synthesize property 'outputImage' because it is 'readwrite'
    but it will be synthesized 'readonly' via another property
 
   虽然只给出了 warning，但是这个时候显然 outputImage 中是不会自动生成 set 方法的，如果在代码中调用了 outputImage 的实例对象的 set 方法，运行时就会 crash
 
   Terminating app due to uncaught exception 'NSInvalidArgumentException',
   reason: '-[EnhanceGlowFilter setOutputImage:]: unrecognized selector sent to instance
 
   在子类中显式的声明一个@synthesize name = _name;就好，这样子类就会如愿的产生他的壳
 
*/



-(instancetype) init;



@end

NS_ASSUME_NONNULL_END
