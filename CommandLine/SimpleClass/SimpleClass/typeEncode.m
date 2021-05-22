//
//  typeEncode.m
//  SimpleClass
//
//  Created by hehanlong on 2021/5/22.
//

#import <Foundation/Foundation.h>


#import "CRobotSoldierSelfDestruct.h" // 分类 要import扩展的文件
#import "objc/runtime.h"

void typeEncode()
{
    {
        // 装箱：boxing，指的是将基本数据类型转为oc对象
        // 拆箱：unboxing，指的是将oc对象转为基本数据类型
        // 在这里我们要用到两个类－－NSValue和NSNumber
        // NSValue：适用于结构体类型的变量与oc对象的转换。
        // NSNumber：适用于除了结构体变量之外的基本数据类型与oc对象之间的转换
        typedef struct {
            NSUInteger year;
            NSUInteger month;
            NSUInteger day;
        } MyData;
        MyData cStruct = {2011,12,8};
        
        //获取自定义的结构体类型的字符串  @encode：编码  decode：解码
        char* cType = @encode(MyData); // 参数是类型 返回的是objc类型编码
        NSLog(@"Objective-C 类型编码  @encode is %s", cType); // {?=QQQ}  {Hello=QQQ}  // 如果struct后面没有名字 就是?
        
        NSValue* objcValue = [NSValue value:&cStruct withObjCType:cType];
        NSLog(@"自定义结构体 转换成NSValue %@", objcValue);//打印出来是二进制的
        
        MyData cDecodeStruct = {0,0,0,};
        [objcValue getValue:&cDecodeStruct];
        NSLog(@"NSValue getValue 解包为 %lu %lu %lu", cDecodeStruct.year, cDecodeStruct.month, cDecodeStruct.day);
        NSLog(@"NSValue objCType is %s", [objcValue objCType]); // "{?=QQQ}"
        
        // 封装之后只能用 compare得到对比结果 NSOrderedSame
        NSNumber* intNumber = [NSNumber numberWithInt:1];
        NSNumber* intNumberQuickPack = @(1);
        NSLog(@"NSNumber 组装: same object %d, same value %s",
              intNumber == intNumberQuickPack, [intNumber compare:intNumberQuickPack] == NSOrderedSame? "compare same":"compare not same");
        
       // Returns a C string containing the Objective-C type of the data contained in the number object.
        NSLog(@"NSNumber objCType is %s", [intNumber objCType]); // "i" 跟 @encode() compiler directive. 返回的一样
        
        // typedef long NSInteger; for iOS, macOS, Mac Catalyst, tvOS
        // NSInteger When building 32-bit applications, NSInteger is a 32-bit integer. A 64-bit application treats NSInteger as a 64-bit integer.
        // NSInteger在32bit应用是32bit 64bit应用是64bit  long也是 NSInteger只是long的别名
        
        /*
         Objective-C 类型编码
         
         + (NSValue *) value:(const void *)value  withObjCType:(const char *)type;
         + (NSValue *) valueWithBytes:(const void *)value  objCType:(const char *)type;
         + (nullable NSMethodSignature *)signatureWithObjCTypes:(const char *)types;
         
         ObjCType:(const char *)types 参数:
        
         ObjCTypes 的参数需要用 Objective-C 的编译器指令 @encode() 来创建，(参数是类型 返回的是objc类型编码)
         @encode() 返回的是 Objective-C 类型编码(Objective-C Type Encodings)。 把给定类型, 编码为一种内部表示的字符串  @encode(int) → "i"
         Objective-C 运行时库内部利用类型编码帮助加快消息分发
         
         c     char
         C     unsigned char   大写的是unsigned
         i     int
         s     short
         l     long
         q     long long
         f     float
         d     double
         B     C++ bool or a C99 _Bool
         v     void
         *     character string (char *) 字符串
         ------------------------------------
         [array type]       数组   [3f]
         {name=type...}     结构体 name是结构体的名字 {}
         (name=type...)     enum
         
         ------------------------------------
         bnum  bit field of num bits
         
         ------------------------------------
        
         :     method selector (SEL) 选择器
         #     class object (Class)  类
         @     object (whether statically typed or typed id) 对象
         ^type pointer to type 指针
         ？    unknown type (among other things, this code is used for function pointers) 函数指针? 如果结构体定义没有给名字 就是?
         
         指针的标准编码是加一个前置的 ^，而 char * 拥有自己的编码 *, 因为 C 的字符串被认为是一个实体，而不是指针
         BOOL 是 c，而不是某些人以为的 i。原因是 char 比 int 小，且在 80 年代 Objective-C 最开始设计的时候，每一个 bit 位都比今天的要值钱（就像美元一样） BOOL 更确切地说是 signed char
         
         */
        
        NSLog(@"void *     : %s", @encode(void *)); // ^v
        
        NSLog(@"BOOL       : %s", @encode(BOOL)); // c 大写的BOOL是objc的 signed char
        NSLog(@"bool       : %s", @encode(bool)); // B c++的bool
        
        NSLog(@"char *     : %s", @encode(char *)); // *    character string (char *) 不是 ^c
        NSLog(@"char **    : %s", @encode(char **));// ^*   字符串数组
        
        NSLog(@"NSObject * : %s", @encode(NSObject *));             // @ 这个不是指针 是对象
        NSLog(@"NSObject **: %s", @encode(typeof(NSObject **)));    // ^@ 这个才是指针 指向对象
        NSLog(@"NSError ** : %s", @encode(typeof(NSError **)) );    // ^@
        
        NSLog(@"Class      : %s", @encode(Class));    // #  也就是 struct objc_class* 作为特殊编码成 #
        NSLog(@"NSObject   : %s", @encode(NSObject)); // {NSObject=#}
        NSLog(@"NSString   : %s", @encode(NSString)); // {NSString=#}
        NSLog(@"id         : %s", @encode(id));       // @  struct objc_object* 作为特殊编码成 #
        NSLog(@"Selector   : %s", @encode(SEL));      // :
        
        // 直接传入NSObject 是个结构体 并且只有一个成员Class isa; 这个objc-type编码是# 结构题名字是NSObject, 合起来是{NSObject=#}
        NSLog(@"[NSObject] : %s", @encode(typeof([NSObject class]))); // # 这个是类  [NSObject class]返回的是isa Class类型
        //NSLog(@"[NSObject] : %s", @encode([NSObject class]));
       
        float floatArray[3] = {0.1f, 0.2f, 0.3f};
        NSLog(@"float[]    : %s", @encode(typeof(floatArray))); // [3f]
        
        typedef struct _struct {
            short a;
            long long b;
            unsigned long long c;
        } Struct;
        NSLog(@"struct     : %s", @encode(typeof(Struct))); // {_struct=sqQ} 就是  {name=type}
        
        //if ([NSObject class] == NSObject) { // 不能这样
        //
        //}
        
        
        // 获取类/类属性/方法等:
        // class_getProperty            objc_property_t property_getName property_getAttributes
        // class_getInstanceVariable    Ivar            ivar_getName     ivar_getTypeEncoding
        // class_getInstanceMethod      Method          method_getName   method_getTypeEncoding
        // class_getClassMethod         Method          method_copyArgumentType   method_copyArgumentType   method_getNumberOfArguments
        
        
        
        // 用 runtime 去获得类的属性 对应的 type encoding：
        objc_property_t property = class_getProperty([NSObject class], "description");
        if (property) {
            NSLog(@"类的属性 对应的类型编码 %s---%s", property_getName(property), property_getAttributes(property));
            // description---T@"NSString",R,C
            // R 表示 readonly，C 表示 copy，这都是属性的修饰词
            // T，也就是 type，后面跟的这段 @ "NSString" 就是 type encoding 并且用双引号的方式告诉了我们这个对象的实际类型是什么
            // 用
        } else {
            NSLog(@"无法获取类属性");
        }
        
//        objc_property_t property = class_getProperty([UIScrollView class], "delegate");
//        if (property) {
//            NSLog(@"%s - %s", property_getName(property), property_getAttributes(property));
//        } else {
//            NSLog(@"not found");
//        }
//        delegate - T@"<UIScrollViewDelegate>",W,N,V_delegate

       
        
        // 用 runtime 去获得类的实例变量
        Ivar ivar = class_getInstanceVariable([CRobot class], "_testFlag");
        if (ivar) {
            NSLog(@"类的实例变量 对应的类型编码 %s---%s", ivar_getName(ivar), ivar_getTypeEncoding(ivar));
            // _testFlag---B
            // 私有的实例变量也可以的
        } else {
            NSLog(@"无法获取类的实例变量");
        }
       
        //Method method = class_getInstanceMethod([UIView class], @selector(setFrame:));
        //Method method = class_getInstanceMethod([UIViewController class], @selector(title));
        Method method = class_getInstanceMethod([NSDateFormatter class], @selector(stringFromDate:));
        if (method) {
            NSLog(@"类的实例方法 对应的类型编码 %@---%s",
                  NSStringFromSelector(method_getName(method)), // NSStringFromSelector SEL可以转换成字符串  字符串可以得到SEL
                  method_getTypeEncoding(method)); // @24@0:8@16
        } else {
            NSLog(@"无法获取类的实例方法");
        }
        // -(void)setFrame:(CGRect)frame
        // setFrame: - v48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16
        
        // v 是表示函数的返回值是 void 类型
        
        // 48 表示函数参数表的长度（指返回值之后的所有参数，虽然返回值在 runtime 里也算是个参数）
        
        // @ 表示一个对象，在 ObjC 里这里传递的是 self，实例方法是要传递实例对象给函数的
        // 0 上面参数对应的 offset 第一个参数是self 偏移是0
        
        // : 表示一个 selector，用来指出要调用的函数是哪个 第二个参数是SEL 因为第一个参数是self(id) 占用了8个字节
        // 8 是 selector 参数的 offset，因为这是跑在 64-bit 设备上的，所以 @ 和 : 的长度都是 8
        
        // {CGRect={CGPoint=dd}{CGSize=dd}}
        //     是 CGRect 结构体的 type encoding，
        //     从这里也可以看出结构体嵌套使用时对应的 type encoding 是这种格式的
        //     这个结构体包含 4 个 double 类型的数据，所以总长度应该是 32
       //  16 是最后一个参数的 offset，加上刚刚的参数长度 32 正好是整个函数参数表的长度
        
        // - (NSString *)stringFromDate:(NSDate *)date;
        // @24@0:8@16
        // @ 返回的是一个对象
        // 24 参数的长度
        // @ 第一个参数 self
        // 0 第一个参数偏移 0
        // : 第二个参数 调用的函数 也就是 SEL
        // 8 第二个参数偏移 8
        // @ 第三个参数 是对象
        // 16 第三个参数 偏移 16  存的也是个地址8个字节  8+16=24 就是参数总长度
        
       
        Method method2 = class_getClassMethod([NSTimer class], @selector(scheduledTimerWithTimeInterval:repeats:block:));
        if (method2) {
            NSLog(@"类的类方法 对应的类型编码:\n  函数名字%@\n  函数objc类型编码%s\n  函数参数个数%d\n  返回值编码:%s\n  第0个参数类型编码:%s\n  第4个参数类型编码:%s\n  超出参数个数:%s\n",
                  NSStringFromSelector(method_getName(method2)), // method_getName 返回的是SEL
                  method_getTypeEncoding(method2),               // @36@0:8d16c24@?28
                  method_getNumberOfArguments(method2),          // 参数的个数 5 个
                  method_copyReturnType(method2),                // @ 返回的是个对象
                  method_copyArgumentType(method2, 0),           // 从0开始 包含一个self,接收信息的对象,可以是类;
                  method_copyArgumentType(method2, 4),           // block的类型编码是 @?  函数对象
                  method_copyArgumentType(method2, 5)            // 超出返回null
                  );
        } else {
            NSLog(@"无法获取类的类方法");
        }
  
        
        /*
         @interface NSObject <NSObject> {
         #pragma clang diagnostic push
         #pragma clang diagnostic ignored "-Wobjc-interface-ivars"
            Class isa  OBJC_ISA_AVAILABILITY;
         #pragma clang diagnostic pop
         }
        
         typedef struct objc_object {
             Class isa;
         } *id;
        
        // typedef struct objc_class *Class;
        struct objc_class {
            Class isa;
            Class super_class;
            // followed by runtime specific details...
        };
        
        // 类方法 返回自身
        + (Class)class {
            return self;
        }
        // 实例方法 查找isa
        - (Class)class {
            return object_getClass(self);
        }

        Class object_getClass(id obj)
        {
            if (obj) return obj->getIsa(); // 涉及 isTaggedPointer 概念
            else return Nil;
        }
        */
        
    }
}
