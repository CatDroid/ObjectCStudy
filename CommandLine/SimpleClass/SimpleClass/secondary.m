//
//  secondary.m
//  SimpleClass
//
//  Created by hehanlong on 2021/5/4.
//

#import <Foundation/Foundation.h>

#import "CRobotSoldierSelfDestruct.h" // 分类 要import扩展的文件

void secondary()
{
    NSLog(@"secondary ------------ being --------------");

    CRobotSoldier* c1 = [[CRobotSoldier alloc] initId:__LINE__ withModel:@(__func__)];
    NSLog(@"CRobotSoldierSelfDestruct = %@", c1);
    [c1 selfDestruct];
    
    // SEL是选择器（selector）的一个类型。选择器就是指向方法的一个指针
    // SEL action = [button action]; // 定义一个选择器  类似C++类的函数指针
 
    
    // typedef struct objc_selector    *SEL; // 不是NSObject
    
    // @selector(方法:参数:) 返回SEL类型(选择器类型) 对象
    SEL s = @selector(MoveToX:Y:);
    //NSLog(@"selector is %@", *s);
    if ([c1 respondsToSelector:s]) {
        // NSObject performSelecor方法允许动态方法调用，它支持的参数只能是id类型，不能是基本数据类型。
        // 需要传递基本数据类型时，要使用NSInvocation(反射)
        //id result = [c1 performSelector:s withObject:12 withObject:13];
        //id result = [c1 performSelector:s]; // EXC_BAD_ACCESS
        // 方法执行器
        [c1 performSelector:s]; // 无视访问控制, 并且函数有定义参数 但调用可以不传入 但是是乱的数字
        //NSLog(@"performSelector %@", result[0]);
    }
    
    SEL s2 = NSSelectorFromString(@"moveToX:Y:");
    if ([c1 respondsToSelector:s2]){
        [c1 moveToX:12 Y:13];
    }
    
    // [CRobot class] class 是类的方法
    NSLog(@"isMemberOfClass %i ", [c1 isMemberOfClass:[CRobot class]]);// 实例是否 某个类的实例
    NSLog(@"isKindOfClass %i ", [c1 isKindOfClass:[CRobot class]]); // 实例是否 某个类或者子类的实例
    
    NSLog(@"isSubclassOfClass %i ", [CRobotSoldier isSubclassOfClass:[CRobot class]]); // 一个类是否另外一个类的子类
    
    
    NSLog(@"secondary ------------ end  --------------");
    
    // NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    // [pool drain];
}
