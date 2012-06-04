//
//  MyDateFormatter.h
//  320Test
//
//  Created by zrz on 11-3-31.
//  Copyright 2011 zrz. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DateFormat			@"yyyy-M-d"
#define TimeFormat			@"HH:mm"
#define FullFormat          @"yyyy-M-d HH:mm:ss"

#define DatePlus(date, NSTimeInterval) [NSDate dateWithTimeIntervalSince1970:([date timeIntervalSince1970] + (NSTimeInterval))]

@interface MTDateFormatter : NSObject
{
}

+ (NSString*)stringFromDate:(NSDate*)date format:(NSString*)format;
+ (NSDate*)dateFromString:(NSString*)string format:(NSString*)format;
+ (NSString*)WeekChinese:(int)n;

@end


@interface NSString(DateFormatterString)

+ (NSString*)stringWithDate:(NSDate*)date format:(NSString*)format;
- (NSDate*)toDateWithFormat:(NSString*)format;

@end

@interface NSDate(DateFormatterDate)

+ (NSDate*)dateFromString:(NSString*)string format:(NSString*)format;
+ (NSString*)nowDataToString;
- (NSString*)toStringWithFormat:(NSString*)format;
- (NSUInteger)weekday;

@end