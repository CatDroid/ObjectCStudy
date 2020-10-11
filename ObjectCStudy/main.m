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
    @autoreleasepool {
      
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
        NSLog( @"%@" , p.renameProperty);  // 占位符号 ”%@“ 
        
        
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
    
    NSLog(@"Main Exit");
    
    return 0;
}
