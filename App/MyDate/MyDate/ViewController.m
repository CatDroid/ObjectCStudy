//
//  ViewController.m
//  MyDate
//
//  Created by hehanlong on 2021/5/9.
//

#import "ViewController.h"
#import "CDate.h"

#include <mach/mach_time.h>
#include <stdint.h>


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *text1;
@property (weak, nonatomic) IBOutlet UITextField *text2;
@property (weak, nonatomic) IBOutlet UITextField *text3;
@property (weak, nonatomic) IBOutlet UITextField *text4;
@property (weak, nonatomic) IBOutlet UITextField *text5;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    NSDate *date = [NSDate date];
    NSLog(@" date %@ \n descriptionWithLocale %@ \n description %@ \n",
          date , // %@ 考虑时区
          [date descriptionWithLocale:[ [NSLocale alloc] initWithLocaleIdentifier:@"de-de"]], // 只是本地化显示
          [date description] // GMT为0
          );
    // date Sun May  9 18:31:42 2021
   //  descriptionWithLocale Sonntag, 9. Mai 2021 um 18:31:42 Chinesische Normalzeit  德文显示
   //  description 2021-05-09 10:31:42 +0000   GMT为0
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    NSString *dateStr = [formatter stringFromDate:date];
    NSLog(@"字符串时间 = %@", dateStr);  // 2021-05-09 21:11:18 +0800

    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr2 = [formatter2 stringFromDate:date];
    NSLog(@"字符串时间 = %@", dateStr2); // 2021-05-09 21:11:18 +0800
    
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSTimeInterval interval = [zone secondsFromGMTForDate:date];// 固定相差8个小时
    NSDate *current = [date dateByAddingTimeInterval:interval];
    NSLog(@"inteval %f %@ %@", interval/3600.0, date, current);// descripion 都会按照当前系统的时区

    // 创建特定时间的NSDate方式
    NSDateFormatter *mmddccyy = [[NSDateFormatter alloc] init];
    mmddccyy.timeStyle = NSDateFormatterNoStyle;
    mmddccyy.dateFormat = @"MM/dd/yyyy";
    NSDate *d = [mmddccyy dateFromString:@"12/11/2005"];
    NSLog(@"创建特定时间的NSDate方式 NSDateFormatter  %@", d);
    
    
    NSCalendar *g = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.year = 2001;
    comps.month = 8;
    comps.day = 15;
    NSDate *myDate2 = [g dateFromComponents:comps];
    NSLog(@"创建特定时间的NSDate方式 NSCalendar  %@", myDate2);
    

    
    CDate* myDate = [[CDate alloc]initWithDate:[NSDate date]];
    _text1.text = [NSString stringWithFormat:@"locale = %@", myDate.locale.countryCode] ;
    
    
    // https://stackoverflow.com/questions/2129794/how-to-log-a-methods-execution-time-exactly-in-milliseconds
    
    // Unlike NSDate or CFAbsoluteTimeGetCurrent() offsets, mach_absolute_time() and CACurrentMediaTime() are based on the internal host clock, a precise, monatomic measure, and not subject to changes in the external time reference, such as those caused by time zones, daylight savings, or leap seconds.
  
#define TICK   NSDate* __startTime = [NSDate date]
#define TOCK   NSLog(@">>>>>>>>>>>>>>> Total Runtime(NSDate) %s Time: %f", __func__, -[__startTime timeIntervalSinceNow])
    
    
    CFTimeInterval startTime = CACurrentMediaTime();
    TICK;
    [NSThread sleepForTimeInterval:1.0];
    TOCK;
    CFTimeInterval endTime = CACurrentMediaTime(); // double 包含休眠的时间  walltime
    NSLog(@">>>>>>>>>>>>>> Total Runtime(CACurrentMediaTime): %g s", endTime - startTime);
   
    const uint64_t startTimeA = mach_absolute_time();
    [NSThread sleepForTimeInterval:1.0];
    const uint64_t endTimeA = mach_absolute_time();

    // Time elapsed in Mach time units.
    const uint64_t elapsedMTU = endTimeA - startTimeA;
    
    // Get information for converting from MTU to nanoseconds
    mach_timebase_info_data_t info; // 时间单位转换 mach tick units 到 nanoseconds
    if (mach_timebase_info(&info)) {
        NSLog(@"Get machine info fail");
    } else {
        // Get elapsed time in nanoseconds:
        const double elapsedNS = (double)elapsedMTU * (double)info.numer / (double)info.denom;
        NSLog(@">>>>>>>>>>>>>>>>> Total Runtime(mach_absolute_time): %g s", elapsedNS / 1000000000 );
    }
    

    
    
    
}


@end
