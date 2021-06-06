//
//  forth.m
//  SimpleClass
//
//  Created by hehanlong on 2021/6/6.
//

#import <Foundation/Foundation.h>


#import "CategoryClass.h"

// clang -rewrite-objc MyClass.m 从m语言转换成cpp语言


@interface NSString(MyAdditions)
+(NSString *)getCopyRightString;
@end

@implementation NSString(MyAdditions)

+(NSString *) getCopyRightString {
   return @"分类 Category 还是使用原来的类名字";
}

@end

void forth()
{
    NSLog(@"%@", [NSString getCopyRightString]);
    
    CRobotSoldier* category = [[CRobotSoldier alloc] initId:__LINE__ withModel:@__FILE_NAME__];
    
    [category fire];
    
    // Thread 1: "-[CRobotSoldier nameWithoutSetterGetter]: unrecognized selector sent to instance 0x1030ca460"
    //NSLog(@"get category properties %@", category.nameWithoutSetterGetter);
    
    NSLog(@"get category properties 自己实现setter/getter ---1--- %@", category.nameWithSetterGetter); // (null)
    category.nameWithSetterGetter = @"objc 关联对象";
    NSLog(@"get category properties 自己实现setter/getter ---2--- %@", category.nameWithSetterGetter);
    
    
    NSLog(@"分类的实例的class,还是原来的class %@", [category class]); // CRobotSoldier
    
    
    category.fakeVoidAddressString = @"使用数字作为关联对象的key";
    NSLog(@"%@", category.fakeVoidAddressString);
    
    category.dynamicKeyString = @"使用@dynamic property @selector(property)作为关联对象的Key";
    NSLog(@"%@", category.dynamicKeyString);
    
}
