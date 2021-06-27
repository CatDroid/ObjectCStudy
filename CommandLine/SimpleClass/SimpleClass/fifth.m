//
//  fifth.m
//  SimpleClass
//
//  Created by hehanlong on 2021/6/27.
//

#import <Foundation/Foundation.h>


@interface MyMemroy : NSObject

+(instancetype) object ; // 类方法 创建实例

-(instancetype) constructor ;

-(instancetype) init;
-(instancetype) initWith:(int)index ;
-(void) dealloc;


@end

@implementation MyMemroy

+(instancetype) object
{
    return [[MyMemroy alloc] init];
}

-(instancetype) constructor
{
    // Cannot assign to 'self' outside of a method in the init family
    // self 不能在 init*系列函数 以外赋值
//    self = [super init];
//    if (self) {
//        NSLog(@"MyMemroy constructor %p ", self);
//    } else {
//        NSLog(@"MyMemroy constructor out of memory ");
//    }
//    return self ;
    
    return [self init];
}

-(instancetype) init
{
    self = [super init];
    if (self) {
        NSLog(@"MyMemroy init %p ", self);
    } else {
        NSLog(@"MyMemroy init out of memory ");
    }
    return self ;
}

-(instancetype) initWith:(int)index
{
    self = [super init];
    if (self) {
        NSLog(@"MyMemroy initWith %p index = %d", self, index);
    } else {
        NSLog(@"MyMemroy initWith out of memory ");
    }
    return self ;
}

-(void) dealloc
{
    NSLog(@"MyMemroy dealloc %p ", self);
}



@end

void fifth()
{
    
    /*
     
     AutoreleasePool：自动释放池是 Objective-C 开发中的一种自动内存回收管理的机制，为了替代开发人员手动管理内存，
     
     实质上是使用编译器在适当的位置插入“release“、“autorelease“等内存释放操作。
     
     当对象调用 “autorelease“ 方法后, 会被放到“自动释放池“中, "延迟释放" 时机，
     当 "缓存池“ 需要 ”析构dealloc“ 时，会向这些 "Autoreleased对象" 做 "release释放"操作

    
     */
    @autoreleasepool {
         
        /*
         
         以 alloc, copy, ,mutableCopy和new这些方法
         会被默认标记为 __attribute((ns_returns_retained))
         以这些方法创建的对象,
         编译器在会在“调用方法外围” 要加上“内存管理代码retain/release”
         
         不以这些关键字开头的方法，
         会被默认标记为__attribute((ns_returns_not_retained))
         以这些方法创建的对象,
         编译器会在“方法内部” 自动加上 “autorelease方法”，
         这时创建的对象就会被“注册到自动释放池”中，同时其释放会延迟，等到“自动释放池” “销毁”的时候才释放。

        
         */
        
        NSLog(@"-1");
        __weak MyMemroy* weakMemory = nil;
        {
            // Assigning retained object to weak variable; object will be released after assignment
            // 分配后直接给弱引用，会立刻销毁 (使用init系列函数 强引用没有的话，会立刻析构)
            weakMemory = [[MyMemroy alloc] init];
            NSLog(@"--1 = weakMemory %@ " , weakMemory); // null
        }
        NSLog(@"1");
        
        NSLog(@"-2");
        __weak MyMemroy* weakMemory2 = nil;
        {
            MyMemroy* myMemory2 = [[MyMemroy alloc] init];
            weakMemory2 = myMemory2;
            NSLog(@"--2 = weakMemory2 %@ " , weakMemory2);
            myMemory2 = nil; // 在这个强引用释放的时候，对象就没有引用，析构函数被调用 跟shared_ptr一样
            NSLog(@"--2 = weakMemory2 %@ " , weakMemory2);
        }
        NSLog(@"2");
        

        
        
        
        NSLog(@"-3");
        __weak MyMemroy* weakMemory3 = nil;
        {
            MyMemroy* myMemory3 = [MyMemroy object];
            weakMemory3 = myMemory3;
            NSLog(@"--3 = weakMemory3 %@ " , weakMemory3);// not null
            myMemory3 = nil; // 使用非init/copy方式创建 延迟到autoreleasepool释放 才会析构对象
            NSLog(@"--3 = weakMemory3 %@ " , weakMemory3); // not null
        }
        NSLog(@"3");
        
        
        NSLog(@"-4");
        __weak MyMemroy* weakMemory4 = nil;
        {
            MyMemroy* myMemory4 = [[MyMemroy alloc] constructor];
            weakMemory4 = myMemory4;
            NSLog(@"--4 = weakMemory4 %@ " , weakMemory4);// not null
            myMemory4 = nil; // 使用非init/copy方式创建 延迟到autoreleasepool释放 才会析构对象
            NSLog(@"--4 = weakMemory4 %@ " , weakMemory4); // not null
        }
        NSLog(@"4");
        
        NSLog(@"-5");
        __weak MyMemroy* weakMemory5 = nil;
        {
            MyMemroy* myMemory5 = [[MyMemroy alloc] initWith:123];
            weakMemory5 = myMemory5;
            NSLog(@"--5 = weakMemory5 %@ " , weakMemory5);
            myMemory5 = nil; // 使用init返回的 都会在强引用减少为0的地方，立刻析构
            NSLog(@"--5 = weakMemory5 %@ " , weakMemory5); // nil
        }
        NSLog(@"5");
        
        
        NSLog(@"begin to leave @autoreleasepool");
    } // 这里才会析构 myMemory3 myMemrory4
    NSLog(@"end to leave @autoreleasepool");
    
}
