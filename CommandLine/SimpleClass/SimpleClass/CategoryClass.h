//
//  CategoryClass.h
//  SimpleClass
//
//  Created by hehanlong on 2021/6/6.
//

#import <Cocoa/Cocoa.h>
#import "CRobotSoldier.h"

NS_ASSUME_NONNULL_BEGIN

@interface CRobotSoldier (CategoryClass) // !! 括号里面的才是 分类名字。 interface后的是原类名
//{
//    NSString* nameWithSetterGetter;
//} // Instance variables may not be placed in categories 实例变量不允许在分类Catelogy

/*
    Category 是表示一个指向分类的结构体的指针，其定义如下：
    typedef struct objc_category *Category;
    struct objc_category {
      char *category_name                          OBJC2_UNAVAILABLE; // 分类名
      char *class_name                             OBJC2_UNAVAILABLE; // 分类所属的类名
      struct objc_method_list *instance_methods    OBJC2_UNAVAILABLE; // 实例方法列表
      struct objc_method_list *class_methods       OBJC2_UNAVAILABLE; // 类方法列表
      struct objc_protocol_list *protocols         OBJC2_UNAVAILABLE; // 分类所实现的协议列表
    } // 注意: 根本没有属性列表，
 
    
    1. 分类是用于给原有类添加方法的,因为分类的结构体指针中，没有属性列表，只有方法列表。
            所以< 原则上讲它只能添加方法, 不能添加属性(成员变量),实际上可以通过其它方式添加属性> ;
 
    2. 分类中的可以写@property, 但不会生成setter/getter方法, 也不会生成实现以及私有的成员变量（编译时会报警告）
 
    3. 可以在分类中访问原有类中.h中的属性
 
    4. 如果分类中有和原有类同名的方法, 会优先调用分类中的方法, 就是说会忽略原有类的方法。
        所以同名方法调用的优先级为 分类 > 本类 > 父类。因此在开发中尽量不要覆盖原有类;
 
    5. 如果多个分类中都有和原有类中同名的方法, 那么调用该方法的时候执行谁由编译器决定；编译器会执行最后一个参与编译的分类中的方法。
 
 */

//设置setter/getter方法的属性
//不设置setter/getter方法的属性（注意是可以写在这，而且编译只会报警告，运行不报错）
@property(nonatomic,copy) NSString* nameWithSetterGetter;

@property(nonatomic,copy) NSString* nameWithoutSetterGetter;

@property(nonatomic,copy) NSString* fakeVoidAddressString;

@property(nonatomic,copy) NSString* dynamicKeyString;

- (void) programCategoryMethod;                                     //分类方法


@end

NS_ASSUME_NONNULL_END
