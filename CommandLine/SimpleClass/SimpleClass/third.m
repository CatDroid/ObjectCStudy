//
//  third.m
//  SimpleClass
//
//  Created by hehanlong on 2021/5/16.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

void timerFunc()
{
    
}

void third()
{
    NSNumber* temp = @1 ;
    // NSLog(@"%p",  temp->isa);
    // Direct access to Objective-C's isa is deprecated in favor of object_getClass()
    // Instance variable 'isa' is protected
    
    // object_getClass(temp);
    
    // objc_getClass 参数是类名的字符串，返回的就是这个类的类对象；
    // object_getClass 参数是id类型，它返回的是这个id的isa指针所指向的Class，如果传参是Class，则返回该Class的metaClass
    
    // typedef struct objc_class *Class;
    Class objClass = [temp class];
    const char *className = object_getClassName(objClass);
    
    Class getClass = object_getClass(temp);
    
    Class nameClass = objc_getClass(className); // 通过类名字 找对应的Class对象
    
    if (objClass == nameClass) {
        NSLog(@"Class其实是struct objc_class*  [obj class] 和 objc_getClass(char* rttiName) 一样");
    }
    
    if (objClass == getClass) {
        NSLog(@"当参数obj为Object实例对象 object_getClass(obj)与[obj class]输出结果一样，均获得isa指针，即指向类对象的指针 ");
    }
    
    Class classOfClass = [objClass class];
    Class getClassOfClass = object_getClass(objClass);
    if (classOfClass == getClassOfClass) {
        
    } else {
        if (classOfClass == objClass)
        {
            NSLog(@"当参数obj为Class类对象 object_getClass(obj)返回类对象中的isa指针，即指向元类对象的指针；[obj class]返回的则是其本身");
        }
    }
    // object_getClass  Class类对象  Metaclass类对象 Rootclass类对象  Rootclass‘s metaclass(根元类)
    // [clsOrObj class] 始终是Class本省, 如果是clsOrObj是Class本身就返回本身，如果clsOrObj
    
    
    // class_isMetaClass
    
    // NSTimer/NSString/NSArray/NSDictionary/NSNumber
    // 都是一些给外部看的基类, 实际实现是一些派生子类, 类簇
    // 一个父类有好多子类，父类在返回自身对象的时候，向外界隐藏各种细节，根据不同的需要返回的其实是不同的子类对象，这其实就是抽象类工厂的实现思路
    
    NSLog(@"NSTimer class %@ ", [NSTimer class] ); // NSTimer
    //NSTimer* obj = [NSTimer scheduledTimerWithTimeInterval:1 target:nil selector:@selector(timerFunc) userInfo:nil repeats:false];
    NSTimer* obj = [NSTimer scheduledTimerWithTimeInterval:1 repeats:false block:^(NSTimer * _Nonnull timer) {
        NSLog(@"NSTimer object with block run");
    }];
    NSLog(@"NSTimer obj 其实是 __NSCFTimer 与[NSTimer class]不一样 %@, %@", obj, object_getClass(obj)); // <__NSCFTimer: 0x1038049f0>, __NSCFTimer
    NSLog(@"NSCFTimer is child class of NSTimer ?: %s ",[object_getClass(obj) isSubclassOfClass:[NSTimer class]]?"YES":"NO");
    
    NSNumber *intNum = [NSNumber numberWithInt:1];
    NSNumber *boolNum = [NSNumber numberWithBool:YES];
    NSLog(@"intNum :%@", [intNum class]);  // intNum :__NSCFNumber
    NSLog(@"boolNum:%@", [boolNum class]); // boolNum:__NSCFBoolean
    
}
