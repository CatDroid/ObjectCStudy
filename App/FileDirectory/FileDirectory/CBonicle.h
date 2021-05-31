#ifndef CBONICLE_HEADER 
#define CBONICLE_HEADER

#import <Foundation/Foundation.h> // Foundation.framework
#import <UIKit/UIKit.h> // CoreGraphics.framework  Targets--Build Phases(建造阶段)--Link Binary With Libraries

@interface CBonicle:NSObject <NSCoding>

// 结构体NSPoint、NSRect、与NSSize
@property NSString* name;
//@property NSPoint position; // NSPoint 只在MacOS 没有在IOS
@property CGPoint position; // struct CGPoint    Framework Core Graphics
@property int life ; 

-(instancetype) initWithName:(NSString*)name NS_DESIGNATED_INITIALIZER ;

-(instancetype) init NS_UNAVAILABLE;

/*
 typedef CGPoint NSPoint;
 struct CGPoint {
    CGFloat x;
    CGFloat y;
 */


-(void)fire;

// 析构函数
-(void)dealloc;

@end


#endif  
