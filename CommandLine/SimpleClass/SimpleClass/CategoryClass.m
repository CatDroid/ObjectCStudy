//
//  CategoryClass.m
//  SimpleClass
//
//  Created by hehanlong on 2021/6/6.
//

#import "CategoryClass.h"

#import <objc/runtime.h> // objc_setAssociatedObject objc_getAssociatedObject 关联对象

static NSString* const kNameWithSetterGetterKey = @"NameWithSetterGetterKey";


@implementation CRobotSoldier (CategoryClass)
//{   // Expected identifier or '('
    
//}

@dynamic dynamicKeyString;

// 由于"OC是动态语言"，方法"真正的实现"是通过runtime完成的，
// 虽然系统不给我们生成setter/getter，但我们可以通过runtime手动添加setter/getter方法。
// 代码仅仅是手动实现了setter/getter方法，但调用_成员变量依然报错

//---------------------------------------------------------------------------------------------------------
// 使用string作为key
- (void)setNameWithSetterGetter:(NSString *)nameWithSetterGetter
{
    objc_setAssociatedObject(self, &kNameWithSetterGetterKey, nameWithSetterGetter, OBJC_ASSOCIATION_COPY);
}

- (NSString *) nameWithSetterGetter
{
    return objc_getAssociatedObject(self, &kNameWithSetterGetterKey);
}

//---------------------------------------------------------------------------------------------------------
// 使用数字作为key
-(void)setFakeVoidAddressString:(NSString *)fakeString
{
    objc_setAssociatedObject(self, (const void*)123, fakeString, OBJC_ASSOCIATION_COPY);
}

-(NSString*) fakeVoidAddressString
{
    return objc_getAssociatedObject(self, (const void*)123);
}

//---------------------------------------------------------------------------------------------------------
// 使用dynamic(推荐)
-(void) setDynamicKeyString:(NSString *)dynamicKeyString
{
    objc_setAssociatedObject(self, @selector(dynamicKeyString), dynamicKeyString, OBJC_ASSOCIATION_COPY);
}

-(NSString*) dynamicKeyString
{
    return objc_getAssociatedObject(self, @selector(dynamicKeyString));
}


// 在头文件中使用@property，对应的.m文件中使用@dynamic
// key值可以使用@selector(associatedObject),也可以使用 static const void *AssociatedObjectKey = &AssociatedObjectKey;,推荐使用前者



// Associated Objects(关联对象)或者叫做关联引用(Associated References) 是作为Objective-C 2.0运行时功能
// 与它相关在<objc/rumtime.h>中有3个C函数，他们可以让对象在运行时关联任何值

// void objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy)
// 用给定的key和policy来为指定对象(object)设置关联对象值(value)

// id objc_getAssociatedObject(id object, const void *key)
// 根据给定的key从指定对象(object)中获取相对应的关联对象值

// void objc_removeAssociatedObjects(id object)
// 移除指定对象的全部关联对象


/*
 
 enum {
     OBJC_ASSOCIATION_ASSIGN = 0,           给关联对象指定弱引用,相当于@property(assign)或@property(unsafe_unretained) ?? 赋值
     OBJC_ASSOCIATION_RETAIN_NONATOMIC = 1, 给关联对象指定非原子的强引用,相当于@property(nonatomic,strong)或@property(nonatomic,retain)
     OBJC_ASSOCIATION_COPY_NONATOMIC = 3,   给关联对象指定非原子的copy特性,相当于@property(nonatomic,copy)
     OBJC_ASSOCIATION_RETAIN = 01401,       给关联对象指定原子强引用,相当于@property(atomic,strong)或@property(atomic,retain
     OBJC_ASSOCIATION_COPY = 01403          给关联对象指定原子copy特性,相当于@property(atomic,copy)
 };
 typedef uintptr_t objc_AssociationPolicy;
 
 
 
 (1) 使用关联，我们可以不用修改类的定义而为其增加存储空间，在对于无法访问到类的源码的时候非常有用

 (2) 关联是通过关键字来进行操作的，因而可以为任何对象增加任意多的关联，每个都使用不同的关键字即可。

 (3) 关联是可以保证被关联的对象在关联对象的整个生命周期都是可用的。
 
 */

@end
