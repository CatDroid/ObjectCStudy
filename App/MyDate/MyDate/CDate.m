#import "CDate.h"

#define DATE_CALENDAR_FLAGS (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay| \
NSCalendarUnitQuarter | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond |\
NSCalendarUnitNanosecond | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth |\
NSCalendarUnitWeekOfYear | NSCalendarUnitYearForWeekOfYear | NSCalendarUnitWeekdayOrdinal)

// 和c++一样，objective c中静态变量使用static关键字进行定义。例如：static NSUInteger n; 需要注意的是该static变量的作用域，它的作用域是在定义该变量的.m文件范围内。
// 和c++不同，objective c不支持类静态成员变量（也就是不支持class variables），通常的做法是在class之外定义静态变量来代替



@implementation CDate
{
	// 实例成员
	NSDate* date ;
	NSDateComponents* comp;
	NSCalendar* cal;
}

static NSArray* sWeekDayName ;

// Objective-C为我们提供了两种方法去运行对类进行相关设置的代码
// https://www.jianshu.com/p/592fef0ee336
+ (void)initialize
{
    NSLog(@"obj-c 类的初始化函数  ");
    sWeekDayName =  @[@"", @"星期天",  @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
}
+(instancetype) new
{
	CDate* temp = [[CDate alloc] initWithDate:[NSDate date]];
	return temp ;
}

-(instancetype) initWithDate:(NSDate*)d
{
    self = [super init];
    
    if (self) {
        
        // GMT 0:00 格林威治标准时间
        // UTC +00:00 校准的全球时间
        // 任何NSTimeZone对象所代表的时区都是相对于GMT的, iOS中的时间类NSDate所获取到的时间, 都是相对于GMT的
        
        // 获取所有已知的时区
        //NSArray<NSString*>* timeZones = [NSTimeZone knownTimeZoneNames];
        //[timeZones enumerateObjectsUsingBlock:^(NSString* value, NSUInteger index, BOOL* stop) {
        //    NSLog(@"TimeZone = %@", value);
        //}];
        
        
        NSLog(@"locale = %@", [[NSLocale systemLocale] localeIdentifier]); // ""
        NSLog(@"locale = %@", [[NSLocale systemLocale] languageCode]); // null
        NSLog(@"countryCode = %@", [[NSLocale systemLocale] objectForKey: NSLocaleCountryCode]); // null
        
        
        
        // 德语(德国) de-de
        NSLocale * de = [[NSLocale alloc] initWithLocaleIdentifier:@"de-de"];
        NSLog(@"de NSLocal =  %@", de.localeIdentifier);
        
        NSTimeZone *timeZoneGerman = [NSTimeZone timeZoneWithName:@"Europe/Berlin"];
        NSLog(@"%@", timeZoneGerman);
        
        NSTimeZone *timeZoneJP = [NSTimeZone timeZoneWithName:@"Asia/Tokyo"];
        NSLog(@"%@", timeZoneJP);
        
        cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; //可以有不同的日历 Gregorian 公元年历  chinese 中国农历
        //cal.locale = [NSLocale systemLocale];
        cal.locale = de ; // ?? 没有作用 ?? description显示的语言??
        cal.timeZone = timeZoneGerman ; // 如果Calendar和NSDateComponent的timeZone一样 那么 comp.date时间是一样的

 
        // 指定的date 按照 compoents给的flag进行分解 计算 得到 NSDateComponents
        // calendar The calendar used to interpret the date components.
        // timeZone The time zone used to interpret the date components.
        
        // An instance of NSDateComponents is not responsible for answering questions about a date beyond the information with which it was initialized.For example, if you initialize one with May 4, 2017, its weekday is NSDateComponentUndefined, not Thursday.
        // NSDateComponents实例 并不会获取超过初始化他的信息, 比如如果只是设置了年月日 那么weekday信息也是未知的 不会自动计算
        comp = [cal components:DATE_CALENDAR_FLAGS fromDate:d];
        NSLog(@"create---comp = %@",comp);
        // 会根据 Calender的时区 设置NSDateComponents.hour信息  但是这时NSDateCompoents没有时区信息 （NSDate都是相对于GMT-0）
        NSLog(@"comp.timeZone %@", comp.timeZone); // null
        
        
        NSCalendar* calJP = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        calJP.timeZone = timeZoneJP;
        
        //comp.calendar = calJP;
        comp.calendar = cal ; // 可以指定另外一个日历  一定要设置 否则comp.date是nil
        
        NSLog(@"before---comp = %@",comp);
        NSLog(@"before---hour = %ld", comp.hour);
        NSLog(@"before---dateRefenceDate = %f", comp.date.timeIntervalSinceReferenceDate); // comp.date是有变化的
        NSLog(@"before---date = %@ after date = %@ ", [d description], [comp.date description]); // 相等
        NSLog(@"before comp.timeZone = %@", comp.timeZone); // nil
        
        comp.timeZone = [NSTimeZone localTimeZone]; // comp的信息改成了北京时间 ，计算的时候就不用Calendar的timeZone 直接按照这个时区和hour的信息 计算GMT-0的时间
        //comp.timeZone = timeZone;
        
        NSLog(@"after---comp = %@", comp);
        NSLog(@"after---hour = %ld", comp.hour); // 都一样的
        NSLog(@"after---dateRefenceDate = %f", comp.date.timeIntervalSinceReferenceDate);
        

        NSLog(@"date = %@ after date = %@ ", d, comp.date);
        NSLog(@"date = %@ after date = %@ ", [d description], [comp.date description]); // 原始描述 GMT-0
        // date = Sun May  9 18:48:05 2021 after date = Mon May 10 00:48:05 2021       如果Calendar不设置timeZone GMT+8
        // date = 2021-05-09 10:48:05 +0000 after date = 2021-05-09 16:48:05 +0000     NSDateComponents 设置timeZone为德国 GMT+2
        
        // comp.date参数是计算出来的 The date calculated from the current components using the stored calendar.
        // 通过指定的日历计算出来
        
        date =  d ;
        
        
        // 总结 从 本地时间 到  德国时间
        // 1. NSDate date  得到GMT-0时间
        // 2. NSTimeZone timeZoneWithName:@"Europe/Berlin"
        // 3. NSCalendar 并设置timeZone
        // 4. NSDateComponents = [calendar components: date: ]
        // 5. 这样NSDateComponents的年月日都是德国时间
        
    } else {
        NSLog(@"initWithDate fail super init");
    }
  
    return self ;
    
}

-(instancetype) initWithString:(NSString*) timeString  WithFormat:(NSString*)formatString
{
    //NSDateFormatter* format = [[NSDateFormatter alloc] init];
    //format.dateFormat = formatString ;
    //NSDate* date = [format dateFromString:timeString];
    return [self initWithDate:date];
}


-(NSLocale*) locale
{
    return cal.locale;
}

-(void) setLocale:(NSLocale*)l
{
    cal.locale = l;
    
    comp = [cal components:DATE_CALENDAR_FLAGS fromDate:date];
    comp.calendar = cal ; // ??
    comp.timeZone = [NSTimeZone localTimeZone]; // ???
}

-(NSTimeZone*) timeZone
{
    return comp.timeZone;
}

-(void) setTimeZone:(NSTimeZone*)zone
{
    comp.timeZone = zone ; // comp.date会修改??
}

-(NSDate*) date
{
    return comp.date;
}

-(void) setDate:(NSDate*)d
{
    comp = [cal components:DATE_CALENDAR_FLAGS fromDate:d];
    comp.calendar = cal ; // ??
    comp.timeZone = [NSTimeZone localTimeZone]; // ???
    
    
    date = d ;
    
}



// 实例方法
-(NSInteger) year
{
    return comp.year;
}

-(NSInteger) month
{
    return comp.month;
}

-(NSInteger) day
{
    return comp.day ;
}

-(NSInteger) hour
{
    return comp.hour;
}

-(NSInteger) minute
{
    return comp.minute;
}

-(NSInteger) second
{
    return comp.second;
}

-(NSInteger) nanosecond
{
    return comp.nanosecond;
}

-(NSInteger) quarter
{
    return comp.quarter;
}

-(NSInteger) weekday;
{
    return comp.weekday;
}

-(NSInteger) weekOfMonth
{
    return comp.weekOfMonth;
}

-(NSInteger) weekOfYear
{
    return comp.weekOfYear;
}

-(NSInteger) yearForWeekOfYear
{
    return comp.yearForWeekOfYear;
}

-(NSInteger) weekdayOrdinal
{
    return comp.weekdayOrdinal;
    // 工作日序数单位表示工作日在下一个较大的日历单位（例如月份）中的位置。 例如，2是该月第二个星期五的工作日序数单位。
}

-(NSString*) weekdayName
{
    return [sWeekDayName objectAtIndex: comp.weekday ];
}

-(NSTimeInterval) secondsSince1970
{
    return [comp.date timeIntervalSince1970];
}

-(NSTimeInterval) secondsSinceReferenceDate
{
    return [comp.date timeIntervalSinceReferenceDate];
}




@end
