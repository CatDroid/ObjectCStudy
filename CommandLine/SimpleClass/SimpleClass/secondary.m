//
//  secondary.m
//  SimpleClass
//
//  Created by hehanlong on 2021/5/4.
//

#import <Foundation/Foundation.h>

#import "CRobotSoldierSelfDestruct.h" // 分类 要import扩展的文件
#import "objc/runtime.h"


NSString* gCurLang = @"en";
NSString* local(NSString* key)
{
    return NSLocalizedStringFromTable(key, gCurLang, nil);
}
void SwitchLang(NSString* lang)
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSArray* allLangs = [defaults objectForKey:@"AppleLanguages"];
    
    [allLangs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"all language %lu %@", idx, obj);
    }];
    

    if ([allLangs containsObject:lang]) {
        gCurLang = lang ;
    }
    else {
        NSLog(@"language not found %@", lang);
    }
    
    
    gCurLang = lang ;
}

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
    
    {
        BOOL res1 = [(id)[NSObject class] isKindOfClass:[NSObject class]]; // YES 特殊
        // 如果调用的是类方法 那么会找元类来对比是否给定类, isKindOfClass会沿着元类的super来对比,元类的super最终指向NSObject(NSObject)
        // 理解上 可以认为 isMemberOfClass/isKindOfClass 调用的都是对象/object, 如果对象是类，那么对比是的类的元类
        BOOL res2 = [(id)[NSObject class] isMemberOfClass:[NSObject class]]; // NO
        BOOL res3 = [(id)[CRobot  class] isKindOfClass:[CRobot class]]; // NO
        BOOL res4 = [(id)[CRobot class] isMemberOfClass:[CRobot class]]; // NO
        
        NSLog(@"isKindOfClass(对象是类或子类的实例),isMemberOfClass(对象是类的实例) 有类方法和实例方法 %s %s %s %s",
              res1?"YES":"NO",
              res2?"YES":"NO"
              );
        
        BOOL res5 = [NSObject class] == [[NSObject class] class]; // YES
        BOOL res6 = [NSObject class] == [[[NSObject class] class] class]; // YES
        BOOL res7 = [NSObject class] == object_getClass([NSObject class]);// NO
        BOOL res8 = object_getClass([NSObject class]) == object_getClass(object_getClass([NSObject class])); // YES NSObjec是rootClass rootClass_meta的isa是自身
        BOOL res9 = [NSObject class] == class_getSuperclass(object_getClass([NSObject class])); // YES rootClass_meta的super是rootClass(NSObject)
        
        /*


         + (BOOL)isKindOfClass:(Class)cls {
             // 第一次调用对象的isa(object_getClass) 后面就沿着这个class的super(class_getSuperclass)
             // 注意 元类最后的super都是NSObject
             for (Class tcls = object_getClass((id)self); tcls; tcls = class_getSuperclass(tcls)) {
                 if (tcls == cls) return YES;
             }
             return NO;
         }

         - (BOOL)isKindOfClass:(Class)cls {
             for (Class tcls = [self class]; tcls; tcls = class_getSuperclass(tcls)) {
                 if (tcls == cls) return YES;
             }
             return NO;
         }
         
         + (BOOL)isMemberOfClass:(Class)cls {
             return object_getClass((id)self) == cls; // 会根据isa找元方法,判断本类的元类 是否给定cls类型
         }

         - (BOOL)isMemberOfClass:(Class)cls {
             return [self class] == cls;
         
         }
         
         */
    }
    NSLog(@"secondary ------------ end  --------------");
    
    // NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    // [pool drain];
    
    {
        NSArray* differentObjArray = [NSArray arrayWithObjects:
                                      [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian], // [obj class]  _NSCopyOnWriteCalendarWrapper
                                      @"StringElement", // [obj class] = __NSCFConstantString
                                      [NSDate date],
                                      [NSNumber numberWithFloat:1.2], // __NSCFNumber
                                      [NSNumber numberWithBool:true], // __NSCFBoolean float bool 等基础类型
                                      [NSValue valueWithPoint: NSMakePoint(5.0, -5.0)],  // CGPoint CGRect 等基础结构体
                                      [NSValue valueWithRange: NSMakeRange(2, 10)],
                                      nil];
        
        NSLog(@"Number 转换成其他基础类型 1 -> bool %i", [[NSNumber numberWithFloat:1.0] boolValue]); // 非0都是1
        NSLog(@"Number 转换成其他基础类型 0.5->bool %i", [[NSNumber numberWithFloat:0.5] boolValue]);
        NSLog(@"Number 转换成其他基础类型 0.5->bool %i", [[NSNumber numberWithBool:1.0] intValue]);
        
        [differentObjArray enumerateObjectsUsingBlock:^(id value, NSUInteger index, BOOL* stop){
            NSLog(@"NSArray数组存放不同的类型 %lu %@ - %@", index, value , [value isKindOfClass:[NSDate class]]?@" is NSDate":[value class]);
        }];
        
       
        NSUInteger index = [differentObjArray indexOfObject:@"StringElement1"];
        if (index == NSNotFound) { // 9223372036854775807 很大的整数
            NSLog(@"NSArray indexOfObject NSNotFound");
        } else {
            NSLog(@"NSArray indexOfObject %lu", index );
        }
        
        // ----------------- ---------- ---------- ----------
        NSArray* paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* path1 = paths1.firstObject;
        path1 = [path1 stringByAppendingPathComponent:@"myDiffentArray.txt"];
        NSError* error = NULL;
        
        NSData* archiverData = [NSKeyedArchiver archivedDataWithRootObject:differentObjArray requiringSecureCoding:YES error:&error];
        // NSString *archiverString = [archiverData base64EncodedStringWithOptions:0];
        BOOL wrote = [archiverData writeToFile:path1 atomically:TRUE];
        NSLog(@"NSArray 使用 NSKeyedArchiver archivedDataWithRootObject 序列化 而不是 writeToFile %s", wrote? "OK" : "Fail");
        
        
        //NSArray* sameObjArray = @[@"one", @"two", @"three", nil, @"five"] ; //  Collection element of type 'void *' is not an Objective-C object
        NSArray* sameObjArray = @[@"one", @"two", @"three", @"four"] ;  // 通过指令 @[] 来创建初始化
        NSLog(@"count %lu firstObject %@ lastObject %@", sameObjArray.count, sameObjArray.firstObject, sameObjArray.lastObject);
 
        archiverData = [NSData dataWithContentsOfFile:path1];
        // NSArray* recoveryArray = [NSKeyedUnarchiver unarchiveObjectWithData:archiverData]; // OK
        // NSArray* recoveryArray = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray class] fromData:archiverData error:&error];
        // Fail 'NS.objects' was of unexpected class 'NSCalendar'. Allowed classes are '{( NSArray)}'.}
        NSArray* recoveryArray = [NSKeyedUnarchiver unarchivedObjectOfClasses:
                                  [NSSet setWithObjects:[NSArray class],[NSCalendar class], [NSDate class],[NSValue class],[NSNumber class], nil]
                                                                     fromData:archiverData
                                                                        error:&error];
        // 如果属性包含其他数据类型或自定义类型，则使用unarchivedObjectOfClasses把所有类型写入集合中，且自定义类型也需实现NSSecureCoding协议
        if (error != NULL) {
            NSLog(@"通过 unarchiveObjectWithData 恢复具有不同类型的数组 失败 %@", error);
        }
        [recoveryArray enumerateObjectsUsingBlock:^(id value, NSUInteger index, BOOL* stop){
            NSLog(@"通过 unarchiveObjectWithData 恢复具有不同类型的数组 %lu %@ ", index, value);
        }];
        
        
        // ----------------- ---------- ---------- ----------
        
       
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* path = paths.firstObject;
        path = [path stringByAppendingPathComponent:@"myNSArray.txt"];
        BOOL done = [sameObjArray writeToFile:path atomically:true];
        // 返回false 代表不是每个元素都能写到文件  returns NO if all the objects are not property list objects, 比如NSDate
        // 元素只能是 NSString, NSData, NSArray, or NSDictionary objects.
        NSLog(@"NSArray写入文件 writeToFile done ? %s", done ? "success":"fail");
        
        NSArray* fileArray = [NSArray arrayWithContentsOfFile:path];
        [fileArray enumerateObjectsUsingBlock:^(id value, NSUInteger index, BOOL* stop){
            NSLog(@"arrayWithContentsOfFile %lu %@ ", index, value);
        }];
        
        // ----------------- ---------- ---------- ----------
        NSMutableArray*  mutableArray = [NSMutableArray arrayWithCapacity:2];
        NSLog(@"mutableArray arrayWithCapacity 2 count is %lu ", mutableArray.count);// 0
        [mutableArray addObject:@"如果数组元素是nil 不会遍历到 obj是NonNull"];
        //[mutableArray addObject:NULL]; // 不能是nil
        [mutableArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"NSMutableArray arrayWithCapacity 可以预先分配空间 但没有使用:  %lu %@ ", idx, obj);
        }];
      
    
        // 不可变数组
        // 1. 数组成员都必须是对象 NSInteger/long NSUInteger/unsigned int都是基本类型 必须转换成NSNumber  结构体要转换成NSValue  numberWith* valueWith*
        // 2. 数组元素可以是不同类型对象
        // 3. indexOfObject 是没有元素调用 isEqual 方法对比  找不到返回一个很大的整数 NSNotFound
        // 4.  @[] 可以创建NSArray 但是必须是对象 而且不能是null
    
        // 5. writeToFile 不能包含自定义的对象，也不能包含null  可以的类型是  (NSString, NSData, NSArray, or NSDictionary objects 文件是可以打开看到的
        // 6. 自定义类型数组 使用 ：NSKeyedArchiver archivedDataWithRootObject 编码序列化 打开是乱码 跟 NSArray writetoFile不一样; NSKeyedUnarchiver unarchivedObjectOfClasses 解码需要列举所有类型
         
    }
    
 
    
    
    {
        // 1. 集合Set和字典  无序集合
        // 2. Key和Value只能是对象  NSInteger long  也是基本类型
        // 3. 不能假设集合和字典的元素顺序
        
        NSSet* mySet = [NSSet setWithObjects:@"one", @"two", @"three", nil];
        
        [mySet enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
                    NSLog(@"NSSet 不能假设集合和字典的元素顺序 value %@",  obj);
        }];
        
        NSLog(@"NSSet anyObject 可以随机返回其中一个 %@ ", [mySet anyObject]);
        NSLog(@"NSSet containsObject 通过EqualTo判断 %s ", [mySet containsObject:@"two"]?"YES":"NO"); // YES 通过EqualTo判断
        NSLog(@"NSSet anyObject 可以随机返回其中一个 %@ ", [mySet anyObject]);
        
        NSDictionary* dict1 = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"hello",[NSNumber numberWithInt:1],
                              @"we", [NSNumber numberWithInt:2],
                              @"friends", [NSNumber numberWithInt:3],
                              @"are", [NSNumber numberWithInt:4],
                              @"forever", [NSNumber numberWithInt:5],
                              nil];
        [dict1 enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSLog(@"key %@ value %@", key, obj);
        }]; // 都是 3 2 5 1 4
        
        NSLog(@"----");
        NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"hello",[NSNumber numberWithInt:1],
                              @"we", [NSNumber numberWithInt:2],
                              @"friends", [NSNumber numberWithInt:3],
                              @"are", [NSNumber numberWithInt:4],
                              @"forever", [NSNumber numberWithInt:5],
                              nil];
        
        [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSLog(@"key %@ value %@", key, obj);
        }];
        
        
        NSLog(@"NSDictionary objectForKey 字典通过key来找value %@", [dict objectForKey:@"are"] );
        
    }
    
    {
        NSSet* set = [NSSet setWithObjects:[NSNumber numberWithFloat:12.3],[NSNumber numberWithFloat:13.4], [NSNumber numberWithFloat:14.5], nil];
        [set enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSNumber* t = obj ;
            NSLog(@"NSSet NSNumber floatValue = %f", [t floatValue]);
        }];
        
    }
    
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
    
    
    {
        NSString* str = @"中文abc.txt";
        const char* cstr = [str UTF8String];
        NSLog(@"NSString 转 utf-8 c char =%s", cstr); // 会乱码
        NSLog(@"NSString 转大写 %@", str.uppercaseString);
        NSLog(@"NSString 是否有后缀 %s", [str hasSuffix:@".txt"]?"YES":"NO"); // hasSuffix hasPrefix
        NSLog(@"NSString 转 int %d", [@"123 hello" intValue]); // 注意不成功返回0 !  如果开始有部分可以转换 就会转换
      
    }
    
    
    {
        // 可以用来判断网络连接
        NSURL* url = [NSURL URLWithString:@"http://www.baidu.com"];
        NSError* error ;
        NSString* html = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
        NSLog(@"NSString 获取指定url的html 内容 %@", html);
        
        // stringWithContentsOfFile  从文件读取NSString
        // stringWithContentsOfURL   从url网络获取NSString
    }
    
    {
        // 创建资源 Resource--String file  命名为en.strings zh.string
        NSLog(@"英文本地化结果 %@ %@", local(@"hello"), local(@"world"));
        SwitchLang(@"zh");
        NSLog(@"中文本地化结果 %@ %@", local(@"hello"), local(@"world")); // CommandLine无法使用本地化, ios app可以
    }
}
