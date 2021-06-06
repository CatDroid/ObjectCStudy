//
//  ViewController.m
//  CoreImageView
//
//  Created by hehanlong on 2021/6/6.
//

#import "ViewController.h"


// @interface ViewController : UIViewController 这个是继承
// @interface ViewController() 这个是匿名类别/类扩展

// Extension是Category的一个特例。类扩展与分类相比只少了分类的名称，所以称之为“匿名分类”。

// 类扩展 作用 ！！
//      因为没有给名字,所以可以叫做匿名类别,他允许你定义消息,属性,变量和方法
//      匿名类别的主要作用是一些 ”属性和方法” 你只想在类内部使用,不需要暴露给外部类引用头文件时被看到,就可以用匿名类别来定义.
//      比较常用的是在私下遵守一些协议,不需要暴露在公共头文件中.


/*
 
 @interface XXX ()
 //私有属性
 //私有方法（如果不实现，编译时会报警,Method definition for 'XXX' not found）
 @end
 
 
 
 类别与类扩展的区别：
 a. 属性增加
    1. 类别中原则上只能增加方法（能添加属性的的原因只是通过runtime解决无setter/getter的问题而已）
    2. 类扩展不仅可以增加方法，还可以增加实例变量（或者属性），只是该实例变量默认是@private类型的
        （使用范围只能在自身类，而不是子类或其他地方）
 
 b. 方法不实现
    1.类扩展中声明的方法没被实现，编译器会报警，但是类别中的方法没被实现编译器是不会有任何警告的。
    2.这是因为类扩展是在编译阶段被添加到类中，而类别是在运行时添加到类中
 
 c. implementation部分
    1.类扩展不能像类别那样拥有独立的实现部分（@implementation部分）
    2. 也就是说，‘类扩展所声明的方法’ 必须依托对应‘类的实现部分’来实现。 ---> 所以类扩展一般都用在m文件中
 
 d. 类扩展方法私有公有
    定义在 .m 文件中的类扩展方法为私有的，
    定义在 .h 文件（头文件）中的类扩展方法为公有的 --- 没有见过这种情况
    类扩展是在 .m 文件中声明私有方法的非常好的方式
 
 */



@interface ViewController ()

@end

@implementation ViewController
{
    // 这里不能声明属性
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


@end
