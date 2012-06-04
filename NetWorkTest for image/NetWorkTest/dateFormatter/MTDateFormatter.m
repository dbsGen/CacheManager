//
//  MyDateFormatter.m
//  320Test
//
//  Created by zrz on 11-3-31.
//  Copyright 2011 zrz. All rights reserved.
//

#import "MTDateFormatter.h"


@implementation MTDateFormatter

static NSDateFormatter *df;

+ (void)checkNil
{
	if (!df) {
		df = [[NSDateFormatter alloc] init];
	}
}

+ (NSString*)stringFromDate:(NSDate*)date format:(NSString*)format
{
	[self checkNil];
	[df setDateFormat:format];
	return [df stringFromDate:date];
}

+ (NSDate*)dateFromString:(NSString*)string format:(NSString*)format
{
	[self checkNil];
	[df setDateFormat:format];
	return [df dateFromString:string];
}

+ (NSString*)WeekChinese:(int)n
{
	switch (n) {
		case 7:
			return @"星期日";
		case 1:
			return @"星期一";
		case 2:
			return @"星期二";
		case 3:
			return @"星期三";
		case 4:
			return @"星期四";
		case 5:
			return @"星期五";
		case 6:
			return @"星期六";
	}
	return @"未知";
}

@end

@implementation NSString(DateFormatterString)

+ (NSString*)stringWithDate:(NSDate*)date format:(NSString*)format
{
	return [MTDateFormatter stringFromDate:date format:format];
}

- (NSDate*)toDateWithFormat:(NSString*)format
{
	return [MTDateFormatter dateFromString:self format:format];
}

@end

@implementation NSDate(DateFormatterDate)

+ (NSDate*)dateFromString:(NSString*)string format:(NSString*)format
{
	return [MTDateFormatter dateFromString:string format:format];
}

+ (NSString*)nowDataToString
{
    return [MTDateFormatter stringFromDate:[NSDate date]
                                    format:FullFormat];
}

- (NSString*)toStringWithFormat:(NSString*)format
{
	return [MTDateFormatter stringFromDate:self format:format];
}

- (NSUInteger)weekday {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *weekdayComponents = [calendar components:(NSWeekdayCalendarUnit) fromDate:self];
	return [weekdayComponents weekday];
}

@end