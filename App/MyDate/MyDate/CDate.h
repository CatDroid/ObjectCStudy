#ifndef CDATE_HEADER
#define CDATE_HEADER

#import <Foundation/Foundation.h>

@interface CDate:NSObject

// 类的初始化函数  
+ (void)initialize ;

// 初始化的方法
+(instancetype) new; // 类方法
-(instancetype) initWithDate:(NSDate*) date;
-(instancetype) initWithString:(NSString*) date WithFormat:(NSString*)format;

-(instancetype) init NS_UNAVAILABLE ;

// 计算属性 getter and setter

-(NSLocale*) locale;
-(void) setLocale:(NSLocale*)l;

-(NSTimeZone*) timeZone;
-(void) setTimeZone:(NSTimeZone*)zone;

-(NSDate*) date;
-(void) setDate:(NSDate*)d;



// 实例方法
-(NSInteger) year;
-(NSInteger) month;
-(NSInteger) day;
-(NSInteger) hour;
-(NSInteger) minute;
-(NSInteger) second;
-(NSInteger) nanosecond;
-(NSInteger) quarter;
-(NSInteger) weekday;
-(NSInteger) weekOfMonth;
-(NSInteger) weekOfYear;
-(NSInteger) yearForWeekOfYear;
-(NSInteger) weekdayOrdinal;

-(NSString*) weekdayName;

-(NSTimeInterval) secondsSince1970; // 1970.1.1    NSTimeInterval double的别名 单位是秒 精确度?
-(NSTimeInterval) secondsSinceReferenceDate; // 2001.1.1 参考时间点  NSTimeIntervalSince1970 两个时间点的秒数   


@end


#endif 
