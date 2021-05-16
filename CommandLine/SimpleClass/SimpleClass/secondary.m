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
    {
        NSString *str0 = @"1";
        NSString *str1 = [NSString stringWithFormat:@"1"];// stringWithFormat 应该还有其他参数 不过这里没有 内部生成另外一个string 跟str0和str1
        NSString *str2 = [[NSString alloc] initWithString:@"1"];//跟str0一样 Using 'initWithString:' with a literal is redundant
        NSMutableString *str3 = [[NSMutableString alloc] initWithString:@"1"];//
        NSString *strs0copy = str0.copy;
        NSString *str3copy = str3.copy;
        NSString *str0mucopy = str0.mutableCopy;
        NSString *str00mucopy = str0.mutableCopy;
        // str0、str2、strs0copy的内存地址是一样的
        // str0、str2、strs0copy的类型是__NSCFConstantString；字符串常量存储区,字面量相等的共用一块常量存储地址，常量区的copy操作是浅拷贝依然相同地址
        // str1和str3copy的类型是NSTaggedPointerString，跟字面量的值密切相关，是在栈上
    
        
        // 对于str2的写法，编译器会报一警告,警告我们str2的字面量赋值是多余的，默认会给我们str0的形式,str2依然是在常量区

        NSLog(@"str0:%p %@", str0, [str0 class]);
        NSLog(@"str1:%p %@", str1, [str1 class]);
        NSLog(@"str2:%p %@", str2, [str2 class]);
        NSLog(@"strs0copy:%p %@", strs0copy,  [strs0copy class]);
        NSLog(@"str3:%p %@", str3,  [str3 class]);
        NSLog(@"str3copy:%p %@", str3copy, [str3copy class]);
        NSLog(@"str0mucopy:%p %@", str0mucopy, [str0mucopy class]);
        NSLog(@"str00mucopy:%p %@", str00mucopy, [str00mucopy class]);
        
        if (str0 == str1)
        {
            //NSLog(@"== 比较对象地址 true");
        }
        else
        {
            NSLog(@"== 比较对象地址 __NSCFConstantString != NSTaggedPointerString ");
        }
        
        if ([str0 isEqual:str1])
        {
            NSLog(@"isEqual 被NSString重写 true");
        }
        
        
        // 字符串 相等  Direct comparison of a string literal has undefined behavior 直接判断字符串字面量是未定义行文，应该是用isEqual(判断内容是否一致)
        if (@"OneString" == @"OneString" && [@"OneString" isEqualToString:@"OneString"]) {
            NSLog(@"NSString isEqualTo ==");
        }
        
        
        
        /*
         - (BOOL)isEqual:(id)obj {
           return obj == self;
         }
         
         默认情况下 isEqual 是判断对象的地址是否一样的
         NSString内部重写了isEqual
         
        - (BOOL) isEqual: (id)anObject
        {
          if (anObject == self)
            {
              return YES;
            }
          if (anObject != nil && [anObject isKindOfClass: NSStringClass]) // 增加判断了类型
            {
              return [self isEqualToString: anObject]; // 内存不等的情况下比较的说isEqualToString
            }
          return NO;
        }
         
         - (BOOL) isEqualToString:   // (NSString*)aString 必须知道两者都是NSString
         {
           if (aString == self)
             {
               return YES;
             }
           if ([self hash] != [aString hash]) // 首先是否相等比较，然后比较hash值，最后比较字面量是否相同
             {
               return NO;
             }
           if (strCompNsNs(self, aString, 0, (NSRange){0, [self length]})
             == NSOrderedSame)
             {
               return YES;
             }
           return NO;
         }
         
         对于我们自定义对象的比较可以重写- (BOOL) isEqual:和- (NSUInteger)hash
         
         1. 对于@"string" 生成的NSString对象 会指向同一个内存，同一对象
         2. NSString alloc] initWithString:@"string" ] 等同 @“string”
         3. isEqual可以判断是否NSString类型, isEuqalToString需要确保两个都是NSString类型,速度更加快
         4. 判断NSString内容是否相等用isEqual, == 用于判断对象地址是否一样
         
         */
        
    }
}
