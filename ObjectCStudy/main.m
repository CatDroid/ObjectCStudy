//
//  main.m
//  ObjectCStudy
//
//  Created by hohanloong on 2020/10/11.
//

#import <Foundation/Foundation.h>

#include "Shape.h"
#include "Circle.h"

int main(int argc, const char * argv[]) {
    
    //sleep(5);
    
    @autoreleasepool {
        /*
         @autoreleasepool 自动释放池： 管理内存的池，把不需要的对象放在自动释放池中，自动释放(延迟释放)这个池子内的对象。
         
         @autoreleasepool的应用场景:
                 存在大量临时变量的时候
                 非UI操作，如：命令行
                 自己创建辅助线程
         
         创建的新对象就放在我们新建的自动释放池里，而不是系统的主池里
         因为系统会在块的末尾把某些对象(例如这些临时对象)回收掉。
         
         每个Cocoa应用程序的主线程中已经有一个自动释放池
         
         
         obj autorelease
         当对象调用 autorelease 方法后会被放到自动释放池中延迟释放时机
         
         使用alloc/new/copy/mutableCopy的对象都不是Autorelease的，非以上方法创建的都是Autorelease的
         
         比如
         [NSMutableArray array]
         + (id)array {
             id obj = [[NSMutableArray alloc] init];//创建对象
             [obj autorelease];//延迟释放对象（谁创建谁释放）
             return obj;
         }
         使用[NSMutableArray array]创建对象时，因为本身不持有对象，又想取得对象存在。
         Autorelease就是提供了这样的功能，使对象在超出指定的生存范围时能够自动并正确地释放。

         Autorelease实际上只是把对release的调用延迟了，
         对于每一个Autorelease，系统只是把该Object放入了当前的AutoreleasePool中，当该pool被释放时，
         该pool中的所有Object会被调用Release。

         ARC 与 MRC 和 自动释放池 https://juejin.im/post/6844904094503567368
         
         */
      
        int a  = 10;

        // 不可变字符串
        // "格式串"创建一个字符串对象  格式串创建是最常见的字符串方法一, 用来做数据类型交换
        NSString *str = [[NSString alloc] initWithFormat:@"hello, %d", a];
        // 字符串字面值 必须有前缀 @
        NSLog(@"%@", str);
        
        // NSString 是不可变化字符串,
        // 所以拼接的方法实现是在内部创建了一个新的字符串对象作为返回值返回, 并不是操作原有的字符串
        NSString *newStr = [str stringByAppendingString:@" Append String"];
        
        NSLog(@"%@", newStr);
        
        
        // 通过一个字符串去创建另一个字符串,
        // 对于不可变的字符串来说, 这个方法多此一举, 所以系统会帮我们转变创建形式:
        // NSString *str2 = @"hello";
        NSString *str2 = [[NSString alloc] initWithFormat:@"hello"];
        
        NSLog(@"str2 lenght is %lu", str2.length);
        
        NSString *str3 = [NSString stringWithFormat:str2]; // 根据已经有的字符串生成新的
        
        NSLog(@"uppercase %@" , str3.uppercaseString); // 返回新的String
        
        
        // 字符串比较
        NSString *one = @"abcdef";
        NSString *two = @"abcdefg";
        NSLog(@"compare result %ld" ,[one compare:two]); // -1
        
        if (one == two) {
            NSLog(@"同一个对象: ");
        }
        
        if ([one isEqualToString:two]) {
            NSLog(@"字符串内容相同");
        }
        
        
        // 子串
        
        // NSRange: 表示范围一个结构体
        // 成员变量1: location: 开始位置
        // 成员变量2: lenth: 长度
        NSRange range = NSMakeRange(0,5);
        NSRange range2 = { 2, 8 };
        
        
        // 类
        // 在ObjC中类的实例化需要两个步骤：分配内存、初始化
        Shape *p=[Shape alloc]; // Shape类的静态方法alloc
                                // alloc方法是这样声明的  (id)alloc; 它的返回值类型是id
                                //  这个id代表任何指针类型，你可以暂时理解为：id可以代表任何OC对象，类似于NSObject *
        p = [p init];           // init是继承自NSObject
        //Shape *p = [[Shape alloc] init];  // 给类发送alloc消息。给对象发送init消息
        //Shape *p = [Shape new]; // oc-2.0 如果使用默认初始化方法进行初始化（没有参数），内存分配和初始化可以简写成[Person new]；
        
        
        //NSLog(@"is Private %d ", p->_isPrivateFlag); // 私有成员不能访问
        NSLog(@"没有初始化的成员属性(public) %d",  p->_id);
        //NSLog(@"没有初始化的成员属性(public) %@" , p->mIsPrivateString); // 异常。BAD_ACCESS address=0x0
        
        
        // ObjC中使用[]进行方法调用，在ObjC中方法调用的本质就是  "给这个对象或类发送一个消息" !
        [p run];
        
        [Shape staticMethonShowMessage:@"发送消息给类"];
        
        
        p._convex = true ; // 调用的是set方法 声明@property，同时通过@synthesize自动生成getter、setter方法
        NSLog(@" @property 自动生成setter和getter方法 %d",  p._convex);
        
        
        p.renameProperty = @" @synthesize 自动创建属性 和 setter/getter " ;
        NSLog( @"%@" , p.renameProperty);  // 占位符号 ”%@“  在NSLog中，使用%@表示要调用对象的description方法
        
        
        id p1 = [Shape createWithName:@"静态方法获得一个对象" AndId:120];
        NSLog( @"%@" , [p1 getName]);
        //[p1 NotSuchMethod];  使用?? id也可以判断??
        NSLog( @"description方法输出 %@" , p1 );
        NSLog( @"p1 instance address %p", p1 );
        
        
        
        Shape* p2 = [ [Circle alloc] initWithName:@"子类" AndId:666 AndRaduis:2];
        NSLog( @"子类对象给到父类指针 %@" , p2 );
        
        
        
        
        //[p1 release];
        
        //[p2 release]; // 'release' is unavailable: not available in automatic reference counting mode
     
        
        NSLog(@"----------last line of @autoreleasepool-------");
    } // 在这里会自动析构{}中创建的对象
    
    NSLog(@"autoreleasepool Exit");
    
    {
        NSLog(@"OutSize Of autoreleasepool begin ");
        Shape* p4 = [ [Circle alloc] initWithName:@"自动释放池外面" AndId:666 AndRaduis:2];
        [p4 getName];
        NSLog(@"OutSize Of autoreleasepool end ");
    } // 这里会释放 p4
   
    
    if (false)
    {
        NSLog(@"OutSize Of autoreleasepool begin 2");
        for (int z = 0 ; z < 100 ; z++) {
            Shape* p4 = [Shape createWithName:@"自动释放池外面" AndId:666];
            [p4 getName];
            NSLog(@"loop %d", z);
        } //每次循环都会及时释放的?? 即使没有了autoreleasepool
        NSLog(@"OutSize Of autoreleasepool end 2 ");
    }

    NSLog(@"Main Exit");
    
    {
        
        typedef NS_ENUM(NSInteger, FlyState) {
            FlyStateOne = 1 ,
            FlyStateTwo,
            FlyStateThree
        };
        
        /*
        
         NS_ENUM是一个OC中的宏，可以判断编译器能否采用新式枚举：如果不能，那么效果等同于仅仅使用typedef的enum；
        
         如果能够采用新式枚举，那么NS_ENUM所定义的枚举类型，就是处理后的enum类型，可以在使用typedef的同时，指定底层数据类型
        
         相当于
         enum FlyState : NSInteger {
             FlyStateOne,
             FlyStateTwo,
             FlyStateThree
         };
         typedef enum FlyState:NSInteger FlyState;
         
         */
        
        /*
         
         装箱与拆箱

         由于NSArray,NSDirectory等类不能直接存储基本数据类型，
         所以要想在NSArray＼NSDirectory中使用基本数据类型，就得使用装箱与拆箱
         
         将基本类型封装成对象叫装箱，从封装的对象中提取基本类型叫拆箱(取消装箱)，
         其它语言如Java原生支持装箱与拆箱，
         Ojbective-C不支持自动装箱与拆箱，如果需要得需要自己来实现装箱与拆箱。
         
         NSValue：适用于结构体类型的变量与oc对象的转换。

         NSNumber：适用于除了结构体变量之外的基本数据类型与oc对象之间的转换。
         
         */
        
        NSMutableDictionary *dictionary = [NSMutableDictionary new];
        //[dictionary setObject:FlyStateOne forKey:@"hello"];
        // 字典只能当OC对象，不能放C的基础类型，加@()就是变成NSNumber类型
        NSNumber* key = [NSNumber numberWithInt:12];
        id value = @(FlyStateOne); // 快速装箱 利用@()
        [dictionary setObject:value forKey:key];
         
        NSLog(@"feature number %lu", [dictionary count]);
        NSLog(@"feature map %@", dictionary);
        
        NSLog(@"拆箱结果 %d", [key intValue]); // [key floatValue]
        
        
        //自定义的结构体
        typedef struct{
            NSUInteger year;
            NSUInteger month;
            NSUInteger day;
        } JRDate;
        
        //创建一个对象
         JRDate date1 = {2016,1,1};

        //获取自定义的结构体 "类型的字符串"  @encode：编码  decode：解码
        char *structTypeString = @encode(JRDate);

        //装箱：参数1：要装箱的结构变量的地址。  参数2：表示类型的字符串
        NSValue *dateValue =[NSValue value:&date1 withObjCType:structTypeString];

        NSLog(@"NSValue 自定义结构体:%@",dateValue); //打印出来是二进制的 {length = 24, bytes = 0xe00700000000000001000000000000000100000000000000}
        NSLog(@"表示类型的字符串 %@", [NSString stringWithUTF8String:structTypeString]); // {?=QQQ}
        
     
        //拆箱：
        // 声明一个结构变量，用于存储拆箱之后的结果
        JRDate date2;

        //取出对应的结构体变量：没有返回值，直接将拆箱的结果存到变量对应的地址中。参数：新声明的变量的地址
        [dateValue getValue:&date2];

        NSLog(@"date2：%lu年%lu月%lu日",date2.year,date2.month,date2.day);
        
        
    }
    
    
    
  
    return 0;
}
